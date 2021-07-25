project(
  'bzip2',
  ['c'],
  version : '1.1.0',
  meson_version : '>= 0.50.0',
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
    # Please keep this list in sync with CMakeLists.txt
    '-Wall',
    '-Wextra',
    '-Wmissing-prototypes',
    '-Wstrict-prototypes',
    '-Wmissing-declarations',
    '-Wpointer-arith',
    '-Wdeclaration-after-statement',
    '-Wformat-security',
    '-Wwrite-strings',
    '-Wshadow',
    '-Winline',
    '-Wnested-externs',
    '-Wfloat-equal',
    '-Wundef',
    '-Wendif-labels',
    '-Wempty-body',
    '-Wcast-align',
    '-Wclobbered',
    '-Wvla',
    '-Wpragmas',
    '-Wunreachable-code',
    '-Waddress',
    '-Wattributes',
    '-Wdiv-by-zero',
    '-Wshorten-64-to-32',
    '-Wconversion',
    '-Wextended-offsetof',
    '-Wformat-nonliteral',
    '-Wlanguage-extension-token',
    '-Wmissing-field-initializers',
    '-Wmissing-noreturn',
    '-Wmissing-variable-declarations',
    # '-Wpadded',                         # Not used because we cannot change public structs
    '-Wsign-conversion',
    # '-Wswitch-enum',                    # Not used because this basically disallows default case
    '-Wunreachable-code-break',
    '-Wunused-macros',
    '-Wunused-parameter',
    '-Wredundant-decls',
    '-Wheader-guard',
    '-Wno-format-nonliteral',             # This is required because we pass format string as "const char*.
  ]),
  language : 'c',
)

add_project_arguments('-D_GNU_SOURCE', language : 'c')

os_defines = []
if host_machine.system() == 'windows'
  os_defines += '-DBZ_LCCWIN32=1'
  os_defines += '-DBZ_UNIX=0'
else
  os_defines += '-DBZ_LCCWIN32=0'
  os_defines += '-DBZ_UNIX=1'
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
bz2_lt_revision = 9
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
  c_args : os_defines,
)

executable(
  'bzip2recover',
  ['bzip2recover.c'],
  link_with : [libbzip2],
  install : true,
  c_args : os_defines,
)

## Install wrapper scripts
install_data(
  'bzgrep', 'bzmore', 'bzdiff',
  install_dir : get_option('bindir'),
  install_mode : 'rwxr-xr-x',
)

## Create aliases. Use links if possible, but copies if not.
# Copies are mainly meant for windows, which doesn't have symlinks.
bindir = get_option('bindir')
targets = [['bzmore', 'bzless'], ['bzdiff', 'bzcmp'], ['bzgrep', 'bzegrep', 'bzfgrep'],
           ['bzip2', 'bunzip2', 'bzcat']]
extra_args = []
if host_machine.system() != 'windows' and build_machine.system() != 'windows'
  extra_args = '--use-links'
endif
foreach t : targets
  meson.add_install_script('install_links.py', get_option('bindir'), t, extra_args)
endforeach

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
