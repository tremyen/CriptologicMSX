; =============================================================================
; DesenharTela.asm
; =============================================================================
; Manoel Neto 2019-10-03
; =============================================================================
; inicializar a tela em modo 32x24
; Trocar a cor para roxo
; Desenhar uma linha na posicao (9,11)
; Desenhar uma linha na posicao (9,13)
; posicionar o cursor na posicao (9,10)
; =============================================================================
DesenharTela:
  call INIT32
  call LimparTela

  ld h,NumPosXCabecalho       ; posicionar o cabecalho
  ld l,NumPosYCabecalho
  call POSIT
  ld hl,MsgUsuario1           ; imprimir o cabecalho
  call PrintString

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

  ld h,NumPosXEntradas        ; posicionar para a primeira entrada
  ld l,NumPosYEntrada1
  call POSIT
ret
