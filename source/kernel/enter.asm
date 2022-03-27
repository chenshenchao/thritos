global _start

extern main

_start:
        mov ah, 15
        mov ecx, 0xA0000
        mov ebx, 0xAFFFF
    s_15:
        mov [ecx], ah
        inc ecx
        test ecx, ebx
        jne s_15

    call main
    
    mov ah, 10
    mov ecx, 0xA0002
    mov [ecx], ah
loop:
    hlt
    jmp loop
    ; int 0x80