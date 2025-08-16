/*
 * File: Seal.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.34
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Sat Aug 16 11:05:32 2025
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

#include "Seal.h"
#include <math.h>
#include "rtwtypes.h"

/* Exported block parameters */
PosProfilerState PosProfilerState_init = {
  0.0,
  0.0,

  { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
} ;                                    /* Variable: PosProfilerState_init
                                        * Referenced by: '<Root>/Data Store Memory5'
                                        */

PosProfilerData PosProfilerData_init = {
  0.0F,
  1.0F,
  1.0F,
  1.0F,

  { 1.0, -0.874052257056399, 0.280840263500717, -0.024477523271653 },
  0.382310483172666,
  0U
} ;                                    /* Variable: PosProfilerData_init
                                        * Referenced by: '<Root>/Data Store Memory2'
                                        */

SystemData SystemData_init = {
  0.01F,
  1.0e+18F,
  -1.0e+18F,
  1.0e+18F,
  1.0e+6F,
  20.0F
} ;                                    /* Variable: SystemData_init
                                        * Referenced by: '<Root>/Data Store Memory4'
                                        */

SEALVerControl SEALVerControl_init = {
  1U,
  1U,
  0U
} ;                                    /* Variable: SEALVerControl_init
                                        * Referenced by: '<Root>/Data Store Memory6'
                                        */

/* Exported block states */
SEALVerControl G_SEALVerControl;       /* '<Root>/Data Store Memory6' */

/* Block signals and states (default storage) */
DW rtDW;

/* Model step function */
void ISR100u(void)
{
  PosProfilerState rtb_PosProfilerStateOut;
  real_T speed;
  int32_T i;
  real32_T Delta;
  real32_T ex;
  real32_T pos;

  /* RootInportFunctionCallGenerator generated from: '<Root>/ISR100u' incorporates:
   *  SubSystem: '<Root>/100usecPeriodic'
   */
  /* MATLAB Function: '<S1>/MATLAB Function' incorporates:
   *  DataStoreRead: '<S1>/Data Store Read'
   *  DataStoreRead: '<S1>/Data Store Read1'
   *  DataStoreRead: '<S1>/Data Store Read2'
   */
  rtb_PosProfilerStateOut = rtDW.G_PosProfilerState;
  if (rtDW.G_PosProfilerData.ProfileDataOk == 0) {
    Delta = (real32_T)fabs(rtDW.G_PosProfilerState.Speed) - rtDW.G_SystemData.Ts
      * rtDW.G_SystemData.AbsAccelerationLimit;
    if (Delta < 0.0F) {
      Delta = 0.0F;
    }

    if (rtDW.G_PosProfilerState.Speed < 0.0) {
      i = -1;
    } else {
      i = (rtDW.G_PosProfilerState.Speed > 0.0);
    }

    Delta *= (real32_T)i;
    pos = (Delta + (real32_T)rtDW.G_PosProfilerState.Speed) *
      rtDW.G_SystemData.Ts * 0.5F + (real32_T)rtDW.G_PosProfilerState.Position;
    for (i = 0; i < 8; i++) {
      rtb_PosProfilerStateOut.FiltState[i] = pos;
    }
  } else {
    Delta = (rtDW.G_PosProfilerData.PositionTarget - (real32_T)
             rtDW.G_PosProfilerState.Position) - (real32_T)
      (rtDW.G_PosProfilerState.Speed * rtDW.G_SystemData.Ts * 0.5);
    i = 1;
    if (Delta < 0.0F) {
      i = -1;
      Delta = -Delta;
      speed = -rtDW.G_PosProfilerState.Speed;
    } else {
      speed = rtDW.G_PosProfilerState.Speed;
    }

    Delta = (real32_T)sqrt(Delta * 2.0F *
      rtDW.G_PosProfilerData.ProfileDeceleration);
    if (speed < Delta) {
      pos = rtDW.G_SystemData.Ts * rtDW.G_PosProfilerData.ProfileDeceleration;
      ex = (real32_T)speed;
      if ((real32_T)speed > pos) {
        ex = pos;
      }

      if (ex > rtDW.G_PosProfilerData.ProfileSpeed) {
        ex = rtDW.G_PosProfilerData.ProfileSpeed;
      }

      if (ex > Delta) {
        ex = Delta;
      }
    } else {
      ex = (real32_T)speed - rtDW.G_SystemData.Ts *
        rtDW.G_PosProfilerData.ProfileDeceleration * 1.02F;
      if (Delta >= ex) {
        ex = Delta;
      }
    }

    Delta = ex * (real32_T)i;
    pos = (Delta + (real32_T)rtDW.G_PosProfilerState.Speed) *
      rtDW.G_SystemData.Ts * 0.5F + (real32_T)rtDW.G_PosProfilerState.Position;
    rtb_PosProfilerStateOut.FiltState[1] = rtDW.G_PosProfilerState.FiltState[0];
    rtb_PosProfilerStateOut.FiltState[2] = rtDW.G_PosProfilerState.FiltState[1];
    rtb_PosProfilerStateOut.FiltState[3] = rtDW.G_PosProfilerState.FiltState[2];
    rtb_PosProfilerStateOut.FiltState[0] = -((rtDW.G_PosProfilerState.FiltState
      [0] * rtDW.G_PosProfilerData.ProfileFilterDen[1] +
      rtDW.G_PosProfilerState.FiltState[1] *
      rtDW.G_PosProfilerData.ProfileFilterDen[2]) +
      rtDW.G_PosProfilerState.FiltState[2] *
      rtDW.G_PosProfilerData.ProfileFilterDen[3]) + pos *
      rtDW.G_PosProfilerData.ProfileFilterNum;
  }

  rtb_PosProfilerStateOut.Position = pos;
  rtb_PosProfilerStateOut.Speed = Delta;
  if (rtDW.G_SystemData.Ts >= 1.0E-5) {
    speed = rtDW.G_SystemData.Ts;
  } else {
    speed = 1.0E-5;
  }

  /* BusAssignment: '<S1>/Bus Assignment' incorporates:
   *  DataStoreRead: '<S1>/Data Store Read2'
   *  DataStoreWrite: '<S1>/Data Store Write1'
   *  MATLAB Function: '<S1>/MATLAB Function'
   */
  G_DrvCommandBuf.SpeedCommand = (rtb_PosProfilerStateOut.FiltState[0] -
    rtDW.G_PosProfilerState.FiltState[0]) / speed;

  /* DataStoreWrite: '<S1>/Data Store Write' */
  rtDW.G_PosProfilerState = rtb_PosProfilerStateOut;

  /* BusAssignment: '<S1>/Bus Assignment' incorporates:
   *  DataStoreWrite: '<S1>/Data Store Write1'
   *  MATLAB Function: '<S1>/MATLAB Function'
   */
  G_DrvCommandBuf.PositionCommand = rtb_PosProfilerStateOut.FiltState[0];
  G_DrvCommandBuf.CurrentCommand = 0.0;

  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/ISR100u' */
}

/* Model step function */
void IdleLoopCAN(void)
{
  int32_T cnt;
  uint16_T nextput;
  uint16_T nfetch;
  uint16_T nmsgGet;
  uint16_T nmsgPut;
  uint16_T nput;
  boolean_T exitg1;

  /* RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopCAN' incorporates:
   *  SubSystem: '<Root>/Idle process CAN interpreter'
   */
  /* MATLAB Function: '<S3>/CAN message response' */
  if (G_CANCyclicBuf_in.PutCounter != G_CANCyclicBuf_in.FetchCounter) {
    cnt = 0;
    exitg1 = false;
    while ((!exitg1) && (cnt < 3)) {
      nfetch = (uint16_T)((int32_T)(G_CANCyclicBuf_in.FetchCounter & 63U) + 1);
      nput = (uint16_T)((int32_T)(G_CANCyclicBuf_out.PutCounter & 63U) + 1);
      nextput = (uint16_T)((uint32_T)(nput + 1) & 63U);
      if (nextput == G_CANCyclicBuf_out.FetchCounter) {
        exitg1 = true;
      } else {
        nmsgGet = (uint16_T)((nfetch << 1) - 1);
        nmsgPut = (uint16_T)((nput << 1) - 1);
        G_CANCyclicBuf_out.CANQueue[nmsgPut - 1] =
          G_CANCyclicBuf_in.CANQueue[nmsgGet - 1];
        G_CANCyclicBuf_out.CANQueue[nmsgPut] =
          G_CANCyclicBuf_in.CANQueue[nmsgGet];
        G_CANCyclicBuf_out.CANID[nput - 1] = G_CANCyclicBuf_in.CANID[nfetch - 1];
        G_CANCyclicBuf_out.DLenAndAttrib[nput - 1] =
          G_CANCyclicBuf_in.DLenAndAttrib[nfetch - 1];
        G_CANCyclicBuf_out.PutCounter = nextput;
        G_CANCyclicBuf_in.FetchCounter = (uint16_T)((uint32_T)(nfetch + 1) & 63U);
        if (G_CANCyclicBuf_in.PutCounter == G_CANCyclicBuf_in.FetchCounter) {
          exitg1 = true;
        } else {
          cnt++;
        }
      }
    }
  }

  /* End of MATLAB Function: '<S3>/CAN message response' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopCAN' */
}

/* Model step function */
void IdleLoopUART(void)
{
  int32_T cnt;
  uint16_T nextput;
  uint16_T nfetch;
  uint16_T nput;
  boolean_T exitg1;

  /* RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopUART' incorporates:
   *  SubSystem: '<Root>/Idle process UART interpreter'
   */
  /* MATLAB Function: '<S4>/UART message response' */
  if (G_UartCyclicBuf_in.PutCounter != G_UartCyclicBuf_in.FetchCounter) {
    cnt = 0;
    exitg1 = false;
    while ((!exitg1) && (cnt < 10)) {
      nfetch = (uint16_T)((int32_T)(G_UartCyclicBuf_in.FetchCounter & 255U) + 1);
      nput = (uint16_T)((int32_T)(G_UartCyclicBuf_out.PutCounter & 255U) + 1);
      nextput = (uint16_T)((uint32_T)(nput + 1) & 255U);
      if (nextput == G_UartCyclicBuf_out.FetchCounter) {
        exitg1 = true;
      } else {
        G_UartCyclicBuf_out.UARTQueue[nput - 2] =
          G_UartCyclicBuf_in.UARTQueue[nfetch - 2];
        G_UartCyclicBuf_out.PutCounter = nextput;
        G_UartCyclicBuf_in.FetchCounter = (uint16_T)((uint32_T)(nfetch + 1) &
          255U);
        if (G_UartCyclicBuf_in.PutCounter == G_UartCyclicBuf_in.FetchCounter) {
          exitg1 = true;
        } else {
          cnt++;
        }
      }
    }
  }

  /* End of MATLAB Function: '<S4>/UART message response' */
  /* End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopUART' */
}

/* Model initialize function */
void Seal_initialize(void)
{
  /* Start for DataStoreMemory: '<Root>/Data Store Memory6' */
  G_SEALVerControl = SEALVerControl_init;

  /* Start for DataStoreMemory: '<Root>/Data Store Memory2' */
  rtDW.G_PosProfilerData = PosProfilerData_init;

  /* Start for DataStoreMemory: '<Root>/Data Store Memory4' */
  rtDW.G_SystemData = SystemData_init;

  /* Start for DataStoreMemory: '<Root>/Data Store Memory5' */
  rtDW.G_PosProfilerState = PosProfilerState_init;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
