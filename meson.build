project(
  'bzip2',
  ['c'],
  version : '1.0.7',
  meson_version : '>= 0.48.0',
  default_options : ['c_std=c89', 'warning_level=1'],
)

cc = meson.get_compiler('c')
add_project_arguments(cc.get_supported_arguments([
    '-Winline',
  ]),
  language : 'c',
)

add_project_arguments('-D_GNU_SOURCE', language : 'c')

if host_machine.system() == 'windows'
  add_project_arguments('-D_WIN32', language : 'c')
endif

c_args = []
if cc.has_function_attribute('visibility')
  c_args += '-DBZ_EXTERN=__attribute__((__visibility__("default")))'
endif

libbzip2 = library(
  'bzip2',
  ['blocksort.c', 'huffman.c', 'crctable.c', 'randtable.c', 'compress.c', 'decompress.c', 'bzlib.c'],
  c_args : c_args,
  gnu_symbol_visibility : 'hidden',
  version : meson.project_version(),
  install : true,
)

bzip2 = executable(
  'bzip2',
  ['bzip2.c'],
  link_with : [libbzip2],
  install : true,
)

executable(
  'bzip2recover',
  ['bzip2recover.c'],
  link_with : [libbzip2],
  install : true,
)

## Install wrapper scripts
install_data(
  'bzgrep', 'bzmore', 'bzdiff',
  install_dir : get_option('bindir'),
  install_mode : 'rwxr-xr-x',
)

## Generate pkg-config automaically from built library information
pkg = import('pkgconfig')
pkg.generate(
  libbzip2,
  description : 'Lossless, block-sorting data compression',
)

## install headers
install_headers('bzlib.h')

## Install man files
install_man('bzip2.1', 'bzgrep.1', 'bzdiff.1', 'bzmore.1')

# Install copies of some of the man files
man1dir = join_paths(get_option('prefix'), get_option('mandir'), 'man1')
foreach m : [['bzip2.1', ['bunzip2.1', 'bzcat']],
             ['bzgrep.1', ['bzegrep.1', 'bzfgrep.1']],
             ['bzmore.1', ['bzless.1']],
             ['bzdiff.1', ['bzcmp.1']]]
  _input = m[0]
  foreach o : m[1]
    configure_file(
      input : _input,
      output : o,
      copy : true,
      install : true,
      install_dir : man1dir,
    )
  endforeach
endforeach

# Generate manual files with xmlproc
build_docs = get_option('docs')
docs = find_program('xsltproc', required : build_docs).found()
docs = docs and find_program('perl', required : build_docs).found()
docs = docs and find_program('xmllint', required : build_docs).found()
docs = docs and find_program('egrep', required : build_docs).found()
docs = docs and find_program('pdfxmltex', required : build_docs).found()
docs = docs and find_program('pdftops', required : build_docs).found()
prog_sh = find_program('sh', required : build_docs)
if docs and prog_sh.found()
  foreach t : ['pdf', 'ps', 'html']
    custom_target(
      'manual.' + t,
      command : [prog_sh, 'xmlproc.sh', '-' + t, '@OUTPUT@'],
      output : 'manual.' + t,
    )
  endforeach
endif

# Unit tests
prog_python = import('python').find_installation('python3')
# Tuple in the form (args, input, expected)
foreach t : [['-1', 'sample1.ref', 'sample1.bz2'],
             ['-2', 'sample2.ref', 'sample2.bz2'],
             ['-3', 'sample3.ref', 'sample3.bz2']]
  test(
    t[1],
    prog_python,
    args : [files('runtest.py'), '--mode', 'compress', bzip2, t[0], files(t[1]), files(t[2])],
  )
endforeach

# Tuple in the form (args, input)
foreach t : [['-1', 'sample1.ref'],
             ['-2', 'sample2.ref'],
             ['-3', 'sample3.ref']]
  test(
    t[1],
    prog_python,
    args : [files('runtest.py'), '--mode', 'decompress', bzip2, t[0], files(t[1])],
  )
endforeach