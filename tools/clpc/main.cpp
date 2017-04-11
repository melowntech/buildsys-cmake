/**
 * Copyright (c) 2017 Melown Technologies SE
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * *  Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <vector>
#include <set>
#include <stdexcept>
#include <iostream>
#include <sstream>
#include <fstream>

#include <boost/optional.hpp>
#include <boost/program_options.hpp>
#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/format.hpp>

#include <CL/cl.h>

namespace po = boost::program_options;
namespace fs = boost::filesystem;

struct ImmediateExit {
    ImmediateExit(int code = EXIT_SUCCESS) : code(code) {}
    int code;
};

void check(::cl_int err, const char *what)
{
    if (err != CL_SUCCESS) {
        std::cerr << what << ": failed with error " << err << std::endl;
        throw std::runtime_error(what);
    }
}

template <typename T> struct Releaser;

#define RELEASER(TYPE, FUNCTION)                                    \
    template <> struct Releaser<TYPE> {                             \
        ::cl_int release(TYPE value) { return FUNCTION(value); }    \
    }

RELEASER(::cl_context, ::clReleaseContext);
RELEASER(::cl_program, ::clReleaseProgram);
RELEASER(::cl_kernel, ::clReleaseKernel);

#undef RELEASER

template <typename T>
struct Resource : Releaser<T> {
    Resource(T resource) : resource_(resource) {}
    ~Resource() { check(Releaser<T>::release(resource_), "release"); }
    Resource(const Resource&) = delete;
    Resource& operator=(const Resource&) = delete;
    Resource(Resource &&r) : resource_(r.resource_) { r.resource_ = T(); }

    operator T() const { return resource_; }

private:
    T resource_;
};

struct Device {
    ::cl_platform_id platform;
    ::cl_device_id id;
};

std::vector< ::cl_platform_id> listPlatforms()
{
    // find out how many platforms we have
    ::cl_uint count(0);
    check(::clGetPlatformIDs(0, 0x0, &count), "clGetPlatformIDs");

    // grab platforms
    std::vector< ::cl_platform_id> platforms(count);
    check(::clGetPlatformIDs(count, platforms.data(), 0x0)
          , "clGetPlatformIDs");
    return platforms;
}

Device findCpuDevice()
{
    for (auto platform : listPlatforms()) {
        ::cl_device_id devices[1];
        ::cl_uint dCount(0);

        if (::clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU
                             , 1, devices, &dCount) != CL_SUCCESS)
        {
            continue;
        }

        return { platform, devices[0] };
    }

    throw std::runtime_error("No CPU device found.");
}

std::string buildInfo(::cl_program program, ::cl_device_id device)
{
    size_t size(0);

    check(::clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0
                                  , nullptr, &size)
          , "clGetProgramBuildInfo");

    std::vector<char> buf(size);
    check(::clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, size
                                  , buf.data(), &size)
          , "clGetProgramBuildInfo");
    return std::string(buf.data());
}

std::vector<Resource< ::cl_kernel> > createKernels(::cl_program program)
{
    ::cl_uint count;
    check(::clCreateKernelsInProgram(program, 0, 0x0, &count)
          , "clCreateKernelsInProgram");
    std::vector< ::cl_kernel> kernels(count);
    check(::clCreateKernelsInProgram(program, count, kernels.data(), 0x0)
          , "clCreateKernelsInProgram");

    return { kernels.begin(), kernels.end() };
}

std::string kernelName(::cl_kernel kernel)
{
    ::size_t size;
    check(::clGetKernelInfo(kernel, CL_KERNEL_FUNCTION_NAME, 0, 0x0, &size)
          , " clGetKernelInfo");

    std::vector<char> name(size - 1);
    check(::clGetKernelInfo(kernel, CL_KERNEL_FUNCTION_NAME, size, name.data()
                            , 0), " clGetKernelInfo");

    // this will stop at the \0
    return { name.data() };
}

std::size_t kernelArgCount(::cl_kernel kernel)
{
    ::cl_uint count;
    check(::clGetKernelInfo(kernel, CL_KERNEL_NUM_ARGS, sizeof(count)
                            , &count, 0), " clGetKernelInfo");
    return count;

}

void compile(const std::string &filename
             , ::cl_context context, ::cl_device_id device
             , const std::string &code
             , const char *options)
{
    const char *data(code.data());
    std::size_t size(code.size());

    ::cl_int err(0);
    Resource< ::cl_program>
        program(::clCreateProgramWithSource
                (context, 1, &data, &size, &err));
    check(err, "clCreateProgramWithSource");

    err = ::clBuildProgram(program, 1, &device, options, nullptr, nullptr);

    auto bi(buildInfo(program, device));

    if (err != CL_SUCCESS) {
        std::cerr << "Failed to compile file \"" << filename
                  << "\", build log follows:" << std::endl;
        std::cerr << bi << std::endl;
        throw ImmediateExit(EXIT_FAILURE);
    }

    std::cerr << "File " << filename
              << " compiled successfully, found kernels:\n";
    for (const auto &kernel : createKernels(program)) {
        std::cerr << "    " << kernelName(kernel) << "("
                  << kernelArgCount(kernel) << ")" << std::endl;
    }

    if (!bi.empty()) {
        std::cerr << "build log follows:\n" << bi << std::endl;
    }
}

// FIXME: handle multiline comments that start on previous line

typedef std::set<fs::path> SeenFiles;

typedef std::vector<std::string> Includes;
typedef boost::optional<Includes> OptIncludes;

void processLine(SeenFiles &seen
                 , std::string &code
                 , const fs::path &current
                 , std::size_t lineno
                 , const std::string &line
                 , const fs::path &dir
                 , const Includes &includes);

void readCode(SeenFiles &seen, std::string &code, const fs::path &filename
              , const Includes &includes)
{
    if (!seen.insert(canonical(filename)).second) {
        return;
    }

    // start code with line source file name info
    code.append(str(boost::format("#line 1 %s\n")  % filename));

    std::ifstream f;
    f.exceptions(std::ios::badbit);
    f.open(filename.string(), std::ios_base::in);

    const auto current(filename.parent_path());

    // read input line-by-line
    std::string line;
    std::size_t lineno(1);
    while (std::getline(f, line)) {
        processLine(seen, code, filename, lineno, line, current, includes);
        ++lineno;
    }

    f.close();
}

boost::regex includeRegex
(R"raw(^[[:space:]]*#[[:space:]]*include[[:space:]]*("(.*)"|<(.*)>).*$)raw"
 , boost::regex::perl);

void processLine(SeenFiles &seen
                 , std::string &code
                 , const fs::path &current
                 , std::size_t lineno
                 , const std::string &line
                 , const fs::path &dir
                 , const Includes &includes)
{
    boost::smatch match;
    auto res(regex_match(line, match, includeRegex
                         , boost::regex_constants::match_any));
    if (!res) {
        // no match
        code.append(line);
        code.push_back('\n');
        return;
    }

    int group(match[2].matched ? 2 : 3);
    fs::path toInclude(match[group].first, match[group].second);
    fs::path path;

    auto local(dir / toInclude);
    if (exists(local)) {
        path = local;
    } else for (const auto &include : includes) {
        auto tmp = include / toInclude;
        if (exists(tmp)) {
            path = tmp;
            break;
        }
    }

    if (path.empty()) {
        std::ostringstream os;
        os << current.string() << ":" << lineno << ": "
            " cannot find include file " << toInclude << ".";
        throw std::runtime_error(os.str());
    }

    readCode(seen, code, path, includes);

    // tell we are back
    code.append(str(boost::format("#line %d %s\n") % (lineno + 1) % current));
}

std::string readCode(const fs::path &filename, const OptIncludes &includes)
{
    if (includes) {
        SeenFiles seen;
        std::string code;
        readCode(seen, code, filename, *includes);
        return code;
    }

    // single file, no includes performed
    std::ifstream f;
    f.exceptions(std::ios::badbit | std::ios::failbit);
    f.open(filename.string(), std::ios_base::in);
    std::string code{std::istreambuf_iterator<char>(f)
            , std::istreambuf_iterator<char>()};
    f.close();
    return code;
}

void writeCode(const fs::path &filename, const std::string &code)
{
    std::ofstream f;
    f.exceptions(std::ios::badbit | std::ios::failbit);
    f.open(filename.string(), std::ios_base::out | std::ios_base::trunc);
    f.write(code.data(), code.size());
    f.close();
}

void compileFile(const fs::path &filename, const std::string &options
                 , ::cl_context context, ::cl_device_id device
                 , const OptIncludes &includes
                 , const fs::path &output)
{
    try {
        auto code(readCode(filename, includes));
        compile(filename.string(), context, device
                , code, options.c_str());

        if (!output.empty()) {
            writeCode(output, code);
        }
    } catch (const std::exception &e) {
        std::cerr << "Failed to compile file " << filename
                  << ": " << e.what() << std::endl;
        throw ImmediateExit(EXIT_FAILURE);
    }
}

std::pair<std::string, std::string> clOptionParser(const std::string &s)
{
    if ((s.find("-cl-") == 0)
        || (s == "-Werror")
        || (s == "-w"))
    {
        return {"option", s};
    }

    return {"", ""};
}

int main(int argc, char *argv[])
{
    po::options_description cmdline("Command line options");

    bool resolveIncludes(false);
    OptIncludes includes(Includes{});
    std::ostringstream opts;

    // this tells kernel writers that we are running inside checker
    opts << "-D BUILDSYS_OPENCL_CHECK";

    fs::path input;
    fs::path output;

    try {
        std::vector<std::string> defines;
        std::vector<std::string> options;

        cmdline.add_options()
            ("help", "produce help message")
            ("include,I", po::value(includes.get_ptr())
             , "Include directory.")
            ("define,D", po::value(&defines)
             , "Define a macro.")
            ("option", po::value(&options)
             , "CL option in format -cl-*, -Werror or -w.")
            ("resolveIncludes,i", "Resolve all #include directives.")
            ("input", po::value(&input)->required(), "Input .cl file.")
            ("output", po::value(&output), "Output .cl file (optional).")
            ;
        po::positional_options_description po;
        po.add("input", 1);
        po.add("output", 1);

        po::variables_map vm;
        auto parser(po::command_line_parser(argc, argv)
                    .options(cmdline)
                    .positional(po)
                    .extra_parser(clOptionParser));
        auto parsed(parser.run());
        po::store(parsed, vm);
        po::notify(vm);

        if (vm.count("help")) {
            std::cout << cmdline << "\n";
            return EXIT_SUCCESS;
        }

        resolveIncludes = vm.count("resolveIncludes");
        if (!resolveIncludes) {
            for (const auto &include : *includes) {
                opts << " -I " << include;
            }
            includes = boost::none;
        }
        for (const auto &define : defines) { opts << " -D " << define; }
        for (const auto &option : options) { opts << ' ' << option; }
    } catch (const std::exception &e) {
        std::cerr << "configuration error: " << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    try {
        auto device(findCpuDevice());

        ::cl_int err(0);
        Resource< ::cl_context> context
            (::clCreateContext(nullptr, 1, &device.id
                               , nullptr, nullptr, &err));
        check(err, "clCreateContext");

        compileFile(input, opts.str(), context, device.id, includes
                    , output);
    } catch (const ImmediateExit &e) {
        return e.code;
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }
}
