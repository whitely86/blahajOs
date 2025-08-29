# 🦈 Blåhaj OS
A *very* simple operating system.

## 📦 What is Blåhaj OS?

Blåhaj OS is a minimalist operating system project built from scratch.  
It currently consists of:

- A **bootloader** (in x86 Assembly)
- A **basic kernel** (in C)

---

## 🚀 How to Build & Run

### 🔧 Requirements

- `nasm` – for assembling the bootloader
- `i386-elf-gcc` – cross-compiler for the kernel
- `qemu` – to run it in a virtual machine

### 🛠 Build

```bash
make
````

### ▶️ Run

```bash
./run.sh
```
---

## 📁 Project Structure

```
/
├── bootloader/       # Bootloader code (written in assembly)
├── kernel/           # Very basic kernel (C + some asm)
├── includes/         # Includes files
├── tables/           # Tables files (ex: gdt, idt)
├── LICENSE           # License file
├── Makefile          # Build instructions
├── README.md         # This file
└── run.sh            # Containing running commands
```

---

## ❓ What Does It Do?

* Displays `"Hello, World from Blahaj Os!"` on the screen.

---

## 🧠 Why?

To learn:

* x86 assembly
* How bootloaders work
* Protected mode & basic kernel setup

---

## 📌 Notes

* This is not a real OS — it's a learning project.
* It doesn't support multitasking, filesystems, or hardware drivers (yet).

---

## 🦈 Inspiration

Named after the mighty IKEA **Blåhaj** shark.
Simple, reliable, and soft — just like this OS (hopefully).

---