; =============================================================================
; AY38910.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do chip de som AY38910
; =============================================================================
; Amplitude	        => Volume
; Envelope	        => Mudanças de Volume em dado tempo
; Mixer	            => Liga e desliga os canais de som
; Noise	            => Sons com distorcao
; Tone	            => Tom emitido
; Acumulador        => NVPPPPP
;                   P=pitch ,V = Loud volume, and N is the noise bit
; =============================================================================
; REGISTRADORES
; =============================================================================
; 00	Tone Pitch L - Channel A	LLLLLLLL Lower value = Higher pitch
; 01	Tone Pitch H - Channel A	----HHHH Lower value = Higher pitch
; 02	Tone Pitch L - Channel B	LLLLLLLL Lower value = Higher pitch
; 03	Tone Pitch H - Channel B	----HHHH Lower value = Higher pitch
; 04	Tone Pitch L - Channel C	LLLLLLLL Lower value = Higher pitch
; 05	Tone Pitch H - Channel C	----HHHH Lower value = Higher pitch
; 06	Noise Generator	          ---NNNNN Higher = Faster noise
; 07	Mixer 	       --NNNTTT N=Noise T=Tone (Channel CBACBA 1=mute 0=normal)
; 08	Amplitude - Channel A	---EVVVV	E=Envelope (1=Enabled) VVVV=Volume
; 09	Amplitude - Channel B	---EVVVV	E=Envelope (1=Enabled) VVVV=Volume
; 10	Amplitude - Channel C	---EVVVV	E=Envelope (1=Enabled) VVVV=Volume
; 11	Envelope L (Volume over time) 	LLLLLLLL	Lower=Faster Envelope
; 12	Envelope H (Volume over time) 	HHHHHHHH	Lower=Faster Envelope
; 13	Envelope Selection	----EEEH	E=Envelope number E (See PDF) H=Hold
; =============================================================================

; =============================================================================
; Mute
; =============================================================================
; Parametros => Nenhum
; =============================================================================
; Altera => Nada
; =============================================================================
Mute:
  push af
    push bc
      ld a,7
      ld c,%11111111           ; --NNNTTT (1=off) --CBACBA
      call SetRegister
    pop bc
  pop af
ret
; =============================================================================
; Setar um registrador
; =============================================================================
; A => Registrador no AY38910 que sera atualizado
; C => Dados a serem enviados ao registrador
; =============================================================================
; Altera => Nada
; =============================================================================
SetRegister:
  push bc
    out (&A0),a         ; carregar a porta de selecao de registrador
  pop bc
  ld a,c
  out (&A1),a           ; manda o novo valor para o porta de dados
ret

; =============================================================================
; SndCorreto
; =============================================================================
; Altera => Nada
; =============================================================================
SndCorreto:
  ; ===========================================================================
  ; Tone - Channel A
  ; ===========================================================================
  ld a,0
  ld c,%11111111            ;TTTTTTTT Tone Lower 8 bits	- Channel A
  call SetRegister
  ld a,1		                ;----TTTT Tone Upper 4 bits
  ld c,%00000001
  call SetRegister
  ; ===========================================================================
  ; Tone - Channel B
  ; ===========================================================================
  ; ld a,2
  ; ld c,%10000000          ;TTTTTTTT Tone Lower 8 bits	- Channel B
  ; call SetRegister
  ; ld a,3
  ; ld c,%00000011          ;----TTTT Tone Upper 4 bits
  ; call SetRegister
  ; ===========================================================================
  ; Tone - Channel C
  ; ===========================================================================
  ; ld a,4
  ; ld c,128                ;TTTTTTTT Tone Lower 8 bits	- Channel C
  ; call SetRegister
  ; ld a,5	                ;--TTTT Tone Upper 4 bits
  ; ld c,%00000011
  ; call SetRegister
  ; ===========================================================================
  ; Noise Channel B
  ; ===========================================================================
	ld a,6
	ld c,%00001111           ; NNNNN
	call SetRegister
  ; ===========================================================================
  ; Mixer
  ; ===========================================================================
	ld a,7
	ld c,%00111110           ; --NNNTTT (1=off) --CBACBA
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel A
  ; ===========================================================================
	ld a,8
	ld c,%00001111           ; ---EVVVV E=1 means envelope on
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel B
  ; ===========================================================================
	ld a,9
	ld c,%00001111           ; ---EVVVV
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel C
  ; ===========================================================================
	ld a,10
	ld c,%00011111           ; ---EVVVV
	call SetRegister
  ; ===========================================================================
  ; Envelope Generator Control Fine
  ; ===========================================================================
	;	ld a,11
  ;	ld c,100
  ;	call SetRegister
  ; ===========================================================================
  ; Envelope Generator Control Coarse
  ; ===========================================================================
  ;	ld a,12
  ;	ld c,0
  ;	call SetRegister
  ; ===========================================================================
  ; Envelope
  ; ===========================================================================
  ;	ld a,13
  ;	ld c,%00001110
  ;	call SetRegister
ret

; =============================================================================
; SndCorreto
; =============================================================================
; Altera => Nada
; =============================================================================
SndErrado:
  ; ===========================================================================
  ; Tone - Channel A
  ; ===========================================================================
  ld a,0
  ld c,%11111111            ;TTTTTTTT Tone Lower 8 bits	- Channel A
  call SetRegister
  ld a,1		                ;----TTTT Tone Upper 4 bits
  ld c,%11111111
  call SetRegister
  ; ===========================================================================
  ; Tone - Channel B
  ; ===========================================================================
  ; ld a,2
  ; ld c,%10000000          ;TTTTTTTT Tone Lower 8 bits	- Channel B
  ; call SetRegister
  ; ld a,3
  ; ld c,%00000011          ;----TTTT Tone Upper 4 bits
  ; call SetRegister
  ; ===========================================================================
  ; Tone - Channel C
  ; ===========================================================================
  ; ld a,4
  ; ld c,128                ;TTTTTTTT Tone Lower 8 bits	- Channel C
  ; call SetRegister
  ; ld a,5	                ;--TTTT Tone Upper 4 bits
  ; ld c,%00000011
  ; call SetRegister
  ; ===========================================================================
  ; Noise Channel B
  ; ===========================================================================
	;ld a,6
	;ld c,%00001111           ; NNNNN
	;call SetRegister
  ; ===========================================================================
  ; Mixer
  ; ===========================================================================
	ld a,7
	ld c,%00111110           ; --NNNTTT (1=off) --CBACBA
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel A
  ; ===========================================================================
	ld a,8
	ld c,%00001111           ; ---EVVVV E=1 means envelope on
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel B
  ; ===========================================================================
	ld a,9
	ld c,%00001111           ; ---EVVVV
	call SetRegister
  ; ===========================================================================
  ; 4-bit Volume / 2-bit Envelope Select for channel C
  ; ===========================================================================
	ld a,10
	ld c,%00011111           ; ---EVVVV
	call SetRegister
  ; ===========================================================================
  ; Envelope Generator Control Fine
  ; ===========================================================================
	;	ld a,11
  ;	ld c,100
  ;	call SetRegister
  ; ===========================================================================
  ; Envelope Generator Control Coarse
  ; ===========================================================================
  ;	ld a,12
  ;	ld c,0
  ;	call SetRegister
  ; ===========================================================================
  ; Envelope
  ; ===========================================================================
  ;	ld a,13
  ;	ld c,%00001110
  ;	call SetRegister
ret
