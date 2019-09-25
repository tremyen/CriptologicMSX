; =============================================================================
; Pegar os chutes do jogador 2
; Pegar chute e gravar => (CaracterTestar)
; Testar se o caracter esta na posicao atual (TestarCorreto)
; Gravar letra na frase embaralhada
; =============================================================================
PegarChute:
	call NovaLinha
	ld hl,MsgUsuario10
	call PrintString
	call NovaLinha
	xor a
	ld (NumContTeste),a
	ld (NumContErros),a
LoopPegaChar:
	call PegarEntrada
	jp TestarCorreto
EstaCorreto:
	call CursorCorreto
	ld a,(NumContTeste)
	add a,13
	ld h,a
	ld l,5
	call POSIT
	ld a,(ChaTestar)
	call CHPUT
	ld a,(NumTamFrase)
	dec a
	ld b,a
	ld a,(NumContTeste)
	cp b
	jp z,Acertou
	inc a
	ld (NumContTeste),a
	jp LoopPegaChar
Acertou:
	call ImprimirErros
ret

PegarEntrada:
	ld h,1
	ld l,6
	call POSIT
	ld hl,LimpaLinha
	call PrintString
	ld h,1
	ld l,6
	call POSIT
	ld hl,MsgUsuario5
	call PrintString
	call CHGET
	ld (ChaTestar),a
ret

TestarCorreto:
	ld hl,StrFrase
	ld a,(NumContTeste)						; Conta o teste
AcharPosicaoTeste:
	cp 0
	jp z,AchouTeste
	inc hl
	dec a													; proximo teste
	jp AcharPosicaoTeste
AchouTeste:
	ld a,(hl)
	ld b,a
	ld a,(ChaTestar)
	cp b
	jp z,EstaCorreto
	ld a,(NumContErros)
	inc a
	ld (NumContErros),a
	call CursorErrado
	jp LoopPegaChar
ImprimirErros:
	ld h,1
	ld l,10
	call POSIT
	ld hl,MsgUsuario8
	call PrintString
	call NovaLinha
	ld hl,MsgUsuario9
	call PrintString
	ld a,(NumContErros)
	call PrintNumber
	call NovaLinha
ret

CursorCorreto:
		ld h,1
		ld l,7
		call POSIT
		ld hl,LimpaLinha
		call PrintString
		ld h,1
		ld l,7
		call POSIT
		ld hl,MsgUsuario6
		call PrintString
ret

CursorErrado:
		ld h,1
		ld l,7
		call POSIT
		ld hl,LimpaLinha
		call PrintString
		ld h,1
		ld l,7
		call POSIT
		ld hl,MsgUsuario7
		call PrintString
ret
