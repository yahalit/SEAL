#ifndef EXTERN_SEAL_DEF_H
#define EXTERN_SEAL_DEF_H
typedef const short unsigned * bPtr
const char unsigned GenesisVerse[] = "In the beginning God created the heaven and the earth";
#pragma DATA_SECTION (GenesisVerse,.DS_GENESIS_VERSE)
CANCyclicBuf_T G_CANCyclicBuf_in;
CANCyclicBuf_T G_CANCyclicBuf_out;
UartCyclicBuf_T G_UartCyclicBuf_in;
UartCyclicBuf_T G_UartCyclicBuf_out;
MicroInterp_T G_MicroInterp;
SetupReportBuf_T G_SetupReportBuf;
DrvCommandBuf_T G_DrvCommandBuf;
FeedbackBuf_T G_FeedbackBuf;
(voidFunc) InitializeFuncs[8] = {(voidFunc)Seal_initialize,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL}; 
VoidFun IdleLoopFuncs[8] ={
{.func = (voidFunc) IdleLoopCAN, .FunType =2, .Priority=8, .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0},
{.func = (voidFunc) IdleLoopUART, .FunType =2, .Priority=7, .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}};
VoidFun IsrFuncs[8] ={
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}};
VoidFun SetupFuncs[8] ={
{.func = (voidFunc) SetupDrive, .FunType =4, .Priority=8, .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}};
VoidFun AbortFuncs[8] ={
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}};
VoidFun ExceptionFuncs[8] ={
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0},
{.func = (voidFunc) NULL, .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}};
const short unsigned * BufferPtrs[16] = {(bPtr)&G_DrvCommandBuf,(bPtr)&G_FeedbackBuf,(bPtr)&G_SetupReportBuf,(bPtr)&G_CANCyclicBuf_in,(bPtr)&G_CANCyclicBuf_out,(bPtr)&G_UartCyclicBuf_in,(bPtr)&G_UartCyclicBuf_out,(bPtr)&G_SEALVerControl,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
#pragma DATA_SECTION (BufferPtrs,.DS_INTFC_PTRS)
#endif
