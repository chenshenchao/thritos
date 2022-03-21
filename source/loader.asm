
;
    org 0x8200
    call print_load
    jmp $


;打印
print_load:
    mov ax, cs
    mov es, ax
    mov ax, message_load
    mov bp, ax; es:bp

    mov cx, 0x07
    mov ax, 0x1301
    mov bx, 0x0002
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    ret
;存储信息
message_load:
    db "load..."