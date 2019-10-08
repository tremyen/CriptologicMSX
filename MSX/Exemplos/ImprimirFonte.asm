;==============================================================================
; Imprimir Fonte
;==============================================================================
; Manoel Neto 2019-10-08
; Imprimir as fontes em modo grafico
;==============================================================================
__VERSION:  equ 1
__RELEASE:  equ 1
include "..\Hardware\BiosMSX.asm"
include "..\Assets\Constantes.asm"
include "..\Assets\Variaveis.asm"

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
	call ScreenINIT
	; Escrever no enredeco 1600(H) tabela de padroes de sprites
	; ld a,%00010110
	; ld h,%00000000
	; ld l,%00000000
	; call SetVDP_Write
	; ld hl,Font
	; call DoCopy
LoopInfinito:
	jr LoopInfinito
ret

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "..\Hardware\AY38910.ASM"
include "..\Hardware\TMS9918.ASM"
include "..\Library\Library.asm"
include "..\Assets\Strings.asm"
include "..\Assets\Sprites.asm"
; =============================================================================
; Padding
; =============================================================================
romPad:
  ds romSize-(romPad-romArea),0
end
