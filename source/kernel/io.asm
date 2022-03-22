global io_hlt ;声明
; global print_test

; print_test:
;     mov ax, cs
;     mov es, ax
;     mov ax, message_test
;     mov bp, ax; es:bp

;     mov cx, 0x07
;     mov ax, 0x1301
;     mov bx, 0x0002
;     mov dh, 0x00
;     mov dl, 0x00
;     int 0x10
;     ret

; ;存储信息
; message_test:
;     db "test..."

io_hlt:
    hlt
