@echo off
echo ====== Apagando a ROM antiga =====
del CRIPTOLO.ROM
echo ======= Compilando nova ROM ======
C:\Users\mneto\Documents\pasmo-0.5.4.beta2\pasmo CRIPTOLO.ASM CRIPTOLO.ROM
echo ============= Pronto =============