#
# return software version X.Y.Z.CC
#
import sys, getopt

VERSIONKEYS = ["SW_VERSION_X", "SW_VERSION_Y", "SW_VERSION_Z", "SW_VERSION_CC"]


def getAllDefines(inputFileName,KEYS):
    
    with open(inputFileName, "r") as fp:
        lines = fp.readlines()

    DATA = {}
    for line in lines:
        words = line.split()
        if len(words) >= 3:
            if words[0] == "#define":
                if words[1] in KEYS:
                    DATA[words[1]] = words[2]
    return DATA


def getVersionString(DATA):
    str_X = DATA["SW_VERSION_X"]
    str_X = str_X.replace("'", "")
    str_Y = DATA["SW_VERSION_Y"]
    str_Z = DATA["SW_VERSION_Z"]
    str_CC = DATA["SW_VERSION_CC"]

    # 1 str_X
    string = str_X + "_"

    # 2 add str_Y as 2 numbers
    string = string + str_Y.rjust(2, '0') + "_"

    # 3 add str_Z as 2 numbers
    string = string + str_Z.rjust(2, '0') + "_"

    # 4 add str_CC as 2 numbers
    string = string + str_CC.rjust(2, '0')
    return string


if __name__ == "__main__":
    # execute only if run as a script
    # command line parsing
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hf:")
    except getopt.GetoptError:
        print('versionextract.py -f <path/Infoblock.hpp>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('versionextract.py -f <path/Infoblock.hpp>')
            sys.exit()
        elif opt in ("-f"):
            _inputFileName = arg.strip()

    defines = getAllDefines(_inputFileName, VERSIONKEYS)
    print(getVersionString(defines))