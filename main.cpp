#include "InitializationOfArrays.h"
#include "DummyClass.h"
#include "misc.h"
#include <iostream>
using namespace std;

int main() {
    InitializationOfArrays ioa;

    // #001
    int result1 = ioa.insufficientInit();
    cout << "Max value '" << result1 << "'." << endl;

    // #002
    int result2 = ioa.overInit();
    cout << "Max value '" << result2 << "'." << endl;

    // #005
    ioa.initWithWrongSizeOf(true);

    // #004
    DummyClass object;
    fillDummyClass(&object);
    cout << "DummyClass content: int: "<< object.i << "; float: " << object.f << endl;

    // #006
    int i = 0;
    if(i = 1) {
        cout << "Assignements in if condition is bad!" << endl;
    }

    // #007
    DummyClass* p = new DummyClass[3];
    delete p;       // correct: delete[]

    // #008
    bool returned = missingVariableInitalization(3);
    cout << "Returned " << returned << endl;

    // #009
    unreachableCode(true);

    // #010
    missingBreakInSwitchSequenze(2);

    // #011
    unreadVariable(4);

    // #012
    int* a = returningDanglingPointer();
    cout << "Dangling pointer: " << a << endl;

    // new error
    int* c = new int[5];
    delete c;

    return 0;
}
