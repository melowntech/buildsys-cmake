# Returns all variables as a CMAKE list (semicolon-separated) in the following
# format: name;value;name;value
#
# Variables with list value have individual elements separated by TAB ('\t')

import tensorflow as tf

res = []

res.append("TENSORFLOW_VERSION")
res.append(tf.__version__)

res.append("TENSORFLOW_INCLUDE_DIR")
res.append(tf.sysconfig.get_include())

res.append("TENSORFLOW_LIBRARY_DIR")
res.append(tf.sysconfig.get_lib())

definitions = []
for flag in tf.sysconfig.get_compile_flags():
    if flag.startswith("-D"):
        definitions.append(flag[2:])

res.append("TENSORFLOW_DEFINITIONS")
res.append("\t".join(definitions))

libraries = []
for flag in tf.sysconfig.get_link_flags():
    if flag.startswith("-l"):
        libraries.append(flag[2:])

res.append("TENSORFLOW_LIBRARIES")
res.append("\t".join(libraries))

print(';'.join(res))
