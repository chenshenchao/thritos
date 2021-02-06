void io_hlt();

void main()
{
loop:
    io_hlt();
    goto loop;
}