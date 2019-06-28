#include "DummyClass.h"
#include <stdio.h>

DummyClass::DummyClass(void)
{
	i = 4;
	f = 1.2;
}

DummyClass::DummyClass(int i, float f)
{
	this->i = i;
	this->f = f;
}

DummyClass::~DummyClass(void)
{
}

void fillDummyClass(DummyClass* pDC)
{
	DummyClass tmp(12, 4.2);
	pDC = &tmp;			// wrong; correct: *pDC = tmp;
}