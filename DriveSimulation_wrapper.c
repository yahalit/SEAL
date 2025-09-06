
/*
 * Include Files
 *
 */
#include "simstruc.h"



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 4
#define u_1_width 4
#define u_2_width 24
#define u_3_width 24
#define u_4_width 256
#define u_5_width 256
#define y_width 24
#define y_1_width 3
#define y_2_width 1
#define y_3_width 1
#define y_4_width 1
#define y_5_width 1

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
extern void DriveSimulation_Outputs_wrapper(const real_T *UARTManagement_in,
			const real_T *CANManagement_in,
			const real_T *DrvCommand,
			const real_T *Feedback,
			const real_T *UARTBuffer_in,
			const real_T *CANBuffer_in,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *TextInterpOutManagement,
			real_T *TextInterpBuffer,
			real_T *CanOpenManagement_out,
			real_T *CanOpenBufferOut,
			const real_T *xD,
			SimStruct *S);

void DriveSimulation_Outputs_wrapper(const real_T *UARTManagement_in,
			const real_T *CANManagement_in,
			const real_T *DrvCommand,
			const real_T *Feedback,
			const real_T *UARTBuffer_in,
			const real_T *CANBuffer_in,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *TextInterpOutManagement,
			real_T *TextInterpBuffer,
			real_T *CanOpenManagement_out,
			real_T *CanOpenBufferOut,
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
extern void DriveSimulation_Update_wrapper(const real_T *UARTManagement_in,
			const real_T *CANManagement_in,
			const real_T *DrvCommand,
			const real_T *Feedback,
			const real_T *UARTBuffer_in,
			const real_T *CANBuffer_in,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *TextInterpOutManagement,
			real_T *TextInterpBuffer,
			real_T *CanOpenManagement_out,
			real_T *CanOpenBufferOut,
			real_T *xD,
			SimStruct *S);

void DriveSimulation_Update_wrapper(const real_T *UARTManagement_in,
			const real_T *CANManagement_in,
			const real_T *DrvCommand,
			const real_T *Feedback,
			const real_T *UARTBuffer_in,
			const real_T *CANBuffer_in,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *TextInterpOutManagement,
			real_T *TextInterpBuffer,
			real_T *CanOpenManagement_out,
			real_T *CanOpenBufferOut,
			real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Code example
 *   xD[0] = u0[0];
 */
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}

