global ram_write

ram_write: ;void ram_write(int addr, int data)
    mov ecx, [esp + 4] ; addr
    mov al, [esp + 8] ; data
    mov [ecx], al
    ret

