[BITS 16]
[ORG 0x7C00]
global boot

boot: jmp main
nop

pagination				db 0

;* Messages ************************************************************
bracket1				db "[ ", 0
bracket2				db " ]", 0
ok						db "OK", 0
bootloader_started_msg	db " Started BOOTLOADER.", 0x0D, 0x0A, 0
kernel_loaded_msg		db " Started KERNEL.", 0x0D, 0x0A, 0
bootloader_complete_msg db "       BOOTLOADER Complete.", 0x0D, 0x0A, 0
hennyos_starting_msg	db "       Starting HennyOS...", 0x0D, 0x0A, 0
;***********************************************************************

;############ Main Start Boot ############
main:
	call delay

	call bootloader_msg_loading

	call LoadSystem

	call delay

	call kernel_msg_loading

	call delay

	mov si, bootloader_complete_msg
	call printMsg

	call delay

	mov si, hennyos_starting_msg
	call printMsg

	call delayFinal

	jmp 0800h:0000h

;############ Load the system ############ 
LoadSystem:
	mov ah, 02h			
	mov al, 1			;1 setor
	mov ch, 0			;Trilha 0
	mov cl, 2			;Setor 2 a ser lido - Contém o Kernel
	mov dh, 0			;Cabeçote 0
	mov dl, 00h			;Primeiro disco bootável (Disquete)

	mov bx, 0800h		;Segmento
	mov es, bx			
	mov bx, 0000h		;Offset
	int 0x13			
	ret

;* Functions ***********************************************************
printMsg:
	mov ah, 0eh
	.start_loop:
		lodsb
		cmp al, 0
		je .end_loop
		int 10h
		jmp .start_loop
	.end_loop:
		ret

ShowString:
	mov dh, 0					
	mov dl, 1					
	call moveCursor
	mov si, ok
	call printString
	ret

ShowString2:
	mov dh, 1
	mov dl, 1
	call moveCursor
	mov si, ok
	call printString
	ret

printString:
	mov ah, 09h
	mov bh, [pagination]
	mov bl, 0000_0010b
	mov cx, 1
	mov al, [si]
	print:
		int 10h
		inc si
		call moveCursor
		mov ah, 09h
		mov al, [si]
		cmp al, 0
		jne print
	ret

moveCursor:
	mov ah, 02h
	mov bh, [pagination]
	inc dl
	int 10h
	ret

delay:
    mov cx, 0      
    mov dx, 0      
outer_loop:
    mov ax, 0FFFFh
inner_loop:
    dec ax         
    jnz inner_loop 

    inc cx         
    cmp cx, 70			;70 -> Máquina Virtual | 1000 -> Máquina Real    
    jne outer_loop 
    ret 

delayFinal:
    mov cx, 0      
    mov dx, 0      
outer_loop1:
    mov ax, 0FFFFh
inner_loop1:
    dec ax         
    jnz inner_loop1

    inc cx         
    cmp cx, 100			;100 -> Máquina Virtual | 1200 -> Máquina Real 
    jne outer_loop1 
    ret 
	
bootloader_msg_loading:
	mov si, bracket1
	call printMsg

	call ShowString

	mov si, bracket2
	call printMsg

	mov si, bootloader_started_msg
	call printMsg
	ret

kernel_msg_loading:
	mov si, bracket1
	call printMsg

	call ShowString2

	mov si, bracket2
	call printMsg

	mov si, kernel_loaded_msg
	call printMsg
	ret
;***********************************************************************

;############ Boot Signature ############
times 510 - ($-$$) db 0
dw 0xAA55