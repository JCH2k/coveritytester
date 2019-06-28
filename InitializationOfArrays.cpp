#include "InitializationOfArrays.h"

// #001
int InitializationOfArrays::insufficientInit()
{
    unsigned char _maxState;
    const unsigned char _numberElements = 5;
    unsigned char _state[_numberElements];

    // array is cleared only on 4 of 5 elements
    for (unsigned char i = 0; i < (_numberElements-1); i++) {
        _state[i] = 0;
    }

    // write on array
    _state[0]++;
    _state[1]++;
    _state[1]++;
    _state[2]++;
    _state[3]++;
    _state[4]++;

    // read on array
    _maxState = 0;
    for (unsigned char i = 0; i < _numberElements; i++) {
        if (_maxState < _state[i]) {
            _maxState = _state[i];
        }
    }

    return _maxState;
}

// #002
int InitializationOfArrays::overInit()
{
    unsigned char _maxState;
    const unsigned char _numberElements = 5;
    unsigned char _state[_numberElements];

    // array is cleared on 6 of 5 elements
    for (unsigned char i = 0; i <= _numberElements; i++) {
        _state[i] = 0;
    }

    // write on array
    _state[0]++;
    _state[1]++;
    _state[1]++;
    _state[2]++;
    _state[3]++;
    _state[4]++;

    // read on array
    _maxState = 0;
    for (unsigned char i = 0; i < _numberElements; i++) {
        if (_maxState < _state[i]) {
            _maxState = _state[i];
        }
    }

    return _maxState;
}

// #005
void InitializationOfArrays::initWithWrongSizeOf(bool avoidCrash)
{
    void* pointerArray[2];

    for(unsigned int i = 0; i < sizeof(pointerArray); i++) {        // correct: sizeof(pointerArray)/sizeof(pointerArray[0])
        pointerArray[i] = nullptr;
        if (avoidCrash) {
            break;      // early exit to avoid application crash
        }
    }
}
