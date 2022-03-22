# [ThritOS]

```sh
make
```

```sh
# 简略指定
qemu-system-i386 -hdd target/mbr

# -hdd 替换详细指定
qemu-system-i386 -drive file=target/mbr,format=raw,index=0,media=disk

# 如果找不到 bios-256k.bin 用 -L 附带该文件路径，通常在 qemu 目录下。
qemu-system-i386 -drive file=target/mbr,format=raw,index=0,media=disk -L E:\qemu
```

## 内存特殊地址

大部分 0x30000 以上的地址

- 0x7COO 启动
- 0xB8000 显示
- 0x09FC00 0X09FFFF
