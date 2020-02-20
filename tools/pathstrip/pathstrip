#!/usr/bin/env python
# -*- python -*-

import sys

def get_rodata(path):
    """
    Get offset and size of .rodata section from given elf file
    """
    from elftools.elf.elffile import ELFFile
    file = open(path, "rb")
    elf = ELFFile(file)

    def get_section(elf, name):
        for section in elf.iter_sections():
            if section.name == name: return section
        return none

    rodata = get_section(elf, ".rodata")
    if rodata is None:
        # no .rodata section -> ignore
        return (0, 0)

    return (rodata["sh_offset"], rodata["sh_size"])

def process(s):
    # find last slash and erase everything before
    slash = s.rfind('/')
    if slash == -1:
        return s

    # replace everything before slash with space
    return " " * slash

def findFirstOf(data, index, chars):
    ret = len(data)
    for c in chars:
        end = data.find(c, index)
        if (end >= 0) and (end < ret):
            ret = end
    if ret < len(data):
        return ret
    return -1

def cutAndProcess(f, off, data, index):
    # terminator is first occurence of NUL, newline or quotes character
    end = findFirstOf(data, index, "\0\n\"")
    if end == -1:
        return len(data)

    s = data[index:end]
    o = process(s)
    print >> sys.stderr \
      , ("0x{:08x} found string '{}' ({} bytes), writing '{}' ({} bytes)"
         .format(off + index, s, len(s), o, len(o)))
    if len(o):
        f.seek(off + index)
        f.write(o);
    return end + 1;

f = sys.argv[1]
prefix = sys.argv[2]
sbegin, slen = get_rodata(f)

# no .rodata section -> ignore
if not slen:
    sys.exit(0)

ifile = file(f, "r+b")

ifile.seek(sbegin)
src = ifile.read(slen)

ifile.seek(sbegin)
i = 0
while i < slen:
    b = src.find(prefix, i)
    if b == -1:
        break;
    i = cutAndProcess(ifile, sbegin, src, b)
