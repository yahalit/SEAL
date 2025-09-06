
/*
 * Include Files
 *
 */
#include "simstruc.h"



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define u_1_width 1
#define y_width 1
#define y_1_width 1
#define y_2_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
extern void Uart2Tx_Outputs_wrapper(const real_T *Trigger,
			const real_T *CharAndLength,
			real_T *Event,
			real_T *nCharsOut,
			uint8_T *MsgBuf,
			const real_T *xD,
			SimStruct *S);

void Uart2Tx_Outputs_wrapper(const real_T *Trigger,
			const real_T *CharAndLength,
			real_T *Event,
			real_T *nCharsOut,
			uint8_T *MsgBuf,
			const real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
      y0[0] = u0[0]; 
 For complex signals use: y0[0].re = u0[0].re; 
      y0[0].im = u0[0].im;
      y1[0].re = u1[0].re;
      y1[0].im = u1[0].im;
 */
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Updates function
 *
 */
extern void Uart2Tx_Update_wrapper(const real_T *Trigger,
			const real_T *CharAndLength,
			real_T *Event,
			real_T *nCharsOut,
			uint8_T *MsgBuf,
			real_T *xD,
			SimStruct *S);

// States are: 
// [0]: Memory of last trigger value 
// [1]: Yet unread characters 
// [2]: Total readble message length 
void Uart2Tx_Update_wrapper(const real_T * Trigger,
			const real_T *CharAndLength,
			real_T *Event,
			real_T *nCharsOut,
			uint8_T *MsgBuf,
			real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
	char  c   = (char) CharAndLength[0]; 
	int   l   = (int)  CharAndLength[1];

	int cnt;
	// Identify trigger 
	if (Trigger[0] > 0 && xD[0] == 0)
	{   // Verify a valid length 
		if (l < 0 || l > 128 - xD[1])
		{
			ssSetErrorStatus(S, "Ilegal message length, or buffer or is full  ");
		}
		xD[1] += l;
	}
	else
	{
		if (xD[1] > 0)
		{
			xD[1] -= 1;
		}
	}
	xD[0] = Trigger[0];
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}

