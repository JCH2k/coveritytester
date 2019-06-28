#!/usr/bin/python
import os
import sys
import atexit
from subprocess import call

# go to dir where this script is
os.chdir(os.path.dirname(os.path.realpath(__file__)))

import prepareCmake

ret = prepareCmake.main()
if ret != 0:
	sys.exit(ret)


#call build
print("start build")
sys.stdout.flush()
ret = call("cmake --build . -- -j 8")
if ret:
	print("cmake build failed, returning " + str(ret))
	sys.exit(1)

# we have finished successfully
sys.exit(0)
