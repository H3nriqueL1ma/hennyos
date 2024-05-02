[BITS 16]
[ORG 0x7C00]
global boot

boot: jmp main
nop

;* Messages *******************************************************
bootloader_started_msg db "Bootloader started...", 0x0D, 0x0A, 0
kernel_loaded_msg db "Kernel loaded...", 0x0D, 0x0A, 0
bootloader_complete_msg db "Bootloader complete.", 0x0D, 0x0A, 0
;******************************************************************

;############ Main Start Boot ############
main:
	call delay

	mov si, bootloader_started_msg
	call printMsg

	call LoadSystem

	call delay

	mov si, kernel_loaded_msg
	call printMsg

	call delay

	mov si, bootloader_complete_msg
	call printMsg

	call delay

	jmp 0x8000:0x0000

;############ Load the system ############ 
LoadSystem:
	mov ah, 02h			;Ler discos
	mov al, 1			;1 setor
	mov ch, 0			;Trilha 0
	mov cl, 2			;Setor 2 a ser lido - Contém o Kernel
	mov dh, 0			;Cabeçote 0
	mov dl, 0x00		;Primeiro disco bootável

	mov bx, 0x8000		;Segmento
	mov es, bx			;Guardando o segmento no segmento extra
	mov bx, 0x0000
	int 0x13			;Interrupção do BIOS para ler setores
	ret

;* Functions ******************************************************
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

delay:
    mov cx, 0      ; Inicializa CX com zero
    mov dx, 0      ; Inicializa DX com zero
outer_loop:
    mov ax, 0FFFFh ; Define o valor de AX com o máximo possível
inner_loop:
    dec ax         ; Decrementa AX
    jnz inner_loop ; Repete o loop interno até que AX seja zero

    inc cx         ; Incrementa CX
    cmp cx, 150    ; Verifica se CX atingiu o valor para aproximadamente 5 segundos
    jne outer_loop ; Se CX não atingiu o valor, repete o loop externo
    ret            ; Retorna quando o atraso for concluído

;******************************************************************

;############ Boot Signature ############
times 510 - ($-$$) db 0
dw 0xAA55