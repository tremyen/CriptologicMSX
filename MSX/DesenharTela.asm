; =============================================================================
; DesenharTela.asm
; =============================================================================
; Manoel Neto 2019-10-22
; =============================================================================
; Desligar a tela
; Limpar a tela
; Inicializar a tela em modo 32x24
; Setar as cores de fundo e borda
; Apagar as teclas de funcao
; Imprimir cabecalho do jogo
; Imprimir mesagem inicial
; Desenhar duas linhas
; Posicionar o cursor na posicao da entrada do jogador 1
; Religar a tela
; =============================================================================
DesenharTela:
	call DISSCR             		; desligo a exibição da tela
	call LimparTela             ; limpo a tela
	call ScreenInit             ; inicializo a tela
  ld a,15
  ld (FORCLR),a               ; seto a cor da fonte
  ld a,1
  ld (BAKCLR),a               ; seto a cor do background
  ld a,1
  ld (BDRCLR),a               ; seto a cor da borda
  call CHGCLR                 ; uso a bios para alterar as cores
	call ERAFNK             		; desligo as teclas de função
	ld a,32                     ; preparo a largura da tela
  ld (LINL32),a           		; largura da tela em 32 colunas
	call LoadPatternTable       ; CARREGO A TABELA DE PADROES
	call LoadSpritesTable				; CARREGO A TABELA DE SPRITES

	; Imprimir o Cabecalho
	ld h,NumPosXCabecalho       ; Coordenada X
  ld l,NumPosYCabecalho       ; Coordenada Y
  call POSIT                  ; posicionar o cabecalho
  ld hl,MsgUsuario1           ; Cabecalho
  call PrintString            ; imprimir o cabecalho

	; Imprimir a Mensagem Inicial
  ld h,NumPosXMensagens       ; Coordenada X
  ld l,NumPosYMensagens       ; Coordenada Y
  call POSIT                  ; posicionar mensagem inicial
  ld hl,MsgUsuario2           ; mensagem inicial
  call PrintString            ; imprimir mensagem inicial

	; Imprimir linha da apoio 1
	ld b,NumPosXLinhaApoio      ; posicionar a linha de apoio 1 x
  ld c,NumPosYLinhaApoio1     ; posicionar a linha de apoio 1 y
  call GetVDPScreenPos        ; pegar a area de memoria da posicao BC em HL
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,14                		; bytes a copiar
  ld hl,LinhaReta	      			; tabela de nomes
  call LDIRVM             		; copio na VRAM

	; Mudar cor da Linha de apoio 1
	ld b,NumPosXLinhaApoio      ; posicionar a linha de apoio 1 x
  ld c,NumPosYLinhaApoio1     ; posicionar a linha de apoio 1 y
  call GetColorMemPos	        ; pegar a area de memoria da tabela de cores
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,2	                		; bytes a copiar
  ld hl,CorAzul	      				; tabela de nomes
  call LDIRVM             		; copio na VRAM

	; Imprimir linha da apoio 2
	ld b,NumPosXLinhaApoio      ; posicionar a linha de apoio 2 x
  ld c,NumPosYLinhaApoio2     ; posicionar a linha de apoio 2 y
  call GetVDPScreenPos        ; pegar a area de memoria da posicao BC em HL
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,14                		; bytes a copiar
  ld hl,LinhaReta	      			; Padrao da tabela de nomes
  call LDIRVM             		; copio na VRAM

  call ENASCR             		; religo a tela
ret
