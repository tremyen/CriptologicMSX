; =============================================================================
; PegarFrase.asm
; =============================================================================
; Manoel Neto 2019-09-25
; Pegar uma frase de no minimo 2 caracteres e no maximo 14 caracteres
; Receber a mensagem na area de memoria frase => (PegarMensagem)
; Validar o numero de caracteres durante a digitacao => (ValidaDuasLetras)
; Guardar o tamanho da frase digitada => (TamanhoFrase)
; Imprimir a mensagem vindo da memoria para teste => (ImprimirMensagem)
; =============================================================================
__VERSION:  equ 1
__RELEASE:  equ 1
include "Bios.asm"
include "Variaveis.asm"

org romArea
	db "AB"                     ; identifica como ROM
  dw startCode                ; endereço de execução
  db "CW01"                   ; string de identificação
  db __VERSION+48
  db __RELEASE+65
  ds 6,0

; =============================================================================
; INICIO PROGRAMA
; =============================================================================
startCode:
	call LimpaMem					; Limpa a memoria a cada execucao
	call PegarFrase				; Obtem a mensagem do usuario
	call Sortear					; Sortear os numeros aleatorios
	call Embaralhar				; Embaralha a frase
	call PegarChute				; Pegar os chutes do jogador 2
loopInfinito:
	jp loopInfinito
ret

include "PegarFrase.asm"
include "Sortear.asm"
include "EmbFrase.asm"
include "PegarChutes.asm"
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
