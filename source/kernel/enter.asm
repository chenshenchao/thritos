global _start

; extern main

_start:
    ; call main
    
    ; mov ebx, 0
    ; mov eax, 1
    ; int 0x80
    ; mov ecx, 0xA0000
    ; mov al, 15
    ; mov [ecx], al
loop:
    hlt
    jmp loop
    ; int 0x80