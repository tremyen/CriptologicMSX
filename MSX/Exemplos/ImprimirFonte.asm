;==============================================================================
; Imprimir Fonte
;==============================================================================
; Manoel Neto 2019-10-08
; Imprimir as fontes em modo grafico
;==============================================================================
__VERSION:  equ 1
__RELEASE:  equ 1
include "..\Hardware\BiosMSX.asm"
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
org &8000

startCode:
    xor a
    ld hl,#8000       ;  to 1st byte of page 1...
    call SetVDP_Write
    ld a,#88          ; use color 8 (red)
FillL1:
    ld c,8            ; fill 1st 8 lines of page 1
FillL2:
  ld b,128
  out (VDPDATA),a     ; could also have been done with
  djnz FillL2         ; a vdp command (probably faster)
  dec c               ; (and could also use a fast loop)
  jp nz,FillL1
  ld hl,COPYBLOCK     ; execute the copy
  call DoCopy
ret

COPYBLOCK:
    db 0,0,0,1
    db 0,0,0,0
    db 8,0,8,0
    db 0,0,#D0

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "..\Hardware\AY38910.ASM"
include "..\Hardware\TMS9918.ASM"
include "..\Library\Library.asm"
include "Strings.asm"
; =============================================================================
; Padding
; =============================================================================
romPad:
  ds romSize-(romPad-romArea),0
end
