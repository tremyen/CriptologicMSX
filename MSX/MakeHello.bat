@echo off
echo ====== Apagando a ROM antiga =====
del HelloWorld.ROM
echo ======= Compilando nova ROM ======
E:\Dev\MSX\pasmo-0.5.4.beta2\pasmo HelloWorld.ASM HelloWorld.ROM
echo ============= Pronto =============