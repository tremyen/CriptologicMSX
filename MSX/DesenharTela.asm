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
  ld h,NumPosXMensagens
  ld l,2
  call POSIT
  ld hl,MsgUsuario12
  call PrintString
  ld h,NumPosXLinhaApoio
  ld l,NumPosYLinhaApoio1
  call POSIT
  ld hl,LinhaApoio
  call PrintString
  ld h,NumPosXLinhaApoio
  ld l,NumPosYLinhaApoio2
  call POSIT
  ld hl,LinhaApoio
  call PrintString
  ld h,NumPosXEntradas
  ld l,NumPosYEntrada1
  call POSIT
ret
