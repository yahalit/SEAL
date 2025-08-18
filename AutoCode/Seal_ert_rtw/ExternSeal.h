#ifndef EXTERN_SEAL_DEF_H
#define EXTERN_SEAL_DEF_H
typedef const short unsigned * bPtr
const char unsigned Gamili[] = "Mi Haya Baruch Gamili";
#pragma DATA_SECTION (Gamili,.DS_GAMILI)
CANCyclicBuf G_CANCyclicBuf_in;
CANCyclicBuf G_CANCyclicBuf_out;
UartCyclicBuf G_UartCyclicBuf_in;
UartCyclicBuf G_UartCyclicBuf_out;
MicroInterp G_MicroInterp;
SetupReportBuf G_SetupReportBuf;
DrvCommandBuf G_DrvCommandBuf;
FeedbackBuf G_FeedbackBuf;
const short unsigned * BufferPtrs[16] = {(bPtr)&G_DrvCommandBuf,(bPtr)&G_FeedbackBuf,(bPtr)&G_SetupReportBuf,(bPtr)&G_CANCyclicBuf_in,(bPtr)&G_CANCyclicBuf_out,(bPtr)&G_SEALVerControl,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
#pragma DATA_SECTION (BufferPtrs,.DS_INTFC_PTRS)
#endif
