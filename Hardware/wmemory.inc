;-----------------------------------------------------------------------
; Memory Library Routines - HennyOS by Henrique Lima
; Version 1.0.0
;-----------------------------------------------------------------------


%ifndef __WMEMORY_LIB__
%define __WMEMORY_LIB__

;* Memory & Window Configs *********************************************
%define window_Bar			3000h
%define window_Width		3001h
%define window_Height		3003h
%define window_PositionX	3005h
%define window_PositionY	3007h
%define window_Bar_Color	300Ah
%define window_Back_Color	300Bh
%define buttonClose			300Ch
%define buttonMaximize		300Dh
%define buttonMinimize		300Eh

stateWindowBar			 dw 0000h
savePositionX			 dw 0000h
savePositionY			 dw 0000h
saveWidth				 dw 0000h
saveHeight				 dw 0000h
;***********************************************************************
%endif