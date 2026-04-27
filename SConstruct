#!/usr/bin/env python
import os
import sys

# Change this to the name of your library
lib_name = "algo_heist_cpp"

# 1. Paths
# Assumes godot-cpp is a folder in your root directory
godot_cpp_path = "godot-cpp"

# 2. Setup Environment
env = SConsEnvironment(
    variables=Variables(),
    platform=ARGUMENTS.get("platform", "linux"),
    target=ARGUMENTS.get("target", "template_debug"),
    arch=ARGUMENTS.get("arch", "x86_64"),
)

# 3. Add Godot-cpp logic
env.Append(CPPPATH=["src/", godot_cpp_path + "/gen/include/", godot_cpp_path + "/include/"])
env.Append(LIBPATH=[godot_cpp_path + "/bin/"])
env.Append(LIBS=["godot-cpp.linux.template_debug.x86_64"]) # Change if using a different platform build

# 4. Find your source files (Adjust folder name if needed)
sources = Glob("Scripts/Graphs/*.cpp")

# 5. Build the library
library = env.SharedLibrary(
    "bin/lib" + lib_name + "{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
    source=sources,
)

Default(library)
