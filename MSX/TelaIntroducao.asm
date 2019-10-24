; =============================================================================
; Tela Introdutoria do jogo
; =============================================================================
; Manoel Neto 2019-10-24
; =============================================================================
TelaIntroducao:
  call LimparTela             ; limpo a tela
  call ScreenInit             ; inicializo a tela
  ld a,15
  ld (FORCLR),a               ; seto a cor da fonte
  ld a,1
  ld (BAKCLR),a               ; seto a cor do background
  ld a,1
  ld (BDRCLR),a               ; seto a cor da borda
  call CHGCLR                 ; uso a bios para alterar as cores
  call ERAFNK             		; desligo as teclas de função
  ld a,32                     ; preparo a largura da tela
  ld (LINL32),a           		; largura da tela em 32 colunas
  call LoadPatternTable       ; CARREGO A TABELA DE PADROES
  call LoadSpritesTable				; CARREGO A TABELA DE SPRITES

  ; ==========================================================================
  ; Carrega Tabela de nomes para escrever as fontes
  ; ==========================================================================
  ld b,NumPosXTituloJogo
  ld c,NumPosYTituloJogo
  call GetVDPScreenPos
  ld d,h
  ld e,l
  ld bc,11                		; bytes a copiar
  ld hl,TituloPattern      		; padrão da string
  call LDIRVM             		; copio na VRAM
  ; ==========================================================================

LoopEfeitoCor:
  ; Mudar cor do titulo do jogo
  ld b,NumPosXTituloJogo      ; posicionar a linha de apoio 1 x
  ld c,NumPosYTituloJogo      ; posicionar a linha de apoio 1 y
  call GetColorMemPos	        ; pegar a area de memoria da tabela de cores
  ld d,h                      ; posição na tela
  ld e,l                      ; posição na tela
  ld bc,4	                		; bytes a copiar
  ld hl,CorAmarelo     				; tabela de nomes
  call LDIRVM             		; copio na VRAM
  dec a
  cp 0
  jr z,FimEfeitoCor
  jr LoopEfeitoCor
FimEfeitoCor:
LoopAguardarEnter:
  call CHGET
  cp 13
  jr z,FimTelaIntro
  jr LoopAguardarEnter
FimTelaIntro:
ret
