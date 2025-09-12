/*
 * File: ert_main.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.154
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Fri Sep 12 16:59:24 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Texas Instruments->C2000
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. Traceability
 *    3. Safety precaution
 *    4. RAM efficiency
 * Validation result: Not run
 */

#include <stdio.h>
#include "Seal.h"                      /* Model header file */

/* Example use case for call to exported function: ISR100uProfiler */
extern void sample_usage_ISR100uProfiler(void);
void sample_usage_ISR100uProfiler(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  ISR100uProfiler();

  /* Read function outputs here */
}

/* Example use case for call to exported function: ISR100uController */
extern void sample_usage_ISR100uController(void);
void sample_usage_ISR100uController(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  ISR100uController();

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

/* Example use case for call to exported function: SetupDrive */
extern void sample_usage_SetupDrive(void);
void sample_usage_SetupDrive(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  SetupDrive();

  /* Read function outputs here */
}

/* Example use case for call to exported function: EnvSet */
extern void sample_usage_EnvSet(void);
void sample_usage_EnvSet(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  EnvSet();

  /* Read function outputs here */
}

/* Example use case for call to exported function: EnvGet */
extern void sample_usage_EnvGet(void);
void sample_usage_EnvGet(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  EnvGet();

  /* Read function outputs here */
}

/* Example use case for call to exported function: UartAddChar */
extern void sample_usage_UartAddChar(void);
void sample_usage_UartAddChar(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  UartAddChar();

  /* Read function outputs here */
}

/* Example use case for call to exported function: UartGetChar */
extern void sample_usage_UartGetChar(void);
void sample_usage_UartGetChar(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  UartGetChar();

  /* Read function outputs here */
}

/* Example use case for call to exported function: CanGetTxMsg */
extern void sample_usage_CanGetTxMsg(void);
void sample_usage_CanGetTxMsg(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  CanGetTxMsg();

  /* Read function outputs here */
}

/* Example use case for call to exported function: CanSetRxMsg */
extern void sample_usage_CanSetRxMsg(void);
void sample_usage_CanSetRxMsg(void)
{
  /* Set task inputs here */

  /* Call to exported function */
  CanSetRxMsg();

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
