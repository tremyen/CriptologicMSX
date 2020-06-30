@echo off
echo ====== Apagando a ROM antiga =====
del DSK\CRIPTDSK.BIN
echo ======= Compilando nova ROM ======
pasmo --msx CRIPTDSK.ASM DSK\CRIPTDSK.BIN
echo ============= Pronto =============
