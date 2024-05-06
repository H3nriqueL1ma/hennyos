[BITS 16]
[ORG 0000h]

jmp OSMain

;* Directives and Inclusions *******************************************
%include "Hardware/wmemory.inc" 
%include "Hardware/monitor.inc"
%include "Hardware/disk.inc"

;***********************************************************************

;############ Operating System Entry ############ 
OSMain:
	call configSegment
	call configStack
	call VGA.setVideoMode
	call drawBackground
	call showString
	call graphicInterface
	jmp END

;* Kernel Functions ****************************************************
graphicInterface:
	mov byte[sector], 3
	mov byte[drive], 00h
	mov byte[numSectors], 1
	mov word[segmentAddr], 0800h
	mov word[offsetAddr], 0500h
	call readDisk
	call windowAddress
	ret

configSegment:
	mov ax, es
	mov ds, ax
	ret

configStack:
	;Endereço da pilha = 7D00h:03FEh
	mov ax, 7D00h				;Endereço base da pilha 
	mov ss, ax			
	mov sp, 03FEh				;Ponteiro da pilha
	ret

END:
	mov ah, 00h
	int 16h
	mov ax, 0040h
	mov ds, ax
	mov ax, 1234h
	mov [0072h], ax
	jmp 0FFFFh:0000h