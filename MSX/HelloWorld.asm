PrintChar equ &00A2

org &4000
db "AB"
dw Main
db 00,00,00,00,00

Main:
  call &006f
  ld a,32
  ld (&F3B0),a          ; Variavel de sistema LineLenght (LINELEN)
  ld hl, Message
  call PrintString
  DI
  Halt

NewLine:
  push af
    ld a,13
    call PrintChar
    ld a,10
    call PrintChar
  pop af
ret

PrintString:
  ld a,(hl)
  cp 13
  ret z
  inc hl
  call PrintChar
jr PrintString

Message:
  db "Ola Mundo Cartucho!",13

org &C000 ; PAD para 32K
