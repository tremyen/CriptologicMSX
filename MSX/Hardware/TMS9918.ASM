; =============================================================================
; TMS9918.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX 1
; =============================================================================
; VDP MODO GRAFICO I (SCREEN 1)
; =============================================================================
;	Tabela de padrões 	=> 00000 ate 06143 (&H0000..&H17FF)
;	Tabela de nomes 		=> 06144 ate 06911 (&H1800..&H1AFF) => 768 bytes
; Tabela de atributos => 08192 ate 14335 (&H2000..&h37FF)
; Tabela de Sprites 	=> 14336 ate 16384 (&H3800..&H4000)
; =============================================================================
VDPDATA:              equ &98
VDPCONTROL:           equ &99
; =============================================================================
; ScreenINIT - Inicializa os registradores do VDP
; =============================================================================
ScreenINIT:
	ld a,%00000000		       	; [0][0][0][0][0][0][M3][EV]
	out (VDPCONTROL),a				; Controla Modo de video
	ld a,128+0
	out (VDPCONTROL),a

	ld a,%11000000           	; [16K][BLK][IE][M1][M2][0][SPR][MAG]
	out (VDPCONTROL),a				; Parametros do Modo de video
	ld a,128+1
	out (VDPCONTROL),a
	; ===========================================================================
	; Seta a paleta de cores
	; ===========================================================================
	; 00	0000 transparent		06	0110 dark red						12	1100 dark green
	; 01	0001 black					07	0111 cyan								13	1101 magenta
	; 02	0010 medium green		08	1000 medium red					14	1110 gray
	; 03	0011 light green 		09	1001 light red					15	1111 white
	; 04	0100 dark blue			10	1010 dark yellow
	; 05	0101 light blue			11	1011 light yellow
	; ===========================================================================
	ld a,%11010001;          	; [T][T][T][T][B][B][B][B]
	out (VDPCONTROL),a				; Cor dos bits no modo texto / Cor do Backdrop
	ld a,128+7
	out (VDPCONTROL),a
ret
; =============================================================================

; =============================================================================
; Carrega a Tabela de padroes
; =============================================================================
; Nos calculamos o endereco de memoria multiplicando o numero do tile por 8
; =============================================================================
LoadPatternTable:
	ld bc,120            		; bytes a copiar
  ld de,0                 ; tabela de padrões na VRAM
  ld hl,CriptoFont 				; localização na RAM
  call LDIRVM             ; copio a tabela de padrões
ret
; =============================================================================

; =============================================================================
; Carrega a Tabela de Atributos
; =============================================================================
LoadAttributeTable:
 	ld bc,14	              ; bytes a copiar
 	ld de,8192              ; tabela de atributos na VRAM
 	ld hl,CorLinhaApoio	    ; localização na RAM
 	call LDIRVM             ; copio a tabela de atributos
ret
; =============================================================================
; Carrega a Tabela de sprites
; =============================================================================
LoadSpritesTable:
	ld bc,1               	; bytes a copiar
  ld de,14336             ; tabela de sprites na VRAM
  ld hl,CriptoFont		    ; localização na RAM
  call LDIRVM             ; copio a tabela de sprites
ret

; =============================================================================
; Pegar a posicao de memoria de uma coordenada XY
; =============================================================================
; B	=> posicao X
; C => posicao X
; =============================================================================
; Altera => HL (endereco de memoria da coordenada xy),A
; =============================================================================
GetVDPScreenPos:
	push bc
		ld h,0
		ld l,c
		or a
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		ld a,l
		or b			; or na coordenada x
		ld l,a
		ld a,h
		or &18		; mapa de azulejos começa em &1800
		ld h,a
	pop bc
ret
; =============================================================================

; =============================================================================
; Pegar a posicao da tabela de cores da coordenada xy
; =============================================================================
; As coores pode ser setadas para uma area 8x1
; um byte define cor da frente e cor do background (&FB)
; B	=> posicao x (0-32)
; C => posicao y (0-191)
; =============================================================================
; Altera => HL (endereco de memoria da cor da coordenada xy),A
; =============================================================================
GetColorMemPos:
	push bc
		ld a,c
		and %11111000
		rrca
		rrca
		rrca
		or &20					; a tabela de cores comeca em &2000
		ld h,a
		ld a,b
		and %00011111
		rlca
		rlca
		rlca
		ld b,a
		ld a,c
		and %00000111
		or b
		ld l,a
	pop bc
ret
; =============================================================================
