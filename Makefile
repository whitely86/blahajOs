BUILD_DIR:=build

.PHONY: all
all: floppy kernel bootloader always

floppy: $(BUILD_DIR)/blahajos.img
$(BUILD_DIR)/blahajos.img: kernel bootloader | always
	truncate -s 1440K $@ # create an empty image of 1440k
	dd if=$(BUILD_DIR)/stage1.bin of=$@ bs=512 count=1 seek=0 conv=notrunc # load the stage1 at the very first sector of the image
	dd if=$(BUILD_DIR)/stage2.bin of=$@ bs=512 count=2 seek=1 conv=notrunc # load the stage2 at the second and third sector
	dd if=$(BUILD_DIR)/kernel.bin of=$@ bs=512 seek=3 conv=notrunc

bootloader: $(BUILD_DIR)/stage1.bin $(BUILD_DIR)/stage2.bin
$(BUILD_DIR)/stage1.bin: bootloader/mbr.asm | always
	nasm -f bin -o $@ $< -I ./bootloader

$(BUILD_DIR)/stage2.bin: bootloader/stage2.asm | always
	nasm -f bin -o $@ $< -I ./bootloader

kernel: $(BUILD_DIR)/kernel.bin
$(BUILD_DIR)/kernel.bin: kernel/kernel.c kernel/kernel_entry.asm | always
	nasm -f elf kernel/kernel_entry.asm -o $(BUILD_DIR)/kernel_entry.o
	i386-elf-gcc -ffreestanding -m32 -g -c kernel/kernel.c -o $(BUILD_DIR)/kernel.o -I ./includes
	i386-elf-ld -o $@ -Ttext 0x1000 $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o --oformat binary
always:
	mkdir -p $(BUILD_DIR)