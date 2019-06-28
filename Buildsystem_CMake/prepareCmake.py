#!/usr/bin/python
import os
import sys
from subprocess import call

# set default values for type, implementation and architecture
#BUILD_TYPE: possible values are Debug, Release, RelWithDebInfo and MinSizeRel
BUILD_TYPE = "Debug"
#BUILD_IMPL: target implementation
BUILD_IMPL = "x86_miCan"
#BUILD_ARCH: target architecture
BUILD_ARCH = "X86"
#BUILD_GEN: build tool generator
BUILD_GEN = "Unix Makefiles"
#BUILD_COMPILER: build compiler
BUILD_COMPILER = "CodeSourcery"
# variable for build specific Cmake configuration
BUILD_CONF = ""
# variable for build specific definitions
BUILD_DEF = ""

# function assignBuildTypeImpl
# write to global var BUILD_TYPE, BUILD_IMPL and/or BUILD_ARCH (defined below), if Arg matches
def assignBuildTypeImpl(Arg):
	global BUILD_TYPE
	global BUILD_IMPL
	global BUILD_ARCH
	global BUILD_GEN
	global BUILD_COMPILER
	global BUILD_CONF
	global BUILD_DEF
	if Arg == "MSYS Makefiles" or Arg == "MinGW Makefiles" or Arg == "Ninja" or Arg == "Unix Makefiles":
		BUILD_GEN = Arg
	elif Arg == "GNUARM" or Arg == "CodeSourcery" or Arg == "MinGW":
		BUILD_COMPILER = Arg
	elif Arg == "Debug" or Arg == "Release" or Arg == "RelWithDebInfo" or Arg == "MinSizeRel":
		BUILD_TYPE = Arg
	elif Arg.find("x86") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "X86"
	elif Arg.find("Linux") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "Linux"
	elif Arg.find("STM32F0") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M0"
	elif Arg.find("STM32F1") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M3"
	elif Arg.find("STM32F2") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M3"
	elif Arg.find("STM32F3") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M4"
	elif Arg.find("STM32F4") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M4"
	elif Arg.find("STM32F7") == 0:
		BUILD_IMPL = Arg
		BUILD_ARCH = "CORTEX_M7"
	elif Arg.find("-D") == 0:
		BUILD_DEF += " "
		BUILD_DEF += Arg
	elif Arg.find("-C") == 0:
		BUILD_CONF += " -D"
		BUILD_CONF += Arg[2:]
	else:
		print("ERROR: Don't know what argument '" + Arg + "' means. Aborting!")
		return 1
	
	return 0


def main():

	#check if any given argument fits
	for eachArg in sys.argv:
		if eachArg == sys.argv[0]:
			# Ignore the own script name
			continue
		if assignBuildTypeImpl(eachArg) == 1:
			return 1


	# inform about current build configuration
	if BUILD_CONF:
		if BUILD_DEF:
			print("Building type '" + BUILD_TYPE + "' for implementation '" + BUILD_IMPL + "' (architecture: '" + BUILD_ARCH + "'). Build specific Cmake configurations: " + BUILD_CONF +". Build specific defines: " + BUILD_DEF + ".")
		else:
			print("Building type '" + BUILD_TYPE + "' for implementation '" + BUILD_IMPL + "' (architecture: '" + BUILD_ARCH + "'). Build specific Cmake configurations: " + BUILD_CONF + ".")
	else:
		if BUILD_DEF:
			print("Building type '" + BUILD_TYPE + "' for implementation '" + BUILD_IMPL + "' (architecture: '" + BUILD_ARCH + "'). Build specific defines: " + BUILD_DEF + ".")
		else:
			print("Building type '" + BUILD_TYPE + "' for implementation '" + BUILD_IMPL + "' (architecture: '" + BUILD_ARCH + "').")
	sys.stdout.flush()

	# go to dir where this script is
	os.chdir(os.path.dirname(os.path.realpath(__file__)))
	# save build system folder name
	buildsystemFolder = os.path.relpath(".", "..")

	os.chdir("..")

	# create build directory name and check if directory is already existing, if not create it
	buildDirectory = "Build_" + BUILD_IMPL + "_" + BUILD_TYPE
	if not os.path.exists(buildDirectory):
		os.makedirs(buildDirectory)
	os.chdir(buildDirectory)


	# call cmake
	print("call cmake")

	# try to get the environmental variable for the toolchain path
	try:
		toolchain_path = os.environ['TOOLCHAIN_PATH']
	except:
		print("No TOOLCHAIN_PATH environment variable set! Aborting!")
		return 1

	sys.stdout.flush()
	if BUILD_ARCH == "X86":
		AtrToolChain = " -DCMAKE_TOOLCHAIN_FILE=\"../" + buildsystemFolder + "/toolchains/mingw32_" + BUILD_ARCH + ".cmake\""
	elif  BUILD_ARCH == "Linux":
		AtrToolChain = " -DCMAKE_TOOLCHAIN_FILE=\"../" + buildsystemFolder + "/toolchains/arm-none-linux-gnueabi" + ".cmake\""
	else:
		toolchainFile = "arm-none-eabi_" + BUILD_ARCH + ".cmake"
		if BUILD_COMPILER == "GNUARM":
			toolchainFile = "gnu_" + toolchainFile
		AtrToolChain = " -DCMAKE_TOOLCHAIN_FILE=\"../" + buildsystemFolder + "/toolchains/"+toolchainFile+"\""

	AtrGenerator = " -G \""+BUILD_GEN+"\""
	AtrBuildType = " -DCMAKE_BUILD_TYPE=" + BUILD_TYPE
	AtrBuildImpl = " -DBUERKERT_BUILD_IMPL:STRING=" + BUILD_IMPL

	if BUILD_DEF:
		AtrBuildDef  = " -DBUERKERT_BUILD_DEF:STRING=\"" + BUILD_DEF + "\""
	else:
		AtrBuildDef  = " "
	if BUILD_CONF:
		AtrBuildConf  = " " + BUILD_CONF
	else:
		AtrBuildConf  = " "

	#print cmake version
	ret = call("cmake --version")

	print("cmake" + AtrToolChain + AtrBuildType + AtrBuildImpl + AtrBuildDef + AtrBuildConf + AtrGenerator + " ..")
	ret = call("cmake" + AtrToolChain + AtrBuildType + AtrBuildImpl + AtrBuildDef + AtrBuildConf + AtrGenerator + " ..")
	if ret:
		print("cmake failed, returning " + str(ret))
		return 1

	# we have finished successfully
	return 0

if __name__ == '__main__': 
	# if this script is called directly and is not only imported
	ret = main()
	sys.exit(ret)
