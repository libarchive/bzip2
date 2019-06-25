project(
  'bzip2',
  ['c'],
  version : '1.0.7',
  meson_version : '>= 0.48.0',
  default_options : ['c_std=c89', 'warning_level=1'],
)

conf_data = configuration_data()
conf_data.set('BZ_VERSION', meson.project_version())
configure_file(
  input: 'bz_version.h.in',
  output: 'bz_version.h',
  configuration: conf_data
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
# The or is a workaround for https://github.com/mesonbuild/meson/issues/5530
if cc.has_function_attribute('visibility') or (cc.get_id() == 'clang' and host_machine.system() == 'darwin')
  c_args += '-DBZ_EXTERN=__attribute__((__visibility__("default")))'
endif

bz_sources = ['blocksort.c', 'huffman.c', 'crctable.c', 'randtable.c', 'compress.c', 'decompress.c', 'bzlib.c']

## Library versioning
##
## New package version:
##   revision += 1
##
## New interfaces:
##   current += 1
##   revision = 0
##   age += 1
##
## Deleted/changed interfaces:
##   current += 1
##   revision = 0
##   age = 0
##
## KEEP THESE IN SYNC WITH CMakeLists.txt OR STUFF WILL BREAK!
bz2_lt_current  = 1
bz2_lt_revision = 7
bz2_lt_age      = 0

bz2_soversion   = bz2_lt_current - bz2_lt_age
bz2_lt_version  = '@0@.@1@.@2@'.format(bz2_soversion, bz2_lt_age, bz2_lt_revision)

if ['msvc', 'clang-cl', 'intel-cl'].contains(cc.get_id())
  libbzip2 = library(
    'bz2',
    bz_sources,
    c_args : c_args,
    vs_module_defs : 'libbz2.def',
    version : bz2_lt_version,
    soversion : bz2_soversion,
    install : true,
  )
else
  libbzip2 = library(
    'bz2',
    bz_sources,
    c_args : c_args,
    gnu_symbol_visibility : 'hidden',
    version : bz2_lt_version,
    soversion : bz2_soversion,
    install : true,
  )
endif

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

subdir('man')
subdir('docs')
subdir('tests')
