@rem
@rem OS/2 test driver for bzip2
@rem
type words1
.\bzip2 -1 < sample1.ref > sample1.rbz
.\bzip2 -2 < sample2.ref > sample2.rbz
.\bzip2 -dvv < sample1.bz2 > sample1.tst
.\bzip2 -dvv < sample2.bz2 > sample2.tst
type words3sh