; ============================================================================
; Sortear 14 numeros aleatorios entre 1 e 14 sem repeticao
; jogar o resultado para a variavel NumAleatorio (&B110)
;=============================================================================
PrintChar		equ &BB5A
NumAleatorio 		equ &B110

org &8000
	call SortearNumero
	call ConvNumChar 
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
	daa
	add A,&F0
	adc A,&40
	call PrintChar
ret