/*
 * File: Seal.h
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

#ifndef Seal_h_
#define Seal_h_
#ifndef Seal_COMMON_INCLUDES_
#define Seal_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* Seal_COMMON_INCLUDES_ */

#ifndef DEFINED_TYPEDEF_FOR_FeedbackBuf_
#define DEFINED_TYPEDEF_FOR_FeedbackBuf_

typedef struct {
  /* The main encoder sensor */
  int32_T EncoderMain;

  /* The secondary encoder sensor */
  int32_T EncoderSecondary;

  /* Speed of main encoder sensor */
  real32_T EncoderMainSpeed;

  /* Speed of secondary encoder sensor */
  real32_T EncoderSecondarySpeed;

  /* Q-channel current Amp */
  real32_T Iq;

  /* Q-channel current Amp */
  real32_T Id;

  /* DC bus voltage V */
  real32_T DcBusVoltage;

  /* Power stage temperature C */
  real32_T PowerStageTemperature;

  /* Motor electrical field angle */
  real32_T FieldAngle;

  /* Spare : 10 */
  int32_T Spare_10;

  /* Spare : 11 */
  int32_T Spare_11;

  /* Spare : 12 */
  int32_T Spare_12;

  /* Control loop configuration */
  int16_T LoopConfiguration;

  /* ReferenceMode */
  int16_T ReferenceMode;

  /* Motor on report */
  int16_T MotorOn;

  /* Code of Hall sensors */
  int16_T HallCode;

  /* 1 if disabled by STO */
  int16_T STODisable;

  /* Status bit field */
  int16_T StatusBitField;

  /* Motor failure report */
  uint32_T ErrorCode;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} FeedbackBuf;

#endif

#ifndef DEFINED_TYPEDEF_FOR_SetupReportBuf_
#define DEFINED_TYPEDEF_FOR_SetupReportBuf_

typedef struct {
  /* Maximum position referece */
  real_T MaximumPositionReference;

  /* Minimum position reference */
  real_T MinimumPositionReference;

  /* High position value that causes an exception  */
  real_T HighPositionException;

  /* Low position value that causes an exception  */
  real_T LowPositionException;

  /* Absolute speed limit */
  real32_T AbsoluteSpeedLimit;

  /* Modulo count for position sensor #1 */
  real_T PositionModulo1;

  /* Modulo count for position sensor #2 */
  real_T PositionModulo2;

  /* Speed for overspeed exception */
  real32_T OverSpeed;

  /* Absolute acceleration limit */
  real32_T AbsoluteAccelerationLimit;

  /* Continuous current limit */
  real32_T ContinuousCurrentLimit;

  /* Peak current limit */
  real32_T PeakCurrentLimit;

  /* Peak current duration */
  real32_T PeakCurrentDuration;

  /* Over current that causes an exception */
  real32_T OverCurrent;

  /* Baud rate of UART */
  uint32_T UARTBaudRate;

  /* Baud rate of CAN */
  uint32_T CANBaudRate;

  /* Is Sensor modulo: 1 */
  uint16_T IsPosSensorModulo1;

  /* Is Sensor modulo: 2 */
  uint16_T IsPosSensorModulo2;

  /* CAN ID 11bit */
  uint16_T CANId11bit;

  /* Profiler sampling time  */
  real32_T Ts;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} SetupReportBuf;

#endif

#ifndef DEFINED_TYPEDEF_FOR_PosProfilerData_
#define DEFINED_TYPEDEF_FOR_PosProfilerData_

typedef struct {
  /* Final position to arrive */
  real32_T PositionTarget;

  /* Maximum speed */
  real32_T ProfileSpeed;

  /* Maximum Profile acceleration */
  real32_T ProfileAcceleration;

  /* Maximum Profile deceleration */
  real32_T ProfileDeceleration;

  /* Filter monic polynomial for profile filtering */
  real_T ProfileFilterDen[4];

  /* Filter numerator for profile filtering */
  real_T ProfileFilterNum;

  /* Flag that profiler data is consistent */
  uint16_T ProfileDataOk;
} PosProfilerData;

#endif

#ifndef DEFINED_TYPEDEF_FOR_DrvCommandBuf_
#define DEFINED_TYPEDEF_FOR_DrvCommandBuf_

typedef struct {
  /* Command to position controller */
  real_T PositionCommand;

  /* Command to speed controller */
  real_T SpeedCommand;

  /* Command to current controller */
  real_T CurrentCommand;

  /* Control loop configuration */
  int16_T LoopConfiguration;

  /* ReferenceMode */
  int16_T ReferenceMode;

  /* Motor on request */
  int16_T MotorOn;

  /* Failure Reset Request */
  int16_T FailureReset;

  /* Spare : 8 */
  int32_T Spare_8;

  /* Spare : 9 */
  int32_T Spare_9;

  /* Spare : 10 */
  int32_T Spare_10;

  /* Spare : 11 */
  int32_T Spare_11;

  /* Spare : 12 */
  int32_T Spare_12;

  /* Spare : 13 */
  int32_T Spare_13;

  /* Spare : 14 */
  int32_T Spare_14;

  /* Spare : 15 */
  int32_T Spare_15;

  /* Spare : 16 */
  int32_T Spare_16;

  /* Spare : 17 */
  int32_T Spare_17;

  /* Spare : 18 */
  int32_T Spare_18;

  /* Spare : 19 */
  int32_T Spare_19;

  /* Spare : 20 */
  int32_T Spare_20;

  /* Spare : 21 */
  int32_T Spare_21;

  /* Spare : 22 */
  int32_T Spare_22;

  /* Spare : 23 */
  int32_T Spare_23;

  /* Spare : 24 */
  int32_T Spare_24;
} DrvCommandBuf;

#endif

#ifndef DEFINED_TYPEDEF_FOR_PosProfilerState_
#define DEFINED_TYPEDEF_FOR_PosProfilerState_

typedef struct {
  /* Position state of profiler */
  real_T Position;

  /* Speed state of profiler */
  real_T Speed;

  /* State of profiling filter */
  real_T FiltState[8];
} PosProfilerState;

#endif

#ifndef DEFINED_TYPEDEF_FOR_SEALVerControl_
#define DEFINED_TYPEDEF_FOR_SEALVerControl_

typedef struct {
  /* SEAL database version */
  uint16_T Version;

  /* SEAL database sub version */
  uint16_T SubVersion;

  /* SEAL database support data */
  uint32_T UserData;
} SEALVerControl;

#endif

#ifndef DEFINED_TYPEDEF_FOR_CANCyclicBuf_
#define DEFINED_TYPEDEF_FOR_CANCyclicBuf_

typedef struct {
  /* The place in the CANQueue where the next message is to be put */
  uint16_T PutCounter;

  /* The location in the CANQueue of the next message to read */
  uint16_T FetchCounter;

  /* CAN error */
  uint16_T CANError;

  /* Software Queue for incoming CAN messages */
  uint32_T CANQueue[256];

  /* The location in the CANQueue of the next message to transmit */
  uint16_T TxFetchCounter;

  /* Can ID, 11 or 29bit */
  uint32_T CANID[64];

  /* Data length and attributes */
  uint16_T DLenAndAttrib[64];
} CANCyclicBuf;

#endif

#ifndef DEFINED_TYPEDEF_FOR_MicroInterp_
#define DEFINED_TYPEDEF_FOR_MicroInterp_

typedef struct {
  /* 1 if this is a get function */
  uint16_T IsGetFunc;

  /* Temporary string to hold characters extracted from the cyclical buffer */
  uint16_T TempString[64];

  /* String formatting error */
  uint16_T InterpretError;

  /* In string counter */
  uint16_T cnt;

  /* Argument of a set function */
  real_T Argument;

  /* State of the interpreting process */
  uint16_T State;

  /* Indicate a new string is available */
  uint16_T NewString;

  /* Mnemonic index */
  uint16_T MnemonicIndex;

  /* Array index */
  uint16_T ArrayIndex;
} MicroInterp;

#endif

#ifndef DEFINED_TYPEDEF_FOR_UartCyclicBuf_
#define DEFINED_TYPEDEF_FOR_UartCyclicBuf_

typedef struct {
  /* The place in the UARTQueue where next character is to be put */
  uint16_T PutCounter;

  /* The location in the UARTQueue of the next character to read */
  uint16_T FetchCounter;

  /* UART error */
  uint16_T UartError;

  /* The location in the TX UARTQueue of the next character to read */
  uint16_T TxFetchCounter;

  /* Software Queue for incoming UART characters */
  uint16_T UARTQueue[256];
} UartCyclicBuf;

#endif

/* Block signals and states (default storage) for system '<Root>' */
typedef struct {
  PosProfilerState G_PosProfilerState; /* '<Root>/Data Store Memory5' */
  PosProfilerData G_PosProfilerData;   /* '<Root>/Data Store Memory2' */
} DW;

/* Imported (extern) states */
extern CANCyclicBuf G_CANCyclicBuf_in; /* '<S3>/G_CANCyclicBuf_in' */
extern CANCyclicBuf G_CANCyclicBuf_out;/* '<S3>/G_CANCyclicBuf_out' */
extern UartCyclicBuf G_UartCyclicBuf_in;/* '<S4>/G_UartCyclicBuf_in' */
extern UartCyclicBuf G_UartCyclicBuf_out;/* '<S4>/G_UartCyclicBuf_out' */
extern MicroInterp G_MicroInterp;      /* '<S4>/G_MicroInterp' */
extern SetupReportBuf G_SetupReportBuf;/* '<Root>/Data Store Memory1' */
extern DrvCommandBuf G_DrvCommandBuf;  /* '<Root>/Data Store Memory3' */
extern FeedbackBuf G_FeedbackBuf;      /* '<Root>/Data Store Memory' */

/* Block signals and states (default storage) */
extern DW rtDW;

/*
 * Exported Global Parameters
 *
 * Note: Exported global parameters are tunable parameters with an exported
 * global storage class designation.  Code generation will declare the memory for
 * these parameters and exports their symbols.
 *
 */
extern PosProfilerState PosProfilerState_init;/* Variable: PosProfilerState_init
                                               * Referenced by: '<Root>/Data Store Memory5'
                                               */
extern PosProfilerData PosProfilerData_init;/* Variable: PosProfilerData_init
                                             * Referenced by: '<Root>/Data Store Memory2'
                                             */
extern SEALVerControl SEALVerControl_init;/* Variable: SEALVerControl_init
                                           * Referenced by: '<Root>/Data Store Memory6'
                                           */

/*
 * Exported States
 *
 * Note: Exported states are block states with an exported global
 * storage class designation.  Code generation will declare the memory for these
 * states and exports their symbols.
 *
 */
extern SEALVerControl G_SEALVerControl;/* '<Root>/Data Store Memory6' */

/* Model entry point functions */
extern void Seal_initialize(void);

/* Exported entry point function */
extern void ISR100u(void);

/* Exported entry point function */
extern void IdleLoopCAN(void);

/* Exported entry point function */
extern void IdleLoopUART(void);

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Seal'
 * '<S1>'   : 'Seal/100usecPeriodic'
 * '<S2>'   : 'Seal/DocBlock'
 * '<S3>'   : 'Seal/Idle process CAN interpreter'
 * '<S4>'   : 'Seal/Idle process UART interpreter'
 * '<S5>'   : 'Seal/100usecPeriodic/MATLAB Function'
 * '<S6>'   : 'Seal/Idle process CAN interpreter/CAN message response'
 * '<S7>'   : 'Seal/Idle process UART interpreter/UART message response'
 */

/*-
 * Requirements for '<Root>': Seal


 */
#endif                                 /* Seal_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
