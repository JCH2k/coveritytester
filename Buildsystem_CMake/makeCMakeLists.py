#!/usr/bin/python
import os, sys, fnmatch

# function findFiles
# returns all files in a directory matching a pattern
def findFiles(directory, pattern):
	for root, dirs, files in os.walk(directory):
		for basename in files:
			if fnmatch.fnmatch(basename, pattern):
				filename = os.path.join(root, basename)
				yield filename

DIRS = []

for eachArg in sys.argv:
	if eachArg != __file__:
		if os.path.isdir(eachArg):
			DIRS += [eachArg]
		else:
			print "is not a directory: '" + eachArg + "'"

if not DIRS:
	print "no directory specified, using current directory"
	DIRS = ["."]

olddir = os.getcwd()

for dir in DIRS:
	# check if CMakeLists.txt already exists
	if os.path.exists(dir + "/CMakeLists.txt"):
		print "file '" + dir + "/CMakeLists.txt' already exists"
	else:
		os.chdir(dir)
		f = open("CMakeLists.txt", "w")
		target = os.path.split(dir)[-1]
		if target == ".":
			target = os.path.basename(os.getcwd())
		f.write("set( TARGET " + target + " )\n")
		f.write("\n")
		f.write("set( SOURCE_FILES\n")
		for cppFile in findFiles(".", "*.cpp"):
			f.write("	" + cppFile.replace("\\", "/") + "\n")
		for cFile in findFiles(".", "*.c"):
			f.write("	" + cFile.replace("\\", "/") + "\n")
		f.write(")\n")
		f.write("\n")
		f.write("add_library( ${TARGET} ${SOURCE_FILES} )\n")
		f.write("\n")
		f.write("target_link_libraries( ${TARGET}\n")
		f.write("	ESA_Interface\n")
		f.write(")\n")
		f.write("\n")
		f.write("target_include_directories( ${TARGET}\n")
		f.write("	" + "PRIVATE\n")
		f.write("	" + "	" + "${CMAKE_CURRENT_SOURCE_DIR}/inc/"+target+"\n")
		f.write("	" + "PUBLIC\n")
		f.write("	" + "	" + "${CMAKE_CURRENT_SOURCE_DIR}/inc\n")
		f.write(")\n")
		f.close()
		os.chdir(olddir)
		print "file '" + dir + "/CMakeLists.txt' created"
