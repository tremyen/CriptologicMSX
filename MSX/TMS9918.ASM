; =============================================================================
; TMS9918.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX1
; =============================================================================
VDPDATA:              equ &98
VDPCONTROL:           equ &99
FORCLR:               equ &F3E9
BAKCLR:               equ &F3EA
BDRCLR:               equ &F3EB
; =============================================================================
; Paleta do MSX
; =============================================================================
; 00	transparent
; 01	black
; 02	medium green
; 03	light green
; 04	dark blue
; 05	light blue
; 06	dark red
; 07	cyan
; 08	medium red
; 09	light red
; 10	dark yellow
; 11	light yellow
; 12	dark green
; 13	magenta
; 14	gray
; 15	white
; =============================================================================

; =============================================================================
; SetVDPReg - Seta um registrador do VDP
; =============================================================================
; Parametros: a=> Valor a ser colocado no registrador
;             d=> Registrador a ser alterado
; =============================================================================
SetVDPReg:
  di
    out (VDPCONTROL),a
    ld a,d
    add a,128
  ei
  out (VDPCONTROL),a
ret

; =============================================================================
; SetVDP_Write - Seta o contador de endereco para escrever a partir de AHL
; =============================================================================
SetVdp_Write:
    rlc h
    rla
    rlc h
    rla
    srl h
    srl h
    di
      out (VDPCONTROL),a
      ld a,14 + 128
      out (VDPCONTROL),a
      ld a,l
      nop
      out (VDPCONTROL),a
      ld a,h
      or 64
    ei
    out (VDPCONTROL),a
ret
; =============================================================================
; SetVdp_Read - Seta o contador de endereco para ler a partir de AHL
; =============================================================================
SetVdp_Read:
    rlc h
    rla
    rlc h
    rla
    srl h
    srl h
    di
      out (VDPCONTROL),a
      ld a,14 + 128
      out (VDPCONTROL),a
      ld a,l
      nop
      out (VDPCONTROL),a
      ld a,h
    ei
    out (VDPCONTROL),a
ret
; =============================================================================
; SetPalette - Seta a paleta de cores
; =============================================================================
SetPalette:
    xor a
    di
      out (VDPCONTROL),a
      ld a,16+128
    ei
    out (VDPCONTROL),a
    ld bc,#209A
    otir
ret

; =============================================================================
; Fast DoCopy, by Grauw
; In:  HL = pointer to 15-byte VDP command data
; Out: HL = updated
; =============================================================================
DoCopy:
    ld a,32
    di
      out (VDPCONTROL),a
      ld a,17 + 128
      out (VDPCONTROL),a
      ld c,#9B
VDPready:
      ld a,2
      di
        out (VDPCONTROL),a     ; select s#2
        ld a,15 + 128
        out (VDPCONTROL),a
        in a,(VDPCONTROL)
        rra
        ld a,0                 ; back to s#0, enable ints
        out (VDPCONTROL),a
        ld a,15 + 128
      ei
    out (VDPCONTROL),a          ; loop if vdp not ready (CE)
    jp c,VDPready
    outi                        ; 15x OUTI
    outi                        ; (faster than OTIR)
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
ret

; =============================================================================
; SetForeground - Muda a cor do texto - Modo de video texto
; =============================================================================
; A => nova cor (ver paleta)
; =============================================================================
; Altera => FORCLR (Variavel da BIOS)
; =============================================================================
SetForeground:
  ld (FORCLR),a
  call CHGCLR
ret

; =============================================================================
; SetBackground - Muda a cor do Fundo - Modo de video texto
; =============================================================================
; A => nova cor (ver paleta)
; =============================================================================
; Altera => BAKCLR (Variavel da BIOS)
; =============================================================================
SetBackground:
  ld (BAKCLR),a
  call CHGCLR
ret

; =============================================================================
; SetBorder - Muda a cor da Borda - Modo de video texto
; =============================================================================
; A => nova cor (ver paleta)
; =============================================================================
; Altera => BDRCLR (Variavel da BIOS)
; =============================================================================
SetBorder:
  ld (BDRCLR),a
  call CHGCLR
ret
