; =============================================================================
; TMS9918.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX1
; =============================================================================
VDPDATA:              equ &98
VDPCONTROL:           equ &99
; =============================================================================
; ScreenINIT - Inicializa os registradores do VDP
; =============================================================================
ScreenINIT:
	ld a,%00000000		       ; [0][0][0][0][0][0][M3][EV]
	out (VDPCONTROL),a
	ld a,128+0		           ; Controla Modo de video
	out (VDPCONTROL),a

	ld a,&C0  	              ; [16K][BLK][IE][M1][M2][0][SPR][MAG]
	out (VDPCONTROL),a
	ld a,128+1		           ; Parametros do Modo de video
	out (VDPCONTROL),a

	ld a,&01                 ; [0][0][0][0][N][N][N][N]
	out (VDPCONTROL),a       ; 0401(H)
	ld a,128+2		           ; Localiza a tabela de nomes na VRAM
	out (VDPCONTROL),a

  ld a,&08                 ; [C][C][C][C][C][C][C][C]
	out (VDPCONTROL),a       ; 0201(H)
	ld a,128+3		           ; Localiza a tabela de cores na VRAM
	out (VDPCONTROL),a

  ld a,&01                 ; [0][0][0][0][0][F][F][F]
	out (VDPCONTROL),a       ; 0801(H)
	ld a,128+4		           ; Localiza a tabela de padroes na VRAM
	out (VDPCONTROL),a

	ld a,&02                 ; [0][0][0][0][0][F][F][F]
	out (VDPCONTROL),a       ; 0101(H)
	ld a,128+5		           ; Localiza a tabela de atributos dos sprites
	out (VDPCONTROL),a

  ld a,&00                 ; [0][0][0][0][0][F][F][F]
	out (VDPCONTROL),a       ; 0000(H)
	ld a,128+6		           ; Localiza a tabela de padroes dos sprites
	out (VDPCONTROL),a

	ld a,%11110110;          ; [T][T][T][T][B][B][B][B]
	out (VDPCONTROL),a
	ld a,128+7		           ; Cor dos bits no modo texto / Cor do Backdrop
	out (VDPCONTROL),a

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
SetVDP_Write:
    rlc h                     ; formata HL
    rla
    rlc h
    rla
    srl h
    srl h                     ; formata HL
    di
      out (VDPCONTROL),a      ;
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
; =============================================================================
; In:  HL = pointer to 15-byte VDP command data
; Out: HL = updated
; =============================================================================
DoCopy:
    ld a,32
    di
      out (VDPCONTROL),a
      ld a,17 + 128
      out (VDPCONTROL),a
      ld c,VDPDATA
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
