import os
import glob
import re
import subprocess

def find_dumpbin():
    dumpbin = subprocess.run([
        os.environ.get("ProgramFiles(x86)") + "/Microsoft Visual Studio/Installer/vswhere.exe", 
        '-all', '-products', '*', '-latest', '-find', '**/dumpbin.exe'], stdout=subprocess.PIPE)
    dumpbin = dumpbin.stdout.decode('utf-8').split('\n')
    if len(dumpbin):
        return dumpbin[0].strip()
    else:
        return "dumpbin.exe"

def get_dependencies(binary_path, dumpbin):
    result = subprocess.run([dumpbin, '/dependents', binary_path], stdout=subprocess.PIPE)
    found_dlls = re.findall(r'[^\s]*.dll', result.stdout.decode('utf-8'))
    return [os.path.basename(dll) for dll in found_dlls]

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Filter redundant DLLs from directory.')
    parser.add_argument('directory', type=str, help="Path to directory with *.exe and *.dll files.")
    parser.add_argument('-r', '--remove', action='store_true', help="Remove redundant *.dll files.")
    parser.add_argument('-k', '--keep', action='append', type=str, help="Keep specified *.dll files.")
    parser.add_argument( '--dumpbin', type=str, default=None, help="Path to 'dumpbin.exe'.")
    args = parser.parse_args()

    if os.name != 'nt':
        print("ERROR: This script could be run only on Windows OS!")
        exit(1)

    DIRECTORY = args.directory
    DUMPBIN = args.dumpbin

    if DUMPBIN is None:
        DUMPBIN = find_dumpbin()

    print(f"DIRECTORY = {DIRECTORY}")
    print(f"DUMPBIN = {DUMPBIN}")
    print()

    dependencies = set()
    # get extra dependencies
    extra_deps = [] if args.keep is None else args.keep
    for keep in extra_deps:
        dependencies.update([os.path.basename(dll) for dll in glob.glob(os.path.join(DIRECTORY, f"*{keep}*"))])

    # get executable dependencies
    for executable in glob.glob(os.path.join(DIRECTORY, "*.exe")):
        dependencies.update(get_dependencies(executable, DUMPBIN))

    # get recursive dll dependencies
    last_dependencies_len = 0
    while last_dependencies_len != len(dependencies):
        last_dependencies_len = len(dependencies)
        for dll in list(dependencies):
            dll_path = os.path.join(DIRECTORY, dll)
            if os.path.exists(dll_path):
                dependencies.update(get_dependencies(dll_path, DUMPBIN))

    # collect present used/redundant dlls
    used_dlls, unused_dlls = [], []
    for dll in glob.glob(os.path.join(DIRECTORY, "*.dll")):
        if os.path.basename(dll) in dependencies:
            used_dlls += [dll]
        else:
            unused_dlls += [dll]

    print(f"Used DLLs: \n{[os.path.basename(dll) for dll in used_dlls]}")
    print()
    print(f"Redundant DLLs: \n{[os.path.basename(dll) for dll in unused_dlls]}")

    if args.remove and len(unused_dlls):
        print()
        print("Removing redundant DLLs:")
        for dll in unused_dlls:
            print(f"Removing '{dll}'")
            os.remove(dll)
