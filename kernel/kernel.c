#include "stdint.h"

#define VGAMEM (char*)0xb8000
#define VGAMEM_COLUMN 80
#define VGAMEM_ROW 25

void kclear() {
    char *video = (char*)0xb8000;
    int16_t cells;
    for (cells = VGAMEM_COLUMN * VGAMEM_ROW; cells > 0; cells--)
    {
        video[0] = '\0';
        video[1] = 0x00;
        video+=2;
    }
    return;
}

void kputs(const char *s) {
    char *video = (char*)0xb8000;
    int index = 0;
    while (s[index]) {
        video[0] = s[index];
        video[1] = 0x0f;
        index++;
        video+=2;
    }
    return;
}

extern void kmain() {
    kclear();
    kputs("Hello, World from Blahaj Os!");
    return;
}
