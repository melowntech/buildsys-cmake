#!/usr/bin/env python
# -*- python -*-

import sys

def parseInt(s):
    if (s.startswith("0x")):
        return int(s, 16)
    if (s.startswith("0")):
        return int(s, 8)
    return int(s)

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
sbegin = parseInt(sys.argv[2])
slen = parseInt(sys.argv[3])
prefix = sys.argv[4]

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
