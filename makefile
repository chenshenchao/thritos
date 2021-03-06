SOURCE=source/
TARGET=target/


vpath %.c source
vpath %.c source/kernel
vpath %.o target
vpath %.asm source
vpath %.asm source/kernel
vpath %.bin target

all: boot.bin loader.bin kernel.bin
	cat $^ >> $(TARGET)mbr
target:
	mkdir $(TARGET)

$(TARGET)boot.bin: boot.asm
	nasm $^ -o $@

$(TARGET)loader.bin: loader.asm
	nasm $^ -o $@

$(TARGET)kernel.bin: main.o io.o
	ld $^ -Ttext 0x30400 -m elf_i386 -s -o $@

$(TARGET)io.o: io.asm
	nasm $^ -f elf -o $@

$(TARGET)main.o: main.c
	gcc -fno-builtin -m32 -c $^ -o $@

clean:
	rm -rf $(TARGET)*
