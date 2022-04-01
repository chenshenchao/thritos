global ram_write
global load_gdtr

ram_write: ;void ram_write(int addr, int data)
    mov ecx, [esp + 4] ; addr
    mov al, [esp + 8] ; data
    mov [ecx], al
    ; C 调用 TODO 看看是否回收
    ret

load_gdtr: ; load_gdtr(int limit, int addr)
    mov ax, [esp + 4]
    mov [esp + 6], ax
    lgdt [esp + 6]
    ret