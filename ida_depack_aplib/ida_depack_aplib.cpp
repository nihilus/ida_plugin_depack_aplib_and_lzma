// ida_aplib_depack plugin 
//				(c) deroko of ARTeam
// this code uses depack.c which is part of aPlib
// this code also uses Brandon LaCombe's lzma unpacking  
// code which is part of Packman source code to support
// this type of unpacking engine...


#define __NT__
#define __IDP__
#define MAXSTR 1024
#include <windows.h>

#include <ida.hpp>
#include <idp.hpp>
#include <expr.hpp>
#include <bytes.hpp>
#include <loader.hpp>
#include <kernwin.hpp>
#include "depack.h"
#include "lzma_unpack.h"

#pragma comment(lib, "ida")


#define MEGA_BYTE	1024*1024

char *aplib_depack_dialog = 
        "STARTITEM 0\n"
        "aplib depack - deroko of ARTeam\n"
        "                                                    \n"
        "<#address of packed data#Unpack from     :M:10:10::>\n"
        "<#address where to unpack#Unpack to     :M:10:10::>\n"
        "<#internal memory usage, default is 1MB\nspecify more if unpack fails#Work memory:D:5:5::> megabyte(s)\n"
        "<#use aplib to decompress#select decompression engine##"
        "aplib                            :r>\n"
        "<#use lzma from packman code to decompress#lzma                             :r>>\n";

#define aplib_decompression 0x0
#define lzma_decompression  0x1
#define lzma_workmem_size   0x0C1CD8


int idaapi aplib_depack_init(){
        return PLUGIN_OK;
}

void idaapi aplib_depack_term(){}

void idaapi aplib_depack_run(int arg){
        uval_t packed_start = 0;
        uval_t unpacked_start = 0;
        uval_t size_in_bytes  = 0;
        sval_t internal_megabytes = 1;
        ushort d_engine = aplib_decompression;
        int    response;
        void   *s_memory, *d_memory, *w_memory;
        uint   ap_res;
        bool   b_val, b_exit = false;
        segment_t *segm;
        PULONG sig;
        LZMA_UNPACK lzma_Unpack;
	
        // prompt user for an info about needed data
        // - where is packed data
        // - where we should store packed data
        // - how many megabytes to use for decompression
        //   as aplib in it's fast decompression routine
        //   can't know in advance size of uncompressed data
        //   same goes for lzma...
        // - propmpt user about decompression library to be used
        //   note that aplib is default, as it's standard in alsmot
        //   all protections nowadays...
        response = AskUsingForm_c(aplib_depack_dialog, &packed_start, &unpacked_start, &internal_megabytes, &d_engine);
        if (!response){
                msg("aplib_depack : aborted...\n");
                return;
        }

        lzma_Unpack = GetUnpackerPointer();
        // check if unpack_from/unpack_to addresses are valid
        // this can be done by trying to locate segment by address
        // if no segment is present, then address is invalid 
        segm = getseg(unpacked_start);
        if (!segm){
                msg("aplib_depack : unpack to address invalid\n");
                return;
        }
        segm = getseg(packed_start);
        if (!segm){
                msg("aplib_depack : unpack from address invalid\n");
                return;
        }


        size_in_bytes = segm->endEA - packed_start - 1;
        s_memory = VirtualAlloc(0, size_in_bytes, MEM_COMMIT, PAGE_READWRITE);
        if (!s_memory){
                msg("aplib_depack : can't allocate memory for unpacking... Aborting unpacking...\n");
                return;
        }

        sig = (PULONG)s_memory;
        sig[0] = 0xdeadc0de;
        sig[1] = 0xdeadbeef;
        sig[2] = 0x11111111;
        sig[3] = 0x22222222;

        d_memory = VirtualAlloc(0, internal_megabytes * MEGA_BYTE, MEM_COMMIT, PAGE_READWRITE);
        if (!d_memory){
                VirtualFree(s_memory, 0, MEM_DECOMMIT);
                msg("aplib_depack : can't allocate memory for unpacking... Aborting unpacking...\n");
                return;
        }

        // put everything into __try/__finally so we
        // will have memory freeing only once in the code
        __try{
                // __try/__except is used to protect us from small buffer
                // when decompressing. If exception occurs here, you will
                // be prompted to select more mega bytes for internal work
                __try{
                        // get_many_bytes may fail because we reached part of uniinitialized data in IDA
                        // database, this can happen when SizeOfRawData != VirtualSize, so we will check if
                        // our read buffer is marked, if not everything went fine and we have certain amount of 
                        // bytes read and we continue!!!
                        b_val= get_many_bytes(packed_start, s_memory, size_in_bytes);
                        if (!b_val && 
                            sig[0] == 0xdeadc0de &&
                            sig[1] == 0xdeadbeef &&
                            sig[2] == 0x11111111 &&
                            sig[3] == 0x22222222){
                                msg("aplib_depack : can't read 0x%.08X bytes from database\n", size_in_bytes);
                                b_exit = true;
                                __leave;		
                                }
			
                        // signatures from allocated s_memory are gone so this is partial read
                        // and probably it's all that we need!!
                        if (!b_val)
                                msg("aplib_depack : partial read...\n");
			
                        // depack data, and display size of unpacked data
                        // otherwise display error... this is only valid 
                        // for aplib (error code...)
                        switch (d_engine){
                                case aplib_decompression:
                                        msg("aplib_depack : decompressing using aplib_depack...\n");
                                        ap_res = aP_depack(s_memory, d_memory);
                                        if (ap_res == APLIB_ERROR){
                                                msg("aplib_depack : failed to unpack... maybe this isn't aplib afterall!?!?!?\n");
                                                b_exit = true;
                                                __leave;
                                        }
                                        break;
                                case lzma_decompression:
                                        msg("aplib_depack : decompressing using lzma from packman...\n");
                                        w_memory = VirtualAlloc(0, lzma_workmem_size, MEM_COMMIT, PAGE_READWRITE);
                                        if (!w_memory){
                                                msg("aplib_depack : failed to allocate memory for lzma decompression\n");
                                                b_exit = true;
                                                __leave;
                                        }

                                        ap_res = lzma_Unpack(d_memory, s_memory, w_memory);
                                        VirtualFree(w_memory, 0, MEM_DECOMMIT);
                                        break;
                        }
			
                        msg("aplib_depack : unpacked size %.08X bytes\n", ap_res);
                        // copy unpacked data into IDA database and we are done
                        // this could take a while depending on size of unpacked 
                        // data
                        patch_many_bytes(unpacked_start, d_memory, ap_res);

                }__except(EXCEPTION_EXECUTE_HANDLER){
                        msg("aplib_depack : failed try to specify more memory for internal working\n");
                        b_exit = true;
                        __leave;
                }
        }__finally{
                VirtualFree(d_memory, 0, MEM_DECOMMIT);
                VirtualFree(s_memory, 0, MEM_DECOMMIT);
        }

        if (b_exit) return;
        msg("aplib_depack : successfully executed...\n");
        return;
}

plugin_t PLUGIN = {
        IDP_INTERFACE_VERSION,
        0,
        aplib_depack_init,
        aplib_depack_term,
        aplib_depack_run,
        NULL,
        NULL,
        "aplib depack",
        "Ctrl-9"
};