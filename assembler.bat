ECHO OFF
cls
echo Montando o "BootLoader"
nasm -f bin bootloader.asm -o FilesOS/iso/boot/bootloader.bin
echo Montando o "Kernel"
nasm -f bin kernel.asm -o FilesOS/iso/boot/kernel.bin
pause