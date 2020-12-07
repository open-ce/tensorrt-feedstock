/* Apache 2.0
*/


#include <sys/types.h>
asm (".symver old_clock_gettime, __vdso_clock_gettime@GLIBC_PRIVATE");
void *old_clock_gettime(clockid_t clockid, void *tp);
void *clock_gettime(clockid_t clockid, void *tp)
{
    return old_clock_gettime(clockid, tp);
}
