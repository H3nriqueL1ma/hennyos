[BITS 16]
[ORG 7C00h]			;Endere�o onde o bootloader est� armazenado

call LoadSystem
jmp 0800h:0000h		;Passa a execu��o para o controle do Kernel

;############ Load the system ############ 
LoadSystem:
	mov ah, 02h		
	mov al, 1		;1 setor
	mov ch, 0		;Trilha 0
	mov cl, 2		;Setor 2 a ser lido - Cont�m o Kernel
	mov dh, 0		;Cabe�ote 0
	mov dl, 80h		;Primeiro disco boot�vel

	;Endere�o de mem�ria = 0800h:0000h - Segmento:Offset - 65535 bytes:Primeiro offset do Segmento
	mov bx, 0800h	
	mov es, bx		
	mov bx, 0000h
	int 13h			;Interrup��o do BIOS para ler setores
	ret

times 510 - ($-$$) db 0
dw 0xAA55