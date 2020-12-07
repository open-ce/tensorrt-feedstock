/* Apache-2
*/

#include <string.h>
asm (".symver old_memcpy, memcpy@GLIBC_2.2.5");       // hook old_memcpy as memcpy@2.2.5
void *old_memcpy(void *, const void *, size_t );
void *memcpy(void *dest, const void *src, size_t n)   // then export memcpy
{
    return old_memcpy(dest, src, n);
}
