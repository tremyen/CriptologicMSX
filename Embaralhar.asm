;=========================================================================================
; Embaralhar Frase
; Achar a posicao sorteada na matriz			=> AcharPosSort
; Achar a letra nessa posicao da matriz			=> AcharLetra
; Gravar a letra encontrada em sua posicao embaralhada	=> GravarLetra
; Imprimir a frase inicial 				=> StrFrase
; Imprimir a frase Embaralhada 				=> StrFraseEmb
;=========================================================================================
Embaralhar:
	xor a				; prepara primeira passada
	ld (NumContEmb),a		; zera o contador de embaralhamento
GravarProxima:	
	call AcharPosSort		; achar a posicao sorteada 
	call AcharLetra			; acha a letra dessa passada
	call GravarLetra		; gravar a letra dessa passada
	ld a,(NumTamFrase)
	ld b,a
	ld a,(NumContEmb)		
	cp b				; se pegamos todos
	jp z,GravouTudo			; gravamos tudo 
	inc a 				; senao vamos para a proxima
	ld (NumContEmb),a		; e guardamos no contador
	jp GravarProxima		; pega a proxima
GravouTudo:
	call NovaLinha			; pula linha
	ld hl,MsgUsuario3		; imprime mensagem para o usuario
	call PrintString		; print
	ld hl,StrFraseEmb		; imprime a frase embaralhada
	call PrintString		; print
	call NovaLinha	
ret

AcharPosSort:
	ld a,(NumContEmb)
	ld hl,MatSorteados
LoopAcharPosSort:
	cp 0
	jp z,AchouPosSort
	dec a
	inc hl
	jp LoopAcharPosSort
AchouPosSort:
	ld a,(hl)
	ld (NumPosSort),a
ret

AcharLetra:
	ld a,(NumPosSort)
	dec a 				; enderecos comecam com 0
	ld hl,StrFrase
LoopAcharLetra:
	cp 0
	jp z,AchouLetra			
	dec a
	inc hl
	jp LoopAcharLetra
AchouLetra:
	ld a,(hl)
	ld (ChaLetraAtual),a
ret

GravarLetra:
	ld a,(NumContEmb)
	ld b,a
	ld a,0
	ld hl,StrFraseEmb
LoopGravarLetra:
	cp b
	jp z,AchouPosGravar			
	inc hl
	inc a	
	jp LoopGravarLetra
AchouPosGravar:
	ld a,(ChaLetraAtual)
	ld (hl),a
	inc hl
	ld (hl),13
ret