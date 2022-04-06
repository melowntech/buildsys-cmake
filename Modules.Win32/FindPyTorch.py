# Returns all variables as a CMAKE list (semicolon-separated) in the following
# format: name;value;name;value
#
# Variables with list value have individual elements separated by TAB ('\t')

import torch

import os.path

res = []

res.append("__pytorch_version")
res.append(torch.__version__)

res.append("PYTORCH_DIR")
res.append(os.path.dirname(torch.__file__))

print(';'.join(res))
