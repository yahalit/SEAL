#define N_FUNC_DESCRIPTORS 16 


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


typedef struct {
    /* SEAL database version */
    uint16_T Version;

    /* SEAL database sub version */
    uint16_T SubVersion;

    /* SEAL database support data */
    uint32_T UserData;
} SEALVerControl;

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




enum E_FunType
{
    E_Func_Initializer = 1,
    E_Func_Idle = 2,
    E_Func_ISR = 3
};

typedef void (*voidFunc)(void);
typedef struct
{
    voidFunc func; 
    float Ts; 
    enum E_FunType FunType; 
    short unsigned nInts  ; 
    short unsigned Priority   ;
    short unsigned Algn;
    long  Ticker;
} FuncDescriptor;

typedef short unsigned* bPtr; 

#define SEAL_MODULE_ADDRESS 0x84000UL

const short unsigned** SM_BufferPtrs = (short unsigned**)(SEAL_MODULE_ADDRESS+0x40);
const short unsigned** SM_FuncDescriptorPtrs = (short unsigned**)(SEAL_MODULE_ADDRESS + 0x80);
const short unsigned* pSealRevision = (short unsigned**)(SEAL_MODULE_ADDRESS + 0xb0);
const short unsigned* pGenesisVerse = (short unsigned**)(SEAL_MODULE_ADDRESS + 0xc0);
const char unsigned GenesisVerse[53] = "In the beginning God created the heaven and the earth";
const FuncDescriptor* = (FuncDescriptor*)(SEAL_MODULE_ADDRESS + 0x100);

const short unsigned SealExpectedVersions[4] = {1,2,3,4} ;

volatile short unsigned RunSealIdleLoop;

long unsigned TickerValue; 
short unsigned nIdleRun; 

void GoSeal()
{
    // Test that Baruch Gamili is there 
    short cnt, verseGood , versionGood , eol , funcgood ;
    DrvCommandBuf* pDrvCommandBuf; 
    FeedbackBuf* pFeedbackBuf;
    SetupReportBuf* pSetupReportBuf; 
    CANCyclicBuf* pCANCyclicBuf_in;
    CANCyclicBuf* pCANCyclicBuf_out;
    UartCyclicBuf* pUartCyclicBuf_in; 
    UartCyclicBuf* pUartCyclicBuf_out;
    SEALVerControl* pSEALVerControl; 

    FuncDescriptor InitalizerFunc; 
    FuncDescriptor IdleFuncs[N_FUNC_DESCRIPTORS];
    FuncDescriptor IsrFuncs[N_FUNC_DESCRIPTORS];
    short unsigned nIdleFuncs; 
    short unsigned nIsrFuncs;
    short unsigned nInitFuncs;
    float Ts, quo;

    Ts = __fmax( ReadTsFromIPC() , 1.0e-6f) ; 
    MemClr((short unsigned)&FuncDescriptor[0], sizeof(FuncDescriptor));

    verseGood = 1;
    for (cnt = 0; cnt < 53; cnt++)
    {
        if (GenesisVerse[cnt] != ((char*)pGenesisVerse)[cnt])
        {
            verseGood = 0; 
        }
    }
    versionGood = 1; 
    for (cnt = 0; cnt < 4; cnt++)
    {
        if (pSealRevision[cnt] != SealExpectedVersions[cnt])
        {
            versionGood  = 0; 
        }
    } 

    if (verseGood && versionGood)
    {
        pDrvCommandBuf = (DrvCommandBuf*)SM_BufferPtrs[0]; 
        pFeedbackBuf = (FeedbackBuf*)SM_BufferPtrs[1];
        pSetupReportBuf = (SetupReportBuf*)SM_BufferPtrs[2];
        pCANCyclicBuf_in = (CANCyclicBuf*)SM_BufferPtrs[3];
        pCANCyclicBuf_out = (CANCyclicBuf*)SM_BufferPtrs[4];
        pUartCyclicBuf_in = (UartCyclicBuf*)SM_BufferPtrs[5];
        pUartCyclicBuf_out = (UartCyclicBuf*)SM_BufferPtrs[6];
        pSEALVerControl = (SEALVerControl*)SM_BufferPtrs[7];
    }

    // Read the descriptor of functions
    eol = 0; 
    nIdleFuncs = 0; 
    nIsrFuncs = 0; 
    nInitFuncs = 0; 
    funcgood = 1; 

    for (cnt = 0; cnt < N_FUNC_DESCRIPTORS ; cnt++ )
    {
        if (FuncDescriptor[cnt].func == MULL)
        {
            break; 
        }
        switch (FuncDescriptor[cnt].FunType)
        {
        case E_Func_Initializer: 
            InitalizerFunc = FuncDescriptor[cnt]; 
            nInitFuncs += 1; 
            break; 
        case E_Func_Idle: 
            IdleFuncs[nIdleFuncs] = FuncDescriptor[cnt];
            nIdleFuncs += 1;
            break; 
        case E_Func_ISR: 
            IsrFuncs[nIsrFuncs] = FuncDescriptor[cnt];
            nIsrFuncs += 1;
            quo = IsrFuncs[nIsrFuncs].Ts / Ts  ; 
            IsrFuncs[nIsrFuncs].nInts = (short unsigned)(quo + 0.001);
            if (quo < 0.999f || ) > fabsf(quo - IsrFuncs[nIsrFuncs].nInts ) > 0.001f)
            {
                funcgood = 0 ; 
            }
            break;
        default:
            eol = 1; 
            break; 
        }
        if (eol)
        {
            break; 
        }
    }
    // Check one and only init func
    if (nInitFuncs != 1)
    {
        funcgood = 0; 
    }
    RunSealIdleLoop = 0; 
    if (funcgood)
    {
        PrepSetupReportBuf(); // Done once

        TickerValue = GetInterruptCtr() ; 

        for (cnt = 0; cnt < N_FUNC_DESCRIPTORS; cnt++)
        {
            IsrFuncs[cnt].Ticker = TickerValue;
            IdleFuncs[cnt].Ticker = TickerValue;
        }
        nIdleRun = 0;
        while (RunSealIdleLoop == 0)
        {
            SealLoop();
        } 
    }
}

void SealLoop()
{
    short unsigned NextFuncDecided, cnt;
    short bestPrio , nfunc ;
    long unsigned delta_ticker;
    FuncDescriptor* pDesc;

    VoidFunc NextFunc2Call;

    NextFuncDecided = 0; 
    TickerValue  = GetInterruptCtr(); 
    // Queue interrupts
    bestPrio = -1; 
    NextFunc2Call = NULL; 
    nfunc = 0; 
    for (cnt = 0; cnt < nIsrFuncs; cnt++)
    {
        pDesc = &IsrFuncs[cnt]; 
        delta_ticker = TickerValue - pDesc->Ticker; 
        if (delta_ticker > pDesc->nInts)
        {
            prio = delta_ticker - pDesc->nInts + pDesc->Priority;
            if (prio > bestPrio)
            {
                bestPrio = prio; 
                nfunc = cnt;
            }
        }
    }
    if (bestPrio > 0)
    {
        NextFunc2Call = IsrFuncs[nfunc].func; 
        IsrFuncs[nfunc].Ticker = TickerValue; 
    }
    else
    {
        NextFunc2Call = IdleFuncs[nIdleRun]; 
        nIdleRun += 1; 
        if (nIdleRun >= nIdleFuncs)
        {
            nIdleRun = 0; 
        }
    }

    if (NextFunc2Call == NULL)
    {
        continue; 
    }
    
    // Decide next function to call 

    // Prepare for the go
    PrepFeedbackBuf(); 

    NextFunc2Call(); 

    UpdateDrvCmdBuf();

}

