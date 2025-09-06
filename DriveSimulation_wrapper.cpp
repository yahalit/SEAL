
/*
 * Include Files
 *
 */
#include "simstruc.h"



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 256
#define u_1_width 256
#define u_2_width 24
#define y_width 24
#define y_1_width 3

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
extern "C" void DriveSimulation_Outputs_wrapper(const real_T *CommUART,
			const real_T *CommCAN,
			const real_T *DrvCommand,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			const real_T *xD,
			SimStruct *S);

void DriveSimulation_Outputs_wrapper(const real_T *CommUART,
			const real_T *CommCAN,
			const real_T *DrvCommand,
			real_T *SetupReport,
			real_T *PhaseVoltages,
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
extern "C" void DriveSimulation_Update_wrapper(const real_T *CommUART,
			const real_T *CommCAN,
			const real_T *DrvCommand,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *xD,
			SimStruct *S);

void DriveSimulation_Update_wrapper(const real_T *CommUART,
			const real_T *CommCAN,
			const real_T *DrvCommand,
			real_T *SetupReport,
			real_T *PhaseVoltages,
			real_T *xD,
			SimStruct *S)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
 
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}

