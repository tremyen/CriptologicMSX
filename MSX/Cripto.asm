; =============================================================================
; Criptologic 1.0 para MSX
; =============================================================================
; Manoel Neto 2019-10-02
; =============================================================================
__VERSION:  equ 1
__RELEASE:  equ 0
include "Hardware\BiosMSX.asm"
include "Assets\Constantes.asm"
include "Assets\Variaveis.asm"

org romArea
	db "AB"                     ; identifica como ROM
 	dw startCode                ; endereço de execução
 	db "CW01"                   ; string de identificação
 	db __VERSION+48							; cria o identificador de versao
 	db __RELEASE+65							; cria o identificador da release
 	ds 6,0

;org &810A - Descomente para versao disquete

; =============================================================================
; INICIO PROGRAMA
; =============================================================================
startCode:
	call LimpaMem					; Limpa a memoria a cada execucao
	call TelaIntroducao		; Desenhar a tela do jogo
	call DesenharTela			; Desenhar a tela do jogo
	call PegarFrase				; Obtem a mensagem do usuario
	call Sortear					; Sortear os numeros aleatorios
	call Embaralhar				; Embaralha a frase
	call PegarChute				; Pegar os chutes do jogador 2
loopInfinito:
	ld h,NumPosXMensagens
	ld l,NumPosYMensagemFinal
	call POSIT
	ld hl,MsgUsuario8
	call PrintString
	call CHGET
	cp 13
	jp z,startCode
jp loopInfinito

include "TelaIntroducao.asm"
include "DesenharTela.asm"
include "PegarFrase.asm"
include "Sortear.asm"
include "Embaralhar.asm"
include "PegarChutes.asm"
; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "Hardware\AY38910.ASM"
include "Hardware\TMS9918.ASM"
include "Library\Library.asm"
include "Assets\Strings.asm"
include "Assets\Sprites.asm"

; =============================================================================
; Padding
; =============================================================================
romPad:
 ds romSize-(romPad-romArea),0
end
