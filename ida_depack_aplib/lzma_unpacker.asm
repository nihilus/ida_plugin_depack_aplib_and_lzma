; Author:   Brandon LaCombe
; Date:     February 3, 2006
; License:  Public Domain
.386
.model flat, stdcall
option casemap:none

.code

GetUnpackerSize proc
    mov eax, unpacker_end - unpacker_start
    ret
GetUnpackerSize endp

GetUnpackerPointer proc
    mov eax, unpack
    ret
GetUnpackerPointer endp

; modification - deroko of ARTeam
; unpacker code doesn't preserve esi,edi,ebx so new
; procedure is added which will preserve those registers
unpack  proc    pvDest:dword, pvSource:dword, pvWorkMem:dword
        pushad
        push    pvWorkMem
        push    pvSource
        push    pvDest
        call    unpacker_start
        mov     [esp+1ch], eax
        popad
        ret
unpack  endp
        

unpacker_start:

    ; TODO: Implement assembly unpacker function here.
    ; The C prototype for this function is:
    ; DWORD STDCALL Unpack(PVOID pvDest, PVOID pvSource, PVOID pvWorkMem);
    ; The return value is the size of the uncompressed data.
    ; Note that if you don't have an assembly unpacker you can simply
    ; disassemble the compiled version of your high level unpacker code.
                push    ebp
                mov     ebp, esp
                sub     esp, 30h
                xor     eax, eax
                inc     eax
                mov     edi, [ebp+10h]
                mov     [ebp-14h], eax
                mov     [ebp-1Ch], eax
                mov     [ebp-18h], eax
                mov     [ebp-28h], eax
                mov     eax, 400h
                xor     edx, edx
                mov     ecx, 30736h
                rep stosd
                mov     eax, [ebp+0Ch]
                push    5
                mov     [ebp-8], eax
                mov     [ebp-10h], edx
                mov     [ebp-1], dl
                mov     [ebp-0Ch], edx
                mov     [ebp+0Ch], edx
                or      eax, 0FFFFFFFFh
                pop     ecx

loc_401041:                             ; CODE XREF: .text:00401056j
                mov     esi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     edx, 8
                or      edx, esi
                inc     dword ptr [ebp-8]
                dec     ecx
                mov     [ebp+0Ch], edx
                jnz     loc_401041

loc_401058:                             ; CODE XREF: .text:004011EAj
                                        ; .text:004011F9j ...
                mov     esi, [ebp-10h]
                mov     ecx, [ebp-0Ch]
                mov     edx, [ebp+10h]
                and     esi, 3
                shl     ecx, 4
                add     ecx, esi
                cmp     eax, 1000000h
                lea     edi, [edx+ecx*4]
                jnb     loc_40108A
                mov     edx, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   edx, byte ptr [edx]
                shl     ecx, 8
                or      ecx, edx
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_40108A:                             ; CODE XREF: .text:00401071j
                mov     ecx, [edi]
                mov     ebx, eax
                shr     ebx, 0Bh
                imul    ebx, ecx
                cmp     [ebp+0Ch], ebx
                jnb     loc_401207
                mov     esi, 800h
                sub     esi, ecx
                shr     esi, 5
                add     esi, ecx
                movzx   ecx, byte ptr [ebp-1]
                imul    ecx, 0C00h
                xor     edx, edx
                mov     [edi], esi
                mov     esi, [ebp+10h]
                inc     edx
                cmp     dword ptr [ebp-0Ch], 7
                lea     ecx, [ecx+esi+1CD8h]
                mov     eax, ebx
                mov     [ebp-20h], ecx
                jl      loc_401170
                mov     ecx, [ebp-10h]
                sub     ecx, [ebp-14h]
                mov     esi, [ebp+8]
                movzx   ecx, byte ptr [ecx+esi]
                mov     [ebp-24h], ecx

loc_4010E1:                             ; CODE XREF: .text:00401168j
                shl     dword ptr [ebp-24h], 1
                mov     esi, [ebp-24h]
                mov     edi, [ebp-20h]
                and     esi, 100h
                cmp     eax, 1000000h
                lea     ecx, [esi+edx]
                lea     ecx, [edi+ecx*4+400h]
                mov     [ebp-2Ch], ecx
                jnb     loc_40111B
                mov     ebx, [ebp-8]
                mov     edi, [ebp+0Ch]
                movzx   ebx, byte ptr [ebx]
                shl     edi, 8
                or      edi, ebx
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edi

loc_40111B:                             ; CODE XREF: .text:00401102j
                mov     ecx, [ecx]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, ecx
                cmp     [ebp+0Ch], edi
                jnb     loc_401149
                mov     eax, edi
                mov     edi, 800h
                sub     edi, ecx
                shr     edi, 5
                add     edi, ecx
                mov     ecx, [ebp-2Ch]
                add     edx, edx
                test    esi, esi
                mov     [ecx], edi
                jnz     loc_4011C9
                jmp     loc_401162
; ---------------------------------------------------------------------------

loc_401149:                             ; CODE XREF: .text:00401128j
                sub     [ebp+0Ch], edi
                sub     eax, edi
                mov     edi, ecx
                shr     edi, 5
                sub     ecx, edi
                test    esi, esi
                mov     edi, [ebp-2Ch]
                mov     [edi], ecx
                lea     edx, [edx+edx+1]
                jz      loc_4011C9

loc_401162:                             ; CODE XREF: .text:00401147j
                cmp     edx, 100h
                jl      loc_4010E1
                jmp     loc_4011D1
; ---------------------------------------------------------------------------

loc_401170:                             ; CODE XREF: .text:004010CBj
                                        ; .text:004011CFj
                cmp     eax, 1000000h
                mov     ecx, [ebp-20h]
                lea     edi, [ecx+edx*4]
                jnb     loc_401194
                mov     esi, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     ecx, 8
                or      ecx, esi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_401194:                             ; CODE XREF: .text:0040117Bj
                mov     ecx, [edi]
                mov     esi, eax
                shr     esi, 0Bh
                imul    esi, ecx
                cmp     [ebp+0Ch], esi
                jnb     loc_4011B7
                mov     eax, esi
                mov     esi, 800h
                sub     esi, ecx
                shr     esi, 5
                add     esi, ecx
                mov     [edi], esi
                add     edx, edx
                jmp     loc_4011C9
; ---------------------------------------------------------------------------

loc_4011B7:                             ; CODE XREF: .text:004011A1j
                sub     [ebp+0Ch], esi
                sub     eax, esi
                mov     esi, ecx
                shr     esi, 5
                sub     ecx, esi
                mov     [edi], ecx
                lea     edx, [edx+edx+1]

loc_4011C9:                             ; CODE XREF: .text:00401141j
                                        ; .text:00401160j ...
                cmp     edx, 100h
                jl      loc_401170

loc_4011D1:                             ; CODE XREF: .text:0040116Ej
                mov     esi, [ebp-10h]
                mov     ecx, [ebp+8]
                inc     dword ptr [ebp-10h]
                cmp     dword ptr [ebp-0Ch], 4
                mov     [ebp-1], dl
                mov     [esi+ecx], dl
                jge     loc_4011EF
                and     dword ptr [ebp-0Ch], 0
                jmp     loc_401058
; ---------------------------------------------------------------------------

loc_4011EF:                             ; CODE XREF: .text:004011E4j
                cmp     dword ptr [ebp-0Ch], 0Ah
                jge     loc_4011FE
                sub     dword ptr [ebp-0Ch], 3
                jmp     loc_401058
; ---------------------------------------------------------------------------

loc_4011FE:                             ; CODE XREF: .text:004011F3j
                sub     dword ptr [ebp-0Ch], 6
                jmp     loc_401058
; ---------------------------------------------------------------------------

loc_401207:                             ; CODE XREF: .text:00401097j
                sub     [ebp+0Ch], ebx
                mov     edx, ecx
                shr     edx, 5
                sub     ecx, edx
                mov     edx, [ebp-0Ch]
                sub     eax, ebx
                cmp     eax, 1000000h
                mov     [edi], ecx
                mov     ecx, [ebp+10h]
                lea     edx, [ecx+edx*4+300h]
                jnb     loc_401240
                mov     edi, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   edi, byte ptr [edi]
                shl     ecx, 8
                or      ecx, edi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_401240:                             ; CODE XREF: .text:00401227j
                mov     ecx, [edx]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, ecx
                cmp     [ebp+0Ch], edi
                jnb     loc_401292
                mov     eax, edi
                mov     edi, 800h
                sub     edi, ecx
                shr     edi, 5
                add     edi, ecx
                cmp     dword ptr [ebp-0Ch], 7
                mov     ecx, [ebp-18h]
                mov     [ebp-28h], ecx
                mov     ecx, [ebp-1Ch]
                mov     [ebp-18h], ecx
                mov     ecx, [ebp-14h]
                mov     [edx], edi
                mov     [ebp-1Ch], ecx
                jge     loc_40127D
                and     dword ptr [ebp-0Ch], 0
                jmp     loc_401284
; ---------------------------------------------------------------------------

loc_40127D:                             ; CODE XREF: .text:00401275j
                mov     dword ptr [ebp-0Ch], 3

loc_401284:                             ; CODE XREF: .text:0040127Bj
                mov     ecx, [ebp+10h]
                add     ecx, 0CC8h
                jmp     loc_40147B
; ---------------------------------------------------------------------------

loc_401292:                             ; CODE XREF: .text:0040124Dj
                sub     [ebp+0Ch], edi
                sub     eax, edi
                mov     edi, ecx
                shr     edi, 5
                sub     ecx, edi
                cmp     eax, 1000000h
                mov     [edx], ecx
                mov     ecx, [ebp-0Ch]
                mov     edx, [ebp+10h]
                lea     edi, [edx+ecx*4+330h]
                jnb     loc_4012CB
                mov     edx, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   edx, byte ptr [edx]
                shl     ecx, 8
                or      ecx, edx
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_4012CB:                             ; CODE XREF: .text:004012B2j
                mov     ecx, [edi]
                mov     edx, eax
                shr     edx, 0Bh
                imul    edx, ecx
                cmp     [ebp+0Ch], edx
                jnb     loc_40137F
                mov     ebx, 800h
                sub     ebx, ecx
                shr     ebx, 5
                add     ebx, ecx
                mov     ecx, [ebp-0Ch]
                add     ecx, 0Fh
                shl     ecx, 4
                mov     [edi], ebx
                mov     edi, [ebp+10h]
                add     ecx, esi
                cmp     edx, 1000000h
                mov     eax, edx
                lea     edi, [edi+ecx*4]
                jnb     loc_401320
                mov     ecx, [ebp+0Ch]
                shl     edx, 8
                mov     eax, edx
                mov     edx, [ebp-8]
                movzx   edx, byte ptr [edx]
                shl     ecx, 8
                or      ecx, edx
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_401320:                             ; CODE XREF: .text:00401305j
                mov     ecx, [edi]
                mov     edx, eax
                shr     edx, 0Bh
                imul    edx, ecx
                cmp     [ebp+0Ch], edx
                jnb     loc_40136C
                mov     esi, [ebp-10h]
                mov     eax, edx
                mov     edx, 800h
                sub     edx, ecx
                shr     edx, 5
                add     edx, ecx
                xor     ecx, ecx
                cmp     dword ptr [ebp-0Ch], 7
                mov     [edi], edx
                mov     edx, [ebp+8]
                setnl   cl
                lea     ecx, [ecx+ecx+9]
                mov     [ebp-0Ch], ecx
                mov     ecx, [ebp-10h]
                sub     ecx, [ebp-14h]
                inc     dword ptr [ebp-10h]
                mov     cl, [ecx+edx]
                mov     [ebp-1], cl
                mov     [esi+edx], cl
                jmp     loc_401058
; ---------------------------------------------------------------------------

loc_40136C:                             ; CODE XREF: .text:0040132Dj
                sub     [ebp+0Ch], edx
                sub     eax, edx
                mov     edx, ecx
                shr     edx, 5
                sub     ecx, edx
                mov     [edi], ecx
                jmp     loc_40145F
; ---------------------------------------------------------------------------

loc_40137F:                             ; CODE XREF: .text:004012D8j
                sub     [ebp+0Ch], edx
                sub     eax, edx
                mov     edx, ecx
                shr     edx, 5
                sub     ecx, edx
                cmp     eax, 1000000h
                mov     edx, [ebp+10h]
                mov     [edi], ecx
                mov     ecx, [ebp-0Ch]
                lea     edx, [edx+ecx*4+360h]
                jnb     loc_4013B8
                mov     edi, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   edi, byte ptr [edi]
                shl     ecx, 8
                or      ecx, edi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_4013B8:                             ; CODE XREF: .text:0040139Fj
                mov     ecx, [edx]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, ecx
                cmp     [ebp+0Ch], edi
                jnb     loc_4013DC
                mov     eax, edi
                mov     edi, 800h
                sub     edi, ecx
                shr     edi, 5
                add     edi, ecx
                mov     ecx, [ebp-1Ch]
                mov     [edx], edi
                jmp     loc_401456
; ---------------------------------------------------------------------------

loc_4013DC:                             ; CODE XREF: .text:004013C5j
                sub     [ebp+0Ch], edi
                sub     eax, edi
                mov     edi, ecx
                shr     edi, 5
                sub     ecx, edi
                cmp     eax, 1000000h
                mov     [edx], ecx
                mov     ecx, [ebp-0Ch]
                mov     edx, [ebp+10h]
                lea     edx, [edx+ecx*4+390h]
                jnb     loc_401415
                mov     edi, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   edi, byte ptr [edi]
                shl     ecx, 8
                or      ecx, edi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_401415:                             ; CODE XREF: .text:004013FCj
                mov     ecx, [edx]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, ecx
                cmp     [ebp+0Ch], edi
                jnb     loc_401439
                mov     eax, edi
                mov     edi, 800h
                sub     edi, ecx
                shr     edi, 5
                add     edi, ecx
                mov     ecx, [ebp-18h]
                mov     [edx], edi
                jmp     loc_401450
; ---------------------------------------------------------------------------

loc_401439:                             ; CODE XREF: .text:00401422j
                sub     [ebp+0Ch], edi
                sub     eax, edi
                mov     edi, ecx
                shr     edi, 5
                sub     ecx, edi
                mov     [edx], ecx
                mov     edx, [ebp-18h]
                mov     ecx, [ebp-28h]
                mov     [ebp-28h], edx

loc_401450:                             ; CODE XREF: .text:00401437j
                mov     edx, [ebp-1Ch]
                mov     [ebp-18h], edx

loc_401456:                             ; CODE XREF: .text:004013DAj
                mov     edx, [ebp-14h]
                mov     [ebp-1Ch], edx
                mov     [ebp-14h], ecx

loc_40145F:                             ; CODE XREF: .text:0040137Aj
                xor     ecx, ecx
                cmp     dword ptr [ebp-0Ch], 7
                setnl   cl
                dec     ecx
                and     ecx, 0FFFFFFFDh
                add     ecx, 0Bh
                mov     [ebp-0Ch], ecx
                mov     ecx, [ebp+10h]
                add     ecx, 14D0h

loc_40147B:                             ; CODE XREF: .text:0040128Dj
                cmp     eax, 1000000h
                jnb     loc_401499
                mov     edi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   edi, byte ptr [edi]
                shl     edx, 8
                or      edx, edi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edx

loc_401499:                             ; CODE XREF: .text:00401480j
                mov     edx, [ecx]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, edx
                cmp     [ebp+0Ch], edi
                jnb     loc_4014C5
                mov     eax, edi
                mov     edi, 800h
                sub     edi, edx
                shr     edi, 5
                add     edi, edx
                shl     esi, 5
                and     dword ptr [ebp-24h], 0
                mov     [ecx], edi
                lea     ecx, [esi+ecx+8]
                jmp     loc_401523
; ---------------------------------------------------------------------------

loc_4014C5:                             ; CODE XREF: .text:004014A6j
                sub     [ebp+0Ch], edi
                sub     eax, edi
                mov     edi, edx
                shr     edi, 5
                sub     edx, edi
                cmp     eax, 1000000h
                mov     [ecx], edx
                jnb     loc_4014F1
                mov     edi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   edi, byte ptr [edi]
                shl     edx, 8
                or      edx, edi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edx

loc_4014F1:                             ; CODE XREF: .text:004014D8j
                mov     edx, [ecx+4]
                mov     edi, eax
                shr     edi, 0Bh
                imul    edi, edx
                cmp     [ebp+0Ch], edi
                jnb     loc_40152C
                mov     eax, edi
                mov     edi, 800h
                sub     edi, edx
                shr     edi, 5
                add     edi, edx
                shl     esi, 5
                mov     [ecx+4], edi
                lea     ecx, [esi+ecx+208h]
                mov     dword ptr [ebp-24h], 8

loc_401523:                             ; CODE XREF: .text:004014C3j
                mov     dword ptr [ebp-20h], 3
                jmp     loc_40154F
; ---------------------------------------------------------------------------

loc_40152C:                             ; CODE XREF: .text:004014FFj
                sub     [ebp+0Ch], edi
                mov     esi, edx
                shr     esi, 5
                sub     edx, esi
                sub     eax, edi
                mov     [ecx+4], edx
                add     ecx, 408h
                mov     dword ptr [ebp-24h], 10h
                mov     dword ptr [ebp-20h], 8

loc_40154F:                             ; CODE XREF: .text:0040152Aj
                mov     edx, [ebp-20h]
                xor     ebx, ebx
                mov     [ebp-2Ch], edx
                inc     ebx

loc_401558:                             ; CODE XREF: .text:004015B1j
                cmp     eax, 1000000h
                jnb     loc_401576
                mov     esi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     edx, 8
                or      edx, esi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edx

loc_401576:                             ; CODE XREF: .text:0040155Dj
                mov     edx, [ecx+ebx*4]
                mov     esi, eax
                shr     esi, 0Bh
                imul    esi, edx
                cmp     [ebp+0Ch], esi
                jnb     loc_40159B
                mov     eax, esi
                mov     esi, 800h
                sub     esi, edx
                shr     esi, 5
                add     esi, edx
                mov     [ecx+ebx*4], esi
                add     ebx, ebx
                jmp     loc_4015AE
; ---------------------------------------------------------------------------

loc_40159B:                             ; CODE XREF: .text:00401584j
                sub     [ebp+0Ch], esi
                sub     eax, esi
                mov     esi, edx
                shr     esi, 5
                sub     edx, esi
                mov     [ecx+ebx*4], edx
                lea     ebx, [ebx+ebx+1]

loc_4015AE:                             ; CODE XREF: .text:00401599j
                dec     dword ptr [ebp-2Ch]
                jnz     loc_401558
                mov     ecx, [ebp-20h]
                xor     edx, edx
                inc     edx
                mov     esi, edx
                shl     esi, cl
                mov     ecx, [ebp-24h]
                sub     ecx, esi
                add     ebx, ecx
                cmp     dword ptr [ebp-0Ch], 4
                mov     [ebp-30h], ebx
                jge     loc_401765
                add     dword ptr [ebp-0Ch], 7
                cmp     ebx, 4
                jge     loc_4015DE
                mov     ecx, ebx
                jmp     loc_4015E1
; ---------------------------------------------------------------------------

loc_4015DE:                             ; CODE XREF: .text:004015D8j
                push    3
                pop     ecx

loc_4015E1:                             ; CODE XREF: .text:004015DCj
                mov     esi, [ebp+10h]
                shl     ecx, 8
                lea     edi, [ecx+esi+6C0h]
                mov     dword ptr [ebp-2Ch], 6

loc_4015F5:                             ; CODE XREF: .text:0040164Ej
                cmp     eax, 1000000h
                jnb     loc_401613
                mov     esi, [ebp-8]
                mov     ecx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     ecx, 8
                or      ecx, esi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], ecx

loc_401613:                             ; CODE XREF: .text:004015FAj
                mov     ecx, [edi+edx*4]
                mov     esi, eax
                shr     esi, 0Bh
                imul    esi, ecx
                cmp     [ebp+0Ch], esi
                jnb     loc_401638
                mov     eax, esi
                mov     esi, 800h
                sub     esi, ecx
                shr     esi, 5
                add     esi, ecx
                mov     [edi+edx*4], esi
                add     edx, edx
                jmp     loc_40164B
; ---------------------------------------------------------------------------

loc_401638:                             ; CODE XREF: .text:00401621j
                sub     [ebp+0Ch], esi
                sub     eax, esi
                mov     esi, ecx
                shr     esi, 5
                sub     ecx, esi
                mov     [edi+edx*4], ecx
                lea     edx, [edx+edx+1]

loc_40164B:                             ; CODE XREF: .text:00401636j
                dec     dword ptr [ebp-2Ch]
                jnz     loc_4015F5
                sub     edx, 40h
                cmp     edx, 4
                mov     edi, edx
                jl      loc_401736
                mov     ecx, edx
                sar     ecx, 1
                and     edi, 1
                dec     ecx
                or      edi, 2
                cmp     edx, 0Eh
                mov     [ebp-14h], ecx
                jge     loc_401683
                shl     edi, cl
                mov     ecx, edi
                sub     ecx, edx
                mov     edx, [ebp+10h]
                lea     ebx, [edx+ecx*4+0ABCh]
                jmp     loc_4016C9
; ---------------------------------------------------------------------------

loc_401683:                             ; CODE XREF: .text:0040166Fj
                sub     ecx, 4

loc_401686:                             ; CODE XREF: .text:004016B4j
                cmp     eax, 1000000h
                jnb     loc_4016A4
                mov     esi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     edx, 8
                or      edx, esi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edx

loc_4016A4:                             ; CODE XREF: .text:0040168Bj
                shr     eax, 1
                add     edi, edi
                cmp     [ebp+0Ch], eax
                jb      loc_4016B3
                sub     [ebp+0Ch], eax
                or      edi, 1

loc_4016B3:                             ; CODE XREF: .text:004016ABj
                dec     ecx
                jnz     loc_401686
                mov     ebx, [ebp+10h]
                add     ebx, 0C88h
                shl     edi, 4
                mov     dword ptr [ebp-14h], 4

loc_4016C9:                             ; CODE XREF: .text:00401681j
                xor     ecx, ecx
                inc     ecx
                mov     [ebp-20h], ebx
                mov     [ebp-24h], ecx

loc_4016D2:                             ; CODE XREF: .text:00401734j
                cmp     eax, 1000000h
                jnb     loc_4016F0
                mov     esi, [ebp-8]
                mov     edx, [ebp+0Ch]
                movzx   esi, byte ptr [esi]
                shl     edx, 8
                or      edx, esi
                shl     eax, 8
                inc     dword ptr [ebp-8]
                mov     [ebp+0Ch], edx

loc_4016F0:                             ; CODE XREF: .text:004016D7j
                mov     edx, [ebx+ecx*4]
                mov     esi, eax
                shr     esi, 0Bh
                imul    esi, edx
                cmp     [ebp+0Ch], esi
                jnb     loc_401715
                mov     eax, esi
                mov     esi, 800h
                sub     esi, edx
                shr     esi, 5
                add     esi, edx
                mov     [ebx+ecx*4], esi
                add     ecx, ecx
                jmp     loc_40172E
; ---------------------------------------------------------------------------

loc_401715:                             ; CODE XREF: .text:004016FEj
                sub     [ebp+0Ch], esi
                mov     ebx, [ebp-20h]
                sub     eax, esi
                mov     esi, edx
                shr     esi, 5
                sub     edx, esi
                or      edi, [ebp-24h]
                mov     [ebx+ecx*4], edx
                lea     ecx, [ecx+ecx+1]

loc_40172E:                             ; CODE XREF: .text:00401713j
                shl     dword ptr [ebp-24h], 1
                dec     dword ptr [ebp-14h]
                jnz     loc_4016D2

loc_401736:                             ; CODE XREF: .text:00401658j
                inc     edi
                mov     [ebp-14h], edi
                jz      loc_40176A
                mov     ebx, [ebp-30h]

loc_40173F:                             ; CODE XREF: .text:00401768j
                mov     ecx, [ebp-10h]
                inc     ebx
                sub     ecx, edi
                inc     ebx
                add     ecx, [ebp+8]

loc_401749:                             ; CODE XREF: .text:0040175Ej
                mov     dl, [ecx]
                mov     esi, [ebp-10h]
                mov     edi, [ebp+8]
                dec     ebx
                inc     dword ptr [ebp-10h]
                inc     ecx
                test    ebx, ebx
                mov     [ebp-1], dl
                mov     [esi+edi], dl
                jnz     loc_401749
                jmp     loc_401058
; ---------------------------------------------------------------------------

loc_401765:                             ; CODE XREF: .text:004015CBj
                mov     edi, [ebp-14h]
                jmp     loc_40173F
; ---------------------------------------------------------------------------

loc_40176A:                             ; CODE XREF: .text:0040173Aj
                mov     eax, [ebp-10h]
                leave
                retn    0Ch

unpacker_end:

end
