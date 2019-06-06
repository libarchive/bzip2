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

subdir('man')
subdir('tests')