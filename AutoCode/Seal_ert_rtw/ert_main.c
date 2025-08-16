/*
 * File: ert_main.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.32
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Sat Aug 16 08:03:07 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. Traceability
 *    3. Safety precaution
 *    4. RAM efficiency
 * Validation result: Not run
 */

#include <stdio.h>
#include "Seal.h"                      /* Model header file */

/* Example use case for call to exported function: ISR100u */
extern void sample_usage_ISR100u(void);
void sample_usage_ISR100u(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  ISR100u();

  /* Read function outputs here */
}

/* Example use case for call to exported function: IdleLoopCAN */
extern void sample_usage_IdleLoopCAN(void);
void sample_usage_IdleLoopCAN(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  IdleLoopCAN();

  /* Read function outputs here */
}

/* Example use case for call to exported function: IdleLoopUART */
extern void sample_usage_IdleLoopUART(void);
void sample_usage_IdleLoopUART(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  IdleLoopUART();

  /* Read function outputs here */
}

/*
 * The example main function illustrates what is required by your
 * application code to initialize, execute, and terminate the generated code.
 * Attaching exported functions to a real-time clock is target specific.
 */
int_T main(int_T argc, const char *argv[])
{
  /* Unused arguments */
  (void)(argc);
  (void)(argv);

  /* Initialize model */
  Seal_initialize();
  while (1) {
    /*  Perform application tasks here. */
  }

  /* The option 'Remove error status field in real-time model data structure'
   * is selected, therefore the following code does not need to execute.
   */
  return 0;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
