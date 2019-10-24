@echo off
echo ====== Apagando a ROM antiga =====
del ROM\CRIPTO.ROM
echo ======= Compilando nova ROM ======
C:\Users\mneto\Documents\pasmo-0.5.4.beta2\pasmo CRIPTO.ASM ROM\CRIPTO.ROM
echo ============= Pronto =============
