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
; Tabela de atributos => 06912 ate 14335 (&H1B00..&h37FF)
; Tabela de Sprites 	=> 14336 ate 16384 (&H3800..&H4000)
; =============================================================================
VDPDATA:              equ &98
VDPCONTROL:           equ &99
ADRPATTERNTBL:				equ 0
ADRNAMESTBL:					equ 6144
ADRATRIBUTETBL:				equ 6912
ADRSPRITETBL:					equ 14336
; =============================================================================
; ScreenINIT - Inicializa os registradores do VDP
; =============================================================================
ScreenINIT:
	ld a,%00000000		       	; [0][0][0][0][0][0][M3][EV]
	out (VDPCONTROL),a				; Controla Modo de video
	ld a,128+0
	out (VDPCONTROL),a

	ld a,%10000000           	; [16K][BLK][IE][M1][M2][0][SPR][MAG]
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
  ld de,ADRPATTERNTBL     ; tabela de padrões na VRAM
  ld hl,CriptoFont 				; localização na RAM
  call LDIRVM             ; copio a tabela de padrões
ret
; =============================================================================

; =============================================================================
; Carrega a Tabela de sprites
; =============================================================================
LoadSpritesTable:
	ld bc,120              	; bytes a copiar
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

; =============================================================================
; Pegar a posicao do sprite na VRAM
; =============================================================================
; Achamos a posicao multiplicando o numero do sprite por 4
; Cada Sprite e definido por quatro bytes consecutivos na tabela de atributos
; (6912 = &1800)
; Endereco	Sprite 	Padrao		Conteudo
; &6912			0				XXXXXXXX	Posicao X
; &6913			0				YYYYYYYY	Posicao Y
; &6914	 		0				PPPPPPPP	Numero do azulejo na tabela de padroes
; &6915			0				E---CCCC	E=Extendido---C=Cor
; =============================================================================
;	B	 => Numero do Sprite
; =============================================================================
; Altera => A,B,HL (Endereco para carregar os atributos do sprite)
; =============================================================================
GetSpriteAdress:
	ld c,4									; Multiplicador
	ld a,b									;	Multiplicacao e feita por um loop
	cp 0										; Caso b seja zero, nao precisamos multiplicar
	jr z,PegouValorSoma 		; Vai para a soma do endereco base
	xor a										; limpa o acumulador para inicar o loop
MATHMULTAGAIN:
	add a,c									; soma o valor
	djnz MATHMULTAGAIN			; se ainda temos multiplicador continuamos no loop
PegouValorSoma:
	ld hl,6912							; Endereco base da tabela de atributos
IncrementarPonteiro:
	cp 0										; testa se temos de incrementar
	jp z,AcheiEndereco			; Se nao temos que incrementar, esse e o endereco
	inc hl									; incrementa ponteiro
	dec a										; decrementa contador
	jp IncrementarPonteiro	; vai para o proximo
AcheiEndereco:
ret

; =============================================================================
; Ligar os Sprites por Hardware
; =============================================================================
; Nenhum
; =============================================================================
; Nada
; =============================================================================
SpritesOn:
	push af
		ld a,%00001000
		out (VDPCONTROL),a
		ld a,128+8
		out (VDPCONTROL),a
	pop af
ret
