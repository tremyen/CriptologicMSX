@echo off
echo ====== Apagando a ROM antiga =====
del HelloWorld.ROM
echo ======= Compilando nova ROM ======
vasmz80_oldstyle_win32.exe HelloWorld.ASM -chklabels -nocase -o "HelloWorld.ROM"
echo ============= Pronto =============