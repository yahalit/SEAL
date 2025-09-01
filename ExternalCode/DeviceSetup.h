#ifndef DEVICE_SETUP_H_DEFINED
#define DEVICE_SETUP_H_DEFINED

typedef struct 
{ 
	short unsigned useUart; 
	long unsigned baudRate ; 
	long unsigned CanID[4] ; 
	long unsigned CanIDMask[4]; 
	long unsigned ExtCanID[4]; 
	long unsigned ExtCanIDMask[4]; 
} DeviceSetup_T; 
extern DeviceSetup_T G_DeviceSetup ;

void SetUartParameters(short unsigned useUart , long unsigned baudRate);
void SetCanParameters(const long unsigned CanID[4] , const long unsigned CanIDMask[4] ,const long unsigned ExtCanID[4] , const long unsigned ExtCanIDMask[4] );


#endif