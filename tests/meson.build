prog_python = import('python').find_installation('python3')

# Tuple in the form (args, input, expected)
foreach t : [['-1', 'sample1.ref', 'sample1.bz2'],
             ['-2', 'sample2.ref', 'sample2.bz2'],
             ['-3', 'sample3.ref', 'sample3.bz2']]
  test(
    t[1] + ' (compress)',
    prog_python,
    args : [files('runtest.py'), '--mode', 'compress', bzip2, t[0], files(t[1]), files(t[2])],
  )
endforeach

# Tuple in the form (args, input)
foreach t : [['-1', 'sample1.ref'],
             ['-2', 'sample2.ref'],
             ['-3', 'sample3.ref']]
  test(
    t[1] + ' (decompress)',
    prog_python,
    args : [files('runtest.py'), '--mode', 'decompress', bzip2, t[0], files(t[1])],
  )
endforeach