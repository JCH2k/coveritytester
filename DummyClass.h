#ifndef DUMMYCLASS_H_
#define DUMMYCLASS_H_

#include <string>

class DummyClass
{
public:
	DummyClass(void);
	DummyClass(int i, float f);
	virtual ~DummyClass(void);
	
	int i;
	float f;
};

void fillDummyClass(DummyClass* pDC);

#endif // DUMMYCLASS_H_
