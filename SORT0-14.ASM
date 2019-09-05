; ============================================================================
; Sortear 14 numeros aleatorios entre 1 e 14 
; Jogar o resultado para a variavel NumAleatorio =>(&B110)
; Converter o numero em seu codigo Hexadeciaml =>(&B111
; Imprimir o numero
; Fazer 250 lancamentos para teste dos limites 
;=============================================================================
PrintChar		equ &BB5A
NumAleatorio 		equ &B110
CharConvertido 		equ &B111

org &8000
	ld b,0
loopTeste:
	call SortearNumero
	call ConvNumChar 
	call ImprimeChar
	call ImprimeEspaco
	inc b
	ld a,b
	cp 250
	jp z,Fim
	jp loopTeste
:Fim
ret

SortearNumero:	
	ld a,r			
	ld d,0
DivPor9:
	sub 9 				
	inc d				
	jr nc, DivPor9     
	dec d			
	ld a,d
	cp 0
	jp nz,GravaAleatorio
	ld a,15
GravaAleatorio:
	ld (NumAleatorio),a
ret

ConvNumChar:
	ld a,(NumAleatorio)
	cp 0
	jp z,Zero
	cp 1
	jp z,Um
	cp 2
	jp z,Dois
	cp 3
	jp z,Tres
	cp 4
	jp z,Quatro
	cp 5
	jp z,Cinco
	cp 6
	jp z,Seis
	cp 7
	jp z,Sete
	cp 8
	jp z,Oito
	cp 9
	jp z,Nove
	cp 10
	jp z,DezA
	cp 11
	jp z,OnzeB
	cp 12
	jp z,Dozec
	cp 13
	jp z,TrezeD
	cp 14
	jp z,QuatorzeE
	cp 15
	jp z,QuinzeF
	ret
Zero:
	ld a,'0'
	ld (CharConvertido),a
ret
Um:
	ld a,'1'
	ld (CharConvertido),a

ret
Dois:
	ld a,'2'
	ld (CharConvertido),a

ret
Tres:
	ld a,'3'
	ld (CharConvertido),a

ret
Quatro:
	ld a,'4'
	ld (CharConvertido),a

ret
Cinco:
	ld a,'5'
	ld (CharConvertido),a

ret
Seis:
	ld a,'6'
	ld (CharConvertido),a

ret
Sete:
	ld a,'7'
	ld (CharConvertido),a

ret
Oito:
	ld a,'8'
	ld (CharConvertido),a

ret
Nove:
	ld a,'9'
	ld (CharConvertido),a

ret
DezA:
	ld a,'A'
	ld (CharConvertido),a

ret
OnzeB:
	ld a,'B'
	ld (CharConvertido),a

ret
Dozec:
	ld a,'C'
	ld (CharConvertido),a

ret
TrezeD:
	ld a,'D'
	ld (CharConvertido),a

ret
QuatorzeE:
	ld a,'E'
	ld (CharConvertido),a

ret
QuinzeF:
	ld a,'F'
	ld (CharConvertido),a
ret

ImprimeChar:
	ld a,(CharConvertido)
	call PrintChar
ret

ImprimeEspaco:
	ld a, ' '
	call PrintChar
ret