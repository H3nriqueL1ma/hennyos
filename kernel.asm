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
	call backColor
	jmp ShowString

ShowString:
	mov dh, 3					;3° linha da tela
	mov dl, 28					;3° coluna da tela - dl 2+1
	call moveCursor
	mov si, welcome
	call printString
	mov ah, 00
	int 16h
	jmp END

;############ Segment Config ############ 
configSegment:
	mov ax, es
	mov ds, ax
	ret

;############ Stack Config ############ 
configStack:
	;Endereço da pilha = 7D00h:03FEh
	mov ax, 7D00h				;Endereço base da pilha 
	mov ss, ax			
	mov sp, 03FEh				;Ponteiro da pilha
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
	mov bl, 1111_0001b
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

backColor:
	mov ah, 06h					;Limpar a tela
	mov al, 0
	mov bh, 0001_1111b			;Cor de fundo -> 0001_1111b <- Cor do texto
	mov ch, 0					;Coluna inicial
	mov cl, 0					;Linha inicial
	mov dh, 5					;Quantidade de linhas a terem cor
	mov dl, 80					;Quantidade de colunas a terem cor
	int 10h
	ret
;******************************************************************

END:
	int 19h