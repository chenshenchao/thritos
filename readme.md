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
