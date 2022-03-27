#include "io.h"
#include "ram.h"

void main()
{
    ram_write(0x0066, 5);
    for (int i = 0x0000;i <= 0xFFFF; ++i){
        ram_write(i, 10);
    }
    while(1);
}