global _start

extern main

_start:
        xor ecx, ecx
        mov ax, ds
        and ax, 0b111
        or ax, 0x0020 ; 4 << 3 + 0
        mov ds, ax

        mov ah, 15
        mov ecx, 0x0000
        mov ebx, 0xFFFF
    s_15:
        mov [ecx], ah
        inc ecx
        test ecx, ebx
        jne s_15

    sti

    call main
    
    mov ah, 10
    mov ecx, 0xA0002
    mov [ecx], ah
loop:
    hlt
    jmp loop
    ; int 0x80