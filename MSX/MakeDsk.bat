@echo off
echo ====== Apagando a ROM antiga =====
del DSK\CRIPTO.DAT
echo ======= Compilando nova ROM ======
C:\Users\mneto\Documents\pasmo-0.5.4.beta2\pasmo -msx CRIPTO.ASM DSK\CRIPTO.DAT
echo ============= Pronto =============
