[BITS 16]
[ORG 0500h]

call defineWindow
jmp returnKernel

defineWindow:
	mov ah, 0Ch
	mov al, 01h			;Cor - azul
	mov cx, 50			;Posição da tela - Coluna 50
	mov dx, 50			;Posição da tela - Linha 50
	jmp window

window:
	lineUp:
		int 10h
		inc cx
		cmp cx, 100
		jne lineUp
	lineRight:
		int 10h
		inc dx
		cmp dx, 100
		jne lineRight
	lineDown:
		int 10h
		dec cx
		cmp cx, 50
		jne lineDown
	lineLeft:
		int 10h
		dec dx
		cmp dx, 50
		jne lineLeft
	ret

returnKernel:
	ret