/*
 * File: Seal.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.51
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Sun Aug 17 14:48:05 2025
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
#include "mod_CTxUEiaB.h"
#include "rt_roundd.h"
#include "div_nde_s32_floor.h"

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
    Delta = (real32_T)fabs(rtDW.G_PosProfilerState.Speed) - G_SetupReportBuf.Ts *
      G_SetupReportBuf.AbsoluteAccelerationLimit;
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
      G_SetupReportBuf.Ts * 0.5F + (real32_T)rtDW.G_PosProfilerState.Position;
    for (i = 0; i < 8; i++) {
      rtb_PosProfilerStateOut.FiltState[i] = pos;
    }
  } else {
    Delta = (rtDW.G_PosProfilerData.PositionTarget - (real32_T)
             rtDW.G_PosProfilerState.Position) - (real32_T)
      (rtDW.G_PosProfilerState.Speed * G_SetupReportBuf.Ts * 0.5);
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
      pos = G_SetupReportBuf.Ts * rtDW.G_PosProfilerData.ProfileDeceleration;
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
      ex = (real32_T)speed - G_SetupReportBuf.Ts *
        rtDW.G_PosProfilerData.ProfileDeceleration * 1.02F;
      if (Delta >= ex) {
        ex = Delta;
      }
    }

    Delta = ex * (real32_T)i;
    pos = (Delta + (real32_T)rtDW.G_PosProfilerState.Speed) *
      G_SetupReportBuf.Ts * 0.5F + (real32_T)rtDW.G_PosProfilerState.Position;
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
  if (G_SetupReportBuf.Ts >= 1.0E-5) {
    speed = G_SetupReportBuf.Ts;
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
  real_T Mantissa;
  real_T n;
  real_T nafterPeriod;
  real_T tmp_0;
  int32_T SciNotation;
  int32_T cnt;
  int32_T exitg1;
  int32_T exitg2;
  uint32_T qY;
  uint32_T tmp;
  int16_T sgnExp;
  int16_T sgnMant;
  uint16_T PeriodPos;
  uint16_T WasPeriod;
  uint16_T b_c;
  uint16_T gotArrayIndex;
  uint16_T isExp;
  uint16_T nmsgGet;
  boolean_T exitg3;
  boolean_T guard1;
  boolean_T guard2;

  /* RootInportFunctionCallGenerator generated from: '<Root>/IdleLoopUART' incorporates:
   *  SubSystem: '<Root>/Idle process UART interpreter'
   */
  /* MATLAB Function: '<S4>/UART message response' */
  cnt = 0;
  while ((cnt < 10) && (G_UartCyclicBuf_in.PutCounter !=
                        G_UartCyclicBuf_in.FetchCounter)) {
    nmsgGet = (uint16_T)(G_UartCyclicBuf_in.FetchCounter & 255);
    G_UartCyclicBuf_in.FetchCounter = (uint16_T)((uint32_T)(nmsgGet + 1) & 255U);
    if (G_UartCyclicBuf_in.UartError != 0) {
      G_UartCyclicBuf_in.UartError = 0U;
      G_MicroInterp.InterpretError = 3U;
    } else {
      nmsgGet = G_UartCyclicBuf_in.UARTQueue[nmsgGet];
      if (nmsgGet == 59) {
        G_MicroInterp.NewString = G_MicroInterp.cnt;
      } else {
        if (G_MicroInterp.NewString != 0) {
          G_MicroInterp.cnt = 0U;
          G_MicroInterp.InterpretError = 0U;
        }

        if (G_MicroInterp.InterpretError == 0) {
          if ((nmsgGet <= 122) && (nmsgGet >= 97)) {
            nmsgGet = (uint16_T)(nmsgGet - 32);
          }

          if (((nmsgGet < 9) || (nmsgGet > 13)) && (nmsgGet != 32) && (nmsgGet
               != 43)) {
            if (G_MicroInterp.cnt >= 64) {
              G_MicroInterp.InterpretError = 2U;
            }

            if (((nmsgGet <= 90) && (nmsgGet >= 65)) || ((nmsgGet <= 57) &&
                 (nmsgGet >= 48)) || (nmsgGet == 45) || (nmsgGet == 61)) {
              qY = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.cnt = (uint16_T)qY;
            } else {
              G_MicroInterp.InterpretError = 1U;
            }
          }
        }
      }

      if (G_MicroInterp.NewString != 0) {
        G_MicroInterp.NewString = 0U;
        if (G_MicroInterp.cnt >= 2) {
          if ((G_MicroInterp.TempString[0] < 65) || (G_MicroInterp.TempString[0]
               > 90) || (G_MicroInterp.TempString[1] < 65) ||
              (G_MicroInterp.TempString[1] > 90)) {
            G_MicroInterp.InterpretError = 10U;
          } else {
            G_MicroInterp.IsGetFunc = 1U;
            G_MicroInterp.ArrayIndex = 1U;
            qY = G_MicroInterp.TempString[0] * 26U;
            if (qY > 65535U) {
              qY = 65535U;
            }

            qY += G_MicroInterp.TempString[1];
            if (qY > 65535U) {
              qY = 65535U;
            }

            G_MicroInterp.MnemonicIndex = (uint16_T)qY;
            if (G_MicroInterp.cnt <= 2) {
            } else {
              nmsgGet = 3U;
              guard1 = false;
              guard2 = false;
              if (G_MicroInterp.TempString[2] == 91) {
                gotArrayIndex = 0U;
                G_MicroInterp.ArrayIndex = 0U;
                isExp = 4U;
                do {
                  exitg2 = 0;
                  if (isExp <= G_MicroInterp.cnt) {
                    b_c = G_MicroInterp.TempString[isExp - 1];
                    if (b_c == 93) {
                      if (G_MicroInterp.ArrayIndex == 0) {
                        G_MicroInterp.InterpretError = 11U;
                        exitg2 = 1;
                      } else {
                        qY = isExp + 1U;
                        if (isExp + 1U > 65535U) {
                          qY = 65535U;
                        }

                        nmsgGet = (uint16_T)qY;
                        gotArrayIndex = 1U;
                        isExp++;
                      }
                    } else {
                      b_c = (uint16_T)(b_c & 255);
                      if ((b_c < 48) || (b_c > 57)) {
                        G_MicroInterp.InterpretError = 12U;
                        exitg2 = 1;
                      } else {
                        G_MicroInterp.ArrayIndex = (uint16_T)(((int32_T)
                          (G_MicroInterp.ArrayIndex & 31U) * 10 + b_c) - 48);
                        isExp++;
                      }
                    }
                  } else {
                    exitg2 = 2;
                  }
                } while (exitg2 == 0);

                if (exitg2 == 1) {
                } else if (gotArrayIndex == 0) {
                  G_MicroInterp.InterpretError = 14U;
                } else {
                  guard2 = true;
                }
              } else {
                guard2 = true;
              }

              if (guard2) {
                if (G_MicroInterp.cnt < nmsgGet) {
                } else if (G_MicroInterp.TempString[nmsgGet - 1] != 61) {
                  G_MicroInterp.InterpretError = 15U;
                } else {
                  qY = nmsgGet + 1U;
                  if (nmsgGet + 1U > 65535U) {
                    qY = 65535U;
                  }

                  nmsgGet = (uint16_T)qY;
                  Mantissa = 0.0;
                  gotArrayIndex = 0U;
                  sgnMant = 1;
                  sgnExp = 1;
                  isExp = 0U;
                  if (G_MicroInterp.cnt < (uint16_T)qY) {
                    G_MicroInterp.InterpretError = 16U;
                  } else if (G_MicroInterp.TempString[(uint16_T)qY - 1] == 45) {
                    sgnMant = -1;
                    tmp = (uint16_T)qY + 1U;
                    if ((uint16_T)qY + 1U > 65535U) {
                      tmp = 65535U;
                    }

                    nmsgGet = (uint16_T)tmp;
                    if (G_MicroInterp.cnt < (uint16_T)tmp) {
                      G_MicroInterp.InterpretError = 17U;
                    } else {
                      guard1 = true;
                    }
                  } else {
                    guard1 = true;
                  }
                }
              }

              if (guard1) {
                WasPeriod = 0U;
                PeriodPos = 0U;
                do {
                  exitg1 = 0;
                  if (nmsgGet <= G_MicroInterp.cnt) {
                    b_c = (uint16_T)(G_MicroInterp.TempString[nmsgGet - 1] & 255);
                    if (isExp == 0) {
                      if ((b_c >= 48) && (b_c <= 57)) {
                        Mantissa = Mantissa * 10.0 + (real_T)b_c;
                        qY = nmsgGet + 1U;
                        if (nmsgGet + 1U > 65535U) {
                          qY = 65535U;
                        }

                        nmsgGet = (uint16_T)qY;
                        if (WasPeriod != 0) {
                          qY = PeriodPos + 1U;
                          if (PeriodPos + 1U > 65535U) {
                            qY = 65535U;
                          }

                          PeriodPos = (uint16_T)qY;
                        }
                      } else if (b_c == 46) {
                        WasPeriod = 1U;
                      } else if (b_c == 69) {
                        qY = nmsgGet + 1U;
                        if (nmsgGet + 1U > 65535U) {
                          qY = 65535U;
                        }

                        nmsgGet = (uint16_T)qY;
                        isExp = 1U;
                        if ((uint16_T)qY > G_MicroInterp.cnt) {
                          G_MicroInterp.InterpretError = 19U;
                          exitg1 = 1;
                        } else if (G_MicroInterp.TempString[(uint16_T)qY - 1] ==
                                   45) {
                          sgnExp = -1;
                          tmp = (uint16_T)qY + 1U;
                          if ((uint16_T)qY + 1U > 65535U) {
                            tmp = 65535U;
                          }

                          nmsgGet = (uint16_T)tmp;
                          if ((uint16_T)tmp > G_MicroInterp.cnt) {
                            G_MicroInterp.InterpretError = 20U;
                            exitg1 = 1;
                          }
                        }
                      } else {
                        G_MicroInterp.InterpretError = 18U;
                        exitg1 = 1;
                      }
                    } else if ((b_c >= 48) && (b_c <= 57)) {
                      gotArrayIndex = (uint16_T)((int32_T)(gotArrayIndex & 511U)
                        * 10 + b_c);
                      qY = nmsgGet + 1U;
                      if (nmsgGet + 1U > 65535U) {
                        qY = 65535U;
                      }

                      nmsgGet = (uint16_T)qY;
                    } else {
                      G_MicroInterp.InterpretError = 21U;
                      exitg1 = 1;
                    }
                  } else {
                    if (WasPeriod != 0) {
                      Mantissa /= (real32_T)pow(10.0, PeriodPos);
                    }

                    G_MicroInterp.Argument = Mantissa * (real_T)sgnMant;
                    if (isExp != 0) {
                      G_MicroInterp.Argument *= (real32_T)pow(10.0, (real32_T)
                        (sgnExp * gotArrayIndex));
                    }

                    exitg1 = 1;
                  }
                } while (exitg1 == 0);
              }
            }
          }
        }

        if (G_MicroInterp.InterpretError == 0) {
          if (G_MicroInterp.MnemonicIndex == 390) {
            if (G_MicroInterp.IsGetFunc != 0) {
              G_MicroInterp.Argument = 0.0;
            } else {
              G_MicroInterp.InterpretError = 0U;
            }
          } else {
            G_MicroInterp.InterpretError = 22U;
            G_MicroInterp.TempString[0] = 69U;
            G_MicroInterp.TempString[1] = 82U;
            G_MicroInterp.TempString[2] = 82U;
            G_MicroInterp.TempString[3] = 79U;
            G_MicroInterp.TempString[4] = 82U;
            G_MicroInterp.TempString[5] = 58U;
            G_MicroInterp.cnt = 6U;
            nmsgGet = 22U;
            while (nmsgGet != 0) {
              qY = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.cnt = (uint16_T)qY;
              b_c = (uint16_T)(nmsgGet - (uint32_T)((int32_T)(nmsgGet / 10U) *
                10));
              qY = b_c + 48U;
              if (b_c + 48U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = (uint16_T)qY;
              qY = (uint32_T)nmsgGet - b_c;
              if (qY > nmsgGet) {
                qY = 0U;
              }

              nmsgGet = (uint16_T)qY;
            }
          }

          if (G_MicroInterp.IsGetFunc != 0) {
            Mantissa = log10(G_MicroInterp.Argument);
            if (Mantissa < 0.0) {
              n = ceil(Mantissa);
            } else {
              n = floor(Mantissa);
            }

            sgnMant = 0;
            SciNotation = 0;
            Mantissa = G_MicroInterp.Argument;
            if ((n > 8.0) || (n < -8.0)) {
              nafterPeriod = 8.0 - n;
            } else {
              nafterPeriod = 6.0;
              SciNotation = 1;
              if (n < 32768.0) {
                sgnMant = (int16_T)n;
              } else {
                sgnMant = MAX_int16_T;
              }

              Mantissa = G_MicroInterp.Argument * pow(10.0, -n);
            }

            if (Mantissa < 0.0) {
              n = ceil(Mantissa);
            } else {
              n = floor(Mantissa);
            }

            while (n != 0.0) {
              qY = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.cnt = (uint16_T)qY;
              tmp_0 = rt_roundd(mod_CTxUEiaB(n));
              if (tmp_0 < 65536.0) {
                if (tmp_0 >= 0.0) {
                  b_c = (uint16_T)tmp_0;
                } else {
                  b_c = 0U;
                }
              } else {
                b_c = MAX_uint16_T;
              }

              qY = b_c + 48U;
              if (b_c + 48U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = (uint16_T)qY;
              n -= (real_T)b_c;
            }

            if (nafterPeriod > 0.0) {
              qY = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.cnt = (uint16_T)qY;
              G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = 46U;
              Mantissa *= pow(10.0, nafterPeriod);
              if (Mantissa < 0.0) {
                n = ceil(Mantissa);
              } else {
                n = floor(Mantissa);
              }

              while (n != 0.0) {
                qY = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U > 65535U) {
                  qY = 65535U;
                }

                G_MicroInterp.cnt = (uint16_T)qY;
                tmp_0 = rt_roundd(mod_CTxUEiaB(n));
                if (tmp_0 < 65536.0) {
                  if (tmp_0 >= 0.0) {
                    b_c = (uint16_T)tmp_0;
                  } else {
                    b_c = 0U;
                  }
                } else {
                  b_c = MAX_uint16_T;
                }

                qY = b_c + 48U;
                if (b_c + 48U > 65535U) {
                  qY = 65535U;
                }

                G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = (uint16_T)qY;
                n -= (real_T)b_c;
              }
            }

            if ((SciNotation != 0) && (sgnMant != 0)) {
              qY = G_MicroInterp.cnt + 1U;
              if (G_MicroInterp.cnt + 1U > 65535U) {
                qY = 65535U;
              }

              G_MicroInterp.cnt = (uint16_T)qY;
              G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = 69U;
              if (sgnMant < 0) {
                qY = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U > 65535U) {
                  qY = 65535U;
                }

                G_MicroInterp.cnt = (uint16_T)qY;
                G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = 45U;
                sgnMant = (int16_T)-sgnMant;
              }

              while (sgnMant != 0) {
                qY = G_MicroInterp.cnt + 1U;
                if (G_MicroInterp.cnt + 1U > 65535U) {
                  qY = 65535U;
                }

                G_MicroInterp.cnt = (uint16_T)qY;
                sgnExp = (int16_T)(sgnMant - (int16_T)((int16_T)
                  div_nde_s32_floor(sgnMant, 10) * 10));
                if (sgnExp < 0) {
                  sgnExp = 0;
                }

                G_MicroInterp.TempString[G_MicroInterp.cnt - 1] = (uint16_T)
                  (sgnExp + 48);
                SciNotation = sgnMant - sgnExp;
                if (SciNotation < -32768) {
                  SciNotation = -32768;
                }

                sgnMant = (int16_T)SciNotation;
              }
            }
          }

          SciNotation = 0;
          exitg3 = false;
          while ((!exitg3) && (SciNotation <= G_MicroInterp.cnt - 1)) {
            nmsgGet = (uint16_T)(G_UartCyclicBuf_out.PutCounter & 255);
            b_c = (uint16_T)((uint32_T)(nmsgGet + 1) & 255U);
            if (b_c == G_UartCyclicBuf_out.FetchCounter) {
              exitg3 = true;
            } else {
              G_UartCyclicBuf_out.UARTQueue[nmsgGet] =
                G_MicroInterp.TempString[SciNotation];
              G_UartCyclicBuf_out.PutCounter = b_c;
              SciNotation++;
            }
          }
        }
      }
    }

    cnt++;
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

  /* Start for DataStoreMemory: '<Root>/Data Store Memory5' */
  rtDW.G_PosProfilerState = PosProfilerState_init;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
