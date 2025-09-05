
/*
 * Include Files
 *
 */
#include "simstruc.h"



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define u_1_width 128
#define u_2_width 1
#define y_width 1
#define y_1_width 1

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
extern void UartMsg_Outputs_wrapper(real_T *Call,
			int8_T *Char2Send,
			const real_T *xD,
			SimStruct *S, int_T tid);

void UartMsg_Outputs_wrapper(real_T *Call,
			int8_T *Char2Send,
			const real_T *xD,
			SimStruct *S, int_T tid)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
	// Its essential that the character is put out before the event is thrown. 
	// Otherwise the event handler will see the character prior to the substitution 
	// Idiotic as it is Matlab processes the function call event BEFORE finishing up this S-function output!
	Char2Send[0] = (uint8_T)xD[(int)xD[1] + 1];
	if (xD[1])
	{
		ssCallSystemWithTid(S, 0, tid);
	}
	/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Updates function
 *
 */
extern void UartMsg_Update_wrapper(const real_T * Trigger,
			const uint8_T *Message,
			const real_T *length,
			real_T *Call,
			int8_T *Char2Send,
			real_T *xD,
			SimStruct *S);

void UartMsg_Update_wrapper(const real_T * Trigger,
			const uint8_T *Message,
			const real_T *length,
			real_T *Call,
			int8_T *Char2Send,
			real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
	int l, cnt;
	if (Trigger[0] > 0 && xD[0] == 0)
	{
		l = (int)length[0];
		if (l < 0 || l > 128)
		{
			ssSetErrorStatus(S, "Ilegal message length, must be 0 to 128 ");
		}
		xD[1] = l;
		for (cnt = 1; cnt <= l; cnt++)
		{
			xD[1 + cnt] = (double)Message[l - cnt];
		}
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

