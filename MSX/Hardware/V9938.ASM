; =============================================================================
; V9938.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX2
; =============================================================================
VdpOut_Data: 					equ &98
VdpOut_Control: 			equ &99
VdpOut_Palette: 			equ &9A
; =============================================================================
; Setar paleta
; =============================================================================
; 00	transparent
; 01	black
; 02	medium green
; 03	light green
; 04	dark blue
; 05	light blue
; 06	dark red
; 07	cyan
; 08	medium red
; 09	light red
; 10	dark yellow
; 11	light yellow
; 12	dark green
; 13	magenta
; 14	gray
; 15	white
; =============================================================================
SetPalette:
	cp 16												; Apenas 16 cores
	ret nc
	out (VdpOut_Control),a			; Manda a cor para o controle
	ld a,128+16									; Registrador Palette = 16
	out (VdpOut_Control),a
	ld a,l
	and %11101110								; Soh 3 bits para o V9938
	rrca
	out (VdpOut_Palette),a			; formata -RRR-BBB
	ld a,h
	and %11101110
	rrca
	out (VdpOut_Palette),a			; formata -----GGG
ret
