#include "io.h"
#include "ram.h"

void main()
{
    // for (int i = 0xA0000;i <= 0xAFFFF; ++i){
    //     ram_write(i, 15);
    // }
loop:
    io_hlt();
    goto loop;
}