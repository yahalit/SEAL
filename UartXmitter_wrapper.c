
/*
 * Include Files
 *
 */
#include "simstruc.h"



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

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
void EventThrower_Outputs_wrapper(const real_T *Trigger,
			const uint8_T* Message,
			const real_T* length,
			real_T *Call,
			uint8_T* Char,
			const real_T *xD,
			SimStruct *S,
			int_T tid)
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
	int l; 
	if (xD[1])
	{
		ssCallSystemWithTid(S, 0, tid);
	}
	Char[0] = (uint8_T)xD[(int)xD[1]+2]; 
}

/*
 * Updates function
 *
 */
void EventThrower_Update_wrapper(const real_T *Trigger,
			const uint8_T* Message,
			const real_T* length,
			real_T *Call,
			real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
	int l , cnt; 
	if (Trigger[0] > 0 && xD[0] == 0)
	{
		l = (int)length[0];
		if (l < 0 || l > 128)
		{
			ssSetErrorStatus(S, "Ilegal message length, must be 0 to 128 ");
		}
		xD[1] = l;
		for (cnt = 1; cnt <= l ; cnt++)
		{
			xdD[2 + cnt] = (double)Message[l-cnt]; 
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

