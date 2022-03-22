%include "source/conf.asm"

;
    org 0x8200
    call print_load
    mov al, 0x13; VGA 320x200x8bit
    mov ah, 0x00
    int 0x10
    mov byte [VGA_MODE], 8;
    mov word [VGA_SCRN_W], 320
    mov word [VGA_SCRN_H], 200
    mov dword [VGA_VRAM], 0x000A0000; 该模式显存映射地址[0xA0000, 0xAFFFF]

    mov ah,0x02
    int 0x16 ; 键盘 BIOS
    mov [VGA_LEDS], al
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