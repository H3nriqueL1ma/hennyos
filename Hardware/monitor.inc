;----------------------------------------------------
; Monitor Library Routines - HennyOS by Henrique Lima
; Version 1.0.0
;----------------------------------------------------

%IFNDEF __MONITOR_LIB__
%DEFINE __MONITOR_LIB__

;* Main Strings ***************************************************
systemName db "HennyOS", 0
;******************************************************************

;* Monitor & Window Configs *************************************************
count dw 0000h

backWidth dw 0000h
backHeight dw 0000h
backColor db 08h
pagination db 0
cursorX db 15
cursorY db 12
state db 0
;******************************************************************

;* Routine Library ************************************************
VGA.setVideoMode:
	mov	ah, 00h			
	mov al, 13h			
	int 10h
	mov ax, 320
	mov word[backWidth], ax
	mov ax, 200
	mov word[backHeight], ax
	call drawPixelConfig
	ret

drawPixelConfig:
	mov ah, 0Ch
	mov al, [backColor]
	mov cx, 0			;Posição da tela - Coluna 0
	mov dx, 0			;Posição da tela - Linha 0
	ret

drawBackground:
	int 10h
	inc cx
	cmp cx, word[backWidth]
	jne drawBackground
	mov cx, 0
	inc dx
	cmp dx, word[backHeight]
	jne drawBackground
	mov dx, 0
	ret

printString:
	mov ah, 09h
	mov bh, [pagination]
	mov bl, 0Fh
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

showString:
	mov dh, [cursorY]					
	mov dl, [cursorX]					
	call moveCursor
	mov si, systemName
	call printString
	mov ah, 00
	int 16h
	ret

delay:
	pusha
	mov bx, 0
	time:
		inc bx
		cmp bx, 500		;500 -> Máquina Virtual | 50000 -> Máquina Real
		jne time
	popa
	ret
;******************************************************************
%ENDIF