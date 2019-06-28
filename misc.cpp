#include "misc.h"
#include <iostream>

using namespace std;

bool missingVariableInitalization(int a)
{
    bool ret;

    if(a > 5) {
        ret = true;
    }

    return ret;
}

bool unreachableCode(bool a)
{
    if(a) {
        return false;
    }
    else {
        return true;
    }

    // not reachable
    a = true;
    return a;
}

void missingBreakInSwitchSequenze(int a) {
    switch (a) {
        case 0:
        case 1:
            cout << "Value is 0 or 1" << endl;
            break;
        case 2:
            cout << "Value is 2" << endl;
        case 3:
            cout << "Value is 3" << endl;
            break;
        default:
            cout << "Value is 4 or greater" << endl;
    }
}

int unreadVariable(int a)
{
    int x = a;

    x = a + 2;

    return x;
}

int* returningDanglingPointer()
{
    int a = 3;
    return &a;
}