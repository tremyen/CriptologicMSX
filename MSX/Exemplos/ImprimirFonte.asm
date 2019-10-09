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
	call DISSCR             ; desligo a exibição da tela
	call LimparTela
	call ScreenINIT
	call ERAFNK             ; desligo as teclas de função
	ld a,32
  ld (LINL32),a           ; largura da tela em 32 colunas
	call LoadPatternTable
	; ==========================================================================
	; Carrega Tabela de nomes
	; ==========================================================================
	ld bc,14                ; bytes a copiar
  ld de,6144+7	          ; posição na tela
  ld hl,LinhaReta14	      ; padrão da string
  call LDIRVM             ; copio na VRAM
	; ==========================================================================
  call ENASCR             ; religo a tela
LoopInfinito:
	jr LoopInfinito
ret

LinhaReta14:
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

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
