SOURCE=source/
TARGET=target/


vpath %.c source
vpath %.c source/kernel
vpath %.o target
vpath %.asm source
vpath %.asm source/kernel
vpath %.bin target

all: boot.bin init.bin kernel.bin
	cat $^ >> $(TARGET)mbr
target:
	mkdir $(TARGET)

$(TARGET)boot.bin: boot.asm
	nasm $^ -o $@

$(TARGET)init.bin: init.asm
	nasm $^ -o $@

$(TARGET)kernel.bin: enter.o main.o io.o ram.o
	ld $^ -Ttext 0xC000 -m elf_i386 -s -o $@

$(TARGET)enter.o: enter.asm
	nasm $^ -f elf -o $@

$(TARGET)io.o: io.asm
	nasm $^ -f elf -o $@

$(TARGET)ram.o: ram.asm
	nasm $^ -f elf -o $@

$(TARGET)main.o: main.c
	gcc -fno-builtin -m32 -c $^ -o $@

clean:
	rm -rf $(TARGET)*
