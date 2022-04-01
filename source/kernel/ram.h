#ifndef KERNEL_RAM_H
#define KERNEL_RAM_H

void load_gdtr(int limit, int addr);

void ram_write(int addr, int data);

#endif
