[BITS 16]
[ORG 0000h]			;Endereço onde o Kernel está armazenado

jmp OSMain

backWidth db 0
backHeight db 0
pagination db 0

;############ Operating System Entry ############ 
OSMain:
	call configSegment
	call configStack
	call TEXT.SetVideoMode

;############ Segment Config ############ 
configSegment:
	mov ax, es
	mov dx, ax
	ret

;############ Stack Config ############ 
configStack:
	;Endereço da pilha = 7D00h:03FEh
	mov ax, 7D00h		;Endereço base da pilha - Custom
	mov ss, ax			
	mov sp, 03FEh		;Ponteiro da pilha - Custom
	ret

############ Video Mode Config ############ 
TEXT.SetVideoMode:
	mov ah, 00h			
	mov al, 03h			
	int 10h
	mov byte[backWidth], 80		;Largura da tela
	mov byte[backHeight], 20	;Altura da tela
	ret