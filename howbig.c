
#include <stdio.h>
#include <assert.h>
#include "bzlib.h"

unsigned char ibuff[1000000];
unsigned char obuff[1000000];

void doone ( int n )
{
   int i, j, k, q, nobuff;
   q = 0;

   for (k = 0; k < 1; k++) {
      for (i = 0; i < n; i++)
         ibuff[i] = ((unsigned long)(random())) & 0xff;
      nobuff = 1000000;
      j = bzBuffToBuffCompress ( obuff, &nobuff, ibuff, n, 9,0,0 );
      assert (j == BZ_OK);
      if (nobuff > q) q = nobuff;
   }
   printf ( "%d %d(%d)\n", n, q, (int)((float)n * 1.01 - (float)q) );
}

int main ( int argc, char** argv )
{
   int i;
   i = 0;
   while (1) {
     if (i >= 900000) break;
     doone(i);
     if (   (int)(1.10 * i) > i )
        i = (int)(1.10 * i); else i++;
   }

   return 0;
}