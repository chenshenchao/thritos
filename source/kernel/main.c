#include "io.h"
#include "ram.h"

void main()
{
    ram_write(0xA0066, 5);
    for (int i = 0xA0000;i <= 0xAFFFF; ++i){
        ram_write(i, 6);
    }
    while(1);
}