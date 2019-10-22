; =============================================================================
; DesenharTela.asm
; =============================================================================
; Manoel Neto 2019-10-03
; =============================================================================
; Inicializar a tela em modo 32x24
; Setar as cores de fundo e borda
; Imprimir cabecalho do jogo
; Trocar a cor para roxo
; Desenhar duas linhas
; posicionar o cursor na posicao (9,10)
; =============================================================================
DesenharTela:
	call DISSCR             		; desligo a exibição da tela
	call LimparTela             ; limpo a tela
	call ScreenINIT             ; inicializo a tela
	call ERAFNK             		; desligo as teclas de função
	ld a,32
  ld (LINL32),a           		; largura da tela em 32 colunas
	call LoadPatternTable       ; CARREGO A TABELA DE PADROES
  call LoadNamesTable	        ; CARREGO A TABELA DE NOME

  ld h,NumPosXCabecalho       ; posicionar o cabecalho
  ld l,NumPosYCabecalho
  call POSIT
  ld hl,MsgUsuario1
  call PrintString            ; imprimir o cabecalho

  ld h,NumPosXMensagens       ; posicionar mensagem inicial
  ld l,NumPosYMensagens
  call POSIT
  ld hl,MsgUsuario2           ; imprimir mensagem inicial
  call PrintString

  ld h,NumPosXLinhaApoio      ; posicionar a linha de apoio 1
  ld l,NumPosYLinhaApoio1
  call POSIT
  ld hl,LinhaApoio
  call PrintString            ; imprimir a linha de apoio 1

  ld h,NumPosXLinhaApoio      ; posicionar a linha de apoio 2
  ld l,NumPosYLinhaApoio2
  call POSIT
  ld hl,LinhaApoio
  call PrintString            ; imprimir a linha de apoio 1

  ld h,NumPosXEntradas
  ld l,NumPosYEntrada1
  call POSIT                  ; posicionar para a primeira entrada

  call ENASCR             		; religo a tela
ret
