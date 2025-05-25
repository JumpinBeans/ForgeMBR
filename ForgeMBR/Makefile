all: ForgeMBR.img

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

kernel.bin: kernel.asm
	nasm -f bin kernel.asm -o kernel.bin

ForgeMBR.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > ForgeMBR.img

run: ForgeMBR.img
	qemu-system-x86_64 -drive format=raw,file=ForgeMBR.img

clean:
	rm -f *.bin *.img
