[BITS 16]
[ORG 0000h]			

jmp OSMain

backWidth db 0
backHeight db 0
pagination db 0

;* Messages *******************************************************
welcome db "Bem-vindo ao HennyOS!", 0
;******************************************************************

;############ Operating System Entry ############ 
OSMain:
	call configSegment
	call configStack
	call TEXT.SetVideoMode
	jmp ShowString

ShowString:
	mov dh, 3			;3° linha da tela
	mov dl, 2			;3° coluna da tela - dl 2+1
	call moveCursor
	mov si, welcome
	call printString
	jmp END

;############ Segment Config ############ 
configSegment:
	mov ax, es
	mov ds, ax
	ret

;############ Stack Config ############ 
configStack:
	;Endereço da pilha = 7D00h:03FEh
	mov ax, 7D00h		;Endereço base da pilha - Custom
	mov ss, ax			
	mov sp, 03FEh		;Ponteiro da pilha - Custom
	ret

;############ Video Mode Config ############ 
TEXT.SetVideoMode:
	mov ah, 00h			
	mov al, 03h			
	int 10h
	mov byte[backWidth], 80		;Largura da tela
	mov byte[backHeight], 20	;Altura da tela
	ret

;* Functions ******************************************************
printString:
	mov ah, 09h
	mov bh, [pagination]
	mov bl, 40
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

printMsg:
	mov ah, 0x0E
.start_loop:
	lodsb

	cmp al, 0
	je .end_loop
	int 0x10

	jmp .start_loop
.end_loop:
	ret
;******************************************************************

END:
	jmp $