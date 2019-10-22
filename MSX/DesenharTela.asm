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
	call ScreenINIT             ; inicializo a tela
  ld a,15
  ld (FORCLR),a               ; seto a cor da fonte
  ld a,5
  ld (BAKCLR),a               ; seto a cor do background
  ld a,1
  ld (BDRCLR),a               ; seto a cor da borda
  call CHGCLR                 ; uso a bios para alterar as cores
	call ERAFNK             		; desligo as teclas de função
	ld a,32                     ; preparo a largura da tela
  ld (LINL32),a           		; largura da tela em 32 colunas
	call LoadPatternTable       ; CARREGO A TABELA DE PADROES

  ld h,NumPosXCabecalho       ; Coordenada X
  ld l,NumPosYCabecalho       ; Coordenada Y
  call POSIT                  ; posicionar o cabecalho
  ld hl,MsgUsuario1           ; Cabecalho
  call PrintString            ; imprimir o cabecalho

  ld h,NumPosXMensagens       ; Coordenada X
  ld l,NumPosYMensagens       ; Coordenada Y
  call POSIT                  ; posicionar mensagem inicial
  ld hl,MsgUsuario2           ; mensagem inicial
  call PrintString            ; imprimir mensagem inicial

  ld b,NumPosXLinhaApoio      ; posicionar a linha de apoio 1 x
  ld c,NumPosYLinhaApoio1     ; posicionar a linha de apoio 1 y
  call GetVDPScreenPos        ; pegar a area de memoria da posicao BC em HL
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,14                		; bytes a copiar
  ld hl,LinhaReta	      			; tabela de nomes
  call LDIRVM             		; copio na VRAM

  ld b,NumPosXLinhaApoio      ; posicionar a linha de apoio 2 x
  ld c,NumPosYLinhaApoio2     ; posicionar a linha de apoio 2 y
  call GetVDPScreenPos        ; pegar a area de memoria da posicao BC em HL
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,14                		; bytes a copiar
  ld hl,LinhaReta	      			; tabela de nomes
  call LDIRVM             		; copio na VRAM

  ld h,NumPosXEntradas        ; Coordenada X
  ld l,NumPosYEntrada1        ; Coordenada Y
  call POSIT                  ; posicionar para a primeira entrada

  call ENASCR             		; religo a tela
ret
