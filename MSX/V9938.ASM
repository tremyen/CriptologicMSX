; =============================================================================
; V9938.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX2
; =============================================================================
; IN (To function)
; SSCCCCCCCCRRRRRRR		=> S=Tela, C=Coluna, R=Linha
; AHHHHHHHHLLLLLLLL   => Endereco de memoria
; =============================================================================
; OUT (To GPU)
; 333222222211111111
; sssmrrrrrrrccccccc	=> Tela,Modo 1=write/0=read,Linha,Coluna
; 100000000000000     => metade de baixo da tela
; ===========================================================================

; ===========================================================================
; GetScreenPos
; ===========================================================================
; Retorna a posicao de memoria no para HL da coordenada em BC (x,y)
; são 128 bytes por linha, então fazemos o shift de C em uma casa para a
; direita, para pegarmos o ultimo bit no registrador L para fazer o loc
; da memória.
; ===========================================================================
GetScreenPos:
	push bc
		xor a
		ld h,c
		rr h								          ; Move todos os bytes um para direita
		rr a
		or b
		ld l,a
		xor a								          ; Banco de tela 0
		ld (ScreenLinePos_Plus2-2),hl
		call VDP_SetWriteAddress
	pop bc
ret

; ===========================================================================
; GetNextLine
; ===========================================================================
GetNextLine:
	push hl
	 push bc
	  push af
		  ld hl,&0000
        ScreenLinePos_Plus2:
		    ld bc,&0080				             ; adicionar 128 pula uma linha
		    add hl,bc
		    ld (ScreenLinePos_Plus2-2),hl
		    xor a					                ; Banco de memoria zero
		    call VDP_SetWriteAddress
    pop af
   pop bc
	pop hl
ret

; ===========================================================================
; VDP_SetReadAddress
; ===========================================================================
VDP_SetReadAddress:
	ld C,0			          ;Bit 6=0 when reading, 1 when writing
	jr VDP_SetAddress
VDP_SetWriteAddress:
	ld C,64
VDP_SetAddress:
;       A        H        L
;000000SS YMYYYYYY YXXXXXXX	S=Screen Y=vert line X=horiz byte M=RW mode
	      rlc     h
              rla
              rlc     h
              rla
              srl     h
              srl     h
;              di
              out     (VdpOut_Control),a       ;set bits 15-17
              ld      a,14+128
              out     (VdpOut_Control),a
              ld      a,l           ;set bits 0-7
              nop
              out     (VdpOut_Control),a
              ld      a,h           ;set bits 8-14
              or      C            ; 64= write access 0=read
;              ei
              out     (VdpOut_Control),a
			  ld c,VdpIn_Data
              ret

; ===========================================================================
; ScreenINIT
; ===========================================================================
ScreenINIT:
	ld a,%00000110		;6 - set graphics screen mode bits
	out (VdpOut_Control),a
	ld a,128+0		;[ 0 ] [DG ] [IE2] [IE1] [M5] [M4] [M3] [ 0 ]
	out (VdpOut_Control),a

	ld a,%01100000  	; Enable Screen - Enable Retrace Interrupt
	out (VdpOut_Control),a
	ld a,128+1		;R#1  [ 0 ] [BL ] [IE0] [M1 ] [ M2] [ 0 ] [SI ] [MAG]
	out (VdpOut_Control),a

	ld a,31
	out (VdpOut_Control),a
	ld a,128+2		;Pattern layout table
	out (VdpOut_Control),a

	ld a,239
	out (VdpOut_Control),a
	ld a,128+5		; Sprite Attrib Table Low
	out (VdpOut_Control),a

	ld a,%11110000;1	;		Low nibble defines background color (0 or 1 ?)
	out (VdpOut_Control),a
	ld a,128+7		;Text and screen margin color
	out (VdpOut_Control),a

	ld a,128
	out (VdpOut_Control),a
	ld a,128+10		;Color Table High (Don't know what this does!)
	out (VdpOut_Control),a

	ld a,%00001010		;Set up Vram (Shrug!) [VR=1] [SPD=SpriteDisable]
	out (VdpOut_Control),a
	ld a,128+8		;R#8  [MS ] [LP ] [TP ] [CB ] [VR ] [ 0 ] [SPD] [BW ]
	out (VdpOut_Control),a

	ld a,%00000000 		;[LN ]=1 212 lines / [LN ]=0 = 192 lines
	out (VdpOut_Control),a
	ld a,128+9	        ;R#9  [LN ] [ 0 ] [S1 ] [S0 ] [IL ] [E0 ] [*NT] [DC ]
	out (VdpOut_Control),a
ret
