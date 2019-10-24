; =============================================================================
; TMS9918.ASM
; =============================================================================
; Manoel Neto 2019-10-04
; Biblioteca para uso do VDP do MSX 1
; =============================================================================
; VDP MODO GRAFICO I (SCREEN 1)
; =============================================================================
;	Padrões de azulejos	=> 00000 ate 06143 (&H0000..&H07FF) => 6143 Bytes
; Mapa dos ajulejos		=> 06144 ate 06911 (&H1800..&H1AFF)	=> 0767 Bytes
; Tabela de atributos => 06912 ate 07039 (&H1B00..&H1B7F)	=> 0127 Bytes
; Paleta							=> 07040 ate 07087 (&H1B80..&H1BAF)	=> 0047 Bytes
; Tabela de Cores 		=> 08192 ate 14335 (&H2000..&H37FF)	=> 6143 Bytes
; Tabela de Sprites 	=> 14336 ate 16384 (&H3800..&H3FFF) => 2048 Bytes
; =============================================================================
VDPDATA:              equ &98
VDPCONTROL:           equ &99
ADRPATTERNTBL:				equ 0000
ADRNAMESTBL:					equ 6144
ADRATRIBUTETBL:				equ 6912
ADRPALLETTBL:					equ 7040
ADRCOLORTBL:					equ 8192
ADRSPRITETBL:					equ 14336
; =============================================================================
; ScreenInit - Inicializa os registradores do VDP
; =============================================================================
ScreenInit:
	ld a,%00000000		       	; [0][0][0][0][0][0][M3][EV]
	out (VDPCONTROL),a				; Controla Modo de video
	ld a,128+0								; Registrador 0
	out (VDPCONTROL),a

	ld a,%10000000           	; [16K][BLK][IE][M1][M2][0][SPR][MAG]
	out (VDPCONTROL),a				; Parametros do Modo de video
	ld a,128+1								; Registrador 1
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
	ld a,128+7								; Registrador 7
	out (VDPCONTROL),a
ret
; =============================================================================

; =============================================================================
; Carrega a Tabela de padroes
; =============================================================================
LoadPatternTable:
	ld bc,208            		; bytes a copiar
  ld de,ADRPATTERNTBL     ; tabela de padrões na VRAM
  ld hl,CriptoFont 				; localização na RAM
  call LDIRVM             ; copio a tabela de padrões
ret
; =============================================================================

; =============================================================================
; Carrega a Tabela de sprites
; =============================================================================
LoadSpritesTable:
	ld bc,208              	; bytes a copiar
  ld de,ADRSPRITETBL	    ; tabela de sprites na VRAM
  ld hl,CriptoFont		    ; localização na RAM
  call LDIRVM             ; copio a tabela de sprites
ret
; =============================================================================

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
; um byte define cor da frente e cor do background (%FFFFBBBB)
; B	=> posicao x (0-32)
; C => posicao y (0-191)
; =============================================================================
; Altera => HL (endereco de memoria da cor da coordenada xy)
; =============================================================================
GetColorMemPos:
	push af
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
	pop af
ret
; =============================================================================
