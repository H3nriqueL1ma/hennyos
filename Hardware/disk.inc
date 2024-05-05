;-----------------------------------------------------------------------
; Disk/Memory Library Routines - HennyOS by Henrique Lima
; Version 1.0.0
;-----------------------------------------------------------------------

%ifndef __DISK_LIB__
%define __DISK_LIB__

;* Disk & Memory Configs ***********************************************
windowAddress	dw 0x500

segmentAddr		dw 0000h
offsetAddr		dw 0000h
sector			db 0
track			db 0
head			db 0
drive			db 0
numSectors		db 0

reader			db 02h
writer			db 03h

sectorPerTrack	db 0
trackPerHead	db 0
;***********************************************************************

;* Routine Library *****************************************************
readDisk:
	mov ah, byte[reader]
	call diskOperation
	ret

writeDisk:
	mov ah, byte[writer]
	call diskOperation
	ret

diskOperation:
	mov al, byte[numSectors]
	mov ch, byte[track]
	mov cl, byte[sector]
	mov dh, byte[head]
	mov dl, byte[drive]
	mov bx, word[segmentAddr]
	mov es, bx
	mov bx, word[offsetAddr]
	int 13h
	ret
;***********************************************************************
%endif