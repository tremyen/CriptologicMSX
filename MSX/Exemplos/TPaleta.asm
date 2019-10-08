; =============================================================================
; Teste de alteracao de paleta
; =============================================================================
; Manoel Neto 2019-10-02
; =============================================================================
__VERSION:  equ 1
__RELEASE:  equ 1
include "BiosMSX.asm"
include "Constantes.asm"
include "Variaveis.asm"

org romArea
	db "AB"                     ; identifica como ROM
  dw startCode                ; endereço de execução
  db "CW01"                   ; string de identificação
  db __VERSION+48							; cria o identificador de versao
  db __RELEASE+65							; cria o identificador da release
  ds 6,0
; =============================================================================
; INICIO PROGRAMA
; =============================================================================
startCode:
  call INIT32
  call LimparTela
  LD a,5                  ; Azul leve
  LD (BAKCLR),a           ; Fundo
  LD (BDRCLR),a           ; Borda
  LD a,1                  ; Azul leve  
  ld (FORCLR),a
  CALL CHGCLR             ; Troca cor
  ld hl,MsgUsuario1
  call PrintString
loopInfinito:
  jp loopInfinito

include "AY38910.ASM"
include "TMS9918.ASM"
; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "Library.asm"
include "Strings.asm"
; =============================================================================
; Padding
; =============================================================================
romPad:
  ds romSize-(romPad-romArea),0
end
