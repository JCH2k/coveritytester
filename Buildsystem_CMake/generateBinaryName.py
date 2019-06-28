#
# return software version X.Y.Z.CC
#
import sys, getopt

import versionextract

SW_KEY = ["SW_IDNO"]

def buildBinaryName( str_SW_IDNO, str_VERSION ):
    # build filename
    # 1 Q1
    string = "Q1"

    # 2 ID as 8 numbers
    str_SWID = "".join(list(filter(str.isdigit, str_SW_IDNO))).rjust(8, '0')
    string = string + str_SWID + "_"

    # append version 
    string = string + str_VERSION
    return string

if __name__ == "__main__":
    # execute only if run as a script
    # command line parsing
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hf:")
    except getopt.GetoptError:
        print('generateBinaryName.py -f <path/Infoblock.hpp>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('generateBinaryName.py -f <path/Infoblock.hpp>')
            sys.exit()
        elif opt in ("-f"):
            _inputFileName = arg.strip()
    
    defines = versionextract.getAllDefines(_inputFileName, versionextract.VERSIONKEYS+SW_KEY)
    print(buildBinaryName(defines["SW_IDNO"],versionextract.getVersionString(defines)))