/* clock_gettime -- Get the current time from a POSIX clockid_t.  Unix version.
   Copyright (C) 1999-2012 Free Software Foundation, Inc.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <errno.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/time.h>

#ifndef NULL
#define NULL ((void *) 0)
#endif

/* Identifier for system-wide realtime clock.  */
# define CLOCK_REALTIME                        0

/* Macros for converting between `struct timeval' and `struct timespec'.  */
# define TIMEVAL_TO_TIMESPEC(tv, ts) {                                  \
        (ts)->tv_sec = (tv)->tv_sec;                                    \
        (ts)->tv_nsec = (tv)->tv_usec * 1000;                           \
}

void *clock_gettime(clockid_t clock_id, struct timespec *tp)
{
  int retval = -1;

  switch (clock_id)
    {
    case CLOCK_REALTIME:
      {
        struct timeval tv;
        retval = gettimeofday (&tv, NULL);
        if (retval == 0)
          TIMEVAL_TO_TIMESPEC (&tv, tp);
      }
      break;

    default:
      errno = EINVAL;
      break;
    }

  return retval;
}
