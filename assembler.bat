ECHO OFF
cls
echo Montando o "BootLoader"
nasm -f bin bootloader.asm -o Binary/bootloader.bin
echo Montando o "Kernel"
nasm -f bin kernel.asm -o Binary/kernel.bin
pause