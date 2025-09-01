#include "DeviceSetup.h"


void SetUartParameters(short unsigned useUart , long unsigned baudRate)
{
	(void)useUart  ;
	(void)baudRate; 
}

void SetCanParameters(const long unsigned CanID[4] , const long unsigned CanIDMask[4] ,const long unsigned ExtCanID[4] , const long unsigned ExtCanIDMask[4] )
{
	(void)CanID ;
	(void)CanIDMask;
	(void)ExtCanID;
	(void)ExtCanIDMask;
}
