#ifndef __LZMA_DECOMPRESS__
#define __LZMA_DECOMPRESS__

typedef unsigned long (__stdcall *LZMA_UNPACK)(void *pvDest, void *pvSource, void* pvWorkMem);

#ifdef __cplusplus
extern "C" {
#endif

LZMA_UNPACK __stdcall GetUnpackerPointer();

#ifdef __cplusplus
} 
#endif

#endif