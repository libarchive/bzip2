# Compiling bzip2

The following build systems are available for Bzip2:

* [Meson]: This is our preferred build system for Unix-like systems.
* [CMake]: Build tool for Unix and Windows.
* nmake: Unsupported; used only for Windows and Microsoft Visual
  Studio 2013 or later.

Meson works for Unix-like OSes and Windows; nmake is only for Windows.

[Meson]: https://mesonbuild.com
[CMake]: https://cmake.org

> _Important note when compiling for Linux_:
>
> The SONAME for libbz2 for version 1.0 was: `libbz2.so.1.0`
> Some distros patched it to libbz2.so.1 to be supported by libtool.
> Others did not.
>
> We had to make a choice when switching from Makefiles -> CMake + Meson.
> So, the SONAME for libbz2 for version 1.1 is now: `libbz2.so.1`
>
> Distros that need it to be ABI compatible with the old SONAME may either:
> 1. Use CMake for the build with the option `-D USE_OLD_SONAME=ON`.
>    This will build an extra copy of the library with the old SONAME.
>
> 2. Use `patchelf --set-soname` after the build to change the SONAME and
>    install an extra symlink manually: `libbz2.so.1.0 -> libbz2.so.1.0.9`
>
> You can check the SONAME with: `objdump -p libbz2.so.1.0.9 | grep SONAME`

## Using Meson

Meson provides a [large number of built-in options](https://mesonbuild.com/Builtin-options.html)
to control compilation. A few important ones are listed below:

- -Ddefault_library=[static|shared|both], defaults to shared, if you wish to
  statically link libbz2 into the binaries set this to `static`
- --backend : defaults to ninja, use `vs` if you want to use msbuild
- --unity : This enables a unity build (sometimes called a jumbo build), makes a single build faster but rebuilds slower
- -Dbuildtype=[debug|debugoptmized|release|minsize|plain] : Controls default optimization/debug generation args,
  defaults to `debug`, use `plain` if you wish to pass your own cflags.

Meson recognizes environment variables like $CFLAGS and $CC, it is recommended
that you do not use $CFLAGS, and instead use -Dc_args and -DC_link_args, as
Meson will remember these even if you need to reconfigure from scratch (such
as when you update Meson), it will not remember $CFLAGS.

Meson will never change compilers once configured, so $CC is perfectly safe.

### Unix-like (Linux, *BSD, Cygwin, macOS)

You will need
 - Python 3.5 or newer (for Meson)
 - meson (Version 0.48 or newer)
 - ninja
 - pkg-config
 - A C compiler such as GCC or Clang

 Some linux distros package managers refer to ninja as ninja-build, fedora
 and debian/ubuntu both do this. Your OS probably provides meson, although
 it may be too old, in that case you can use python3's pip to install meson:

 ```sh
 sudo pip3 install meson
 ```
 or, for a user local install:
 ```sh
 pip3 install --user meson
 ```

 Once you have installed the dependencies, the following should work
 to use the standard Meson configuration, a `builddir` for
 compilation, and a `/usr` prefix for installation:

 ```sh
 meson --prefix /usr builddir/
 ninja -C builddir
 meson test -C builddir --print-errorlogs
 [sudo] ninja -C builddir install
 ```

You can use `meson configure builddir` to check configuration options.
Currently bzip only has one project specific option, which is to force the
generation of documentation on or off.

Ninja acepts many of the same arguments as make, although it will
automatically detect the number of CPU cores available and use an appropriate
number of threads.

### Windows

You will need to either download python 3.5 or newer and install with pip:
```cmd
py -m pip install meson
```
or you can [download pre-bundled installers of meson directly from meson's github](https://github.com/mesonbuild/meson/releases).

Either should work fine for the purposes of building bzip2

You will also need pkg-config. There are many sources of pkg-config, I
recommend installing from chocolatey because it's easy. chocolatey can also
provide ninja, though ninja is not required on windows if you want to use
msbuild.

If you want to use MSVC or a compatible compiler launch the associated
environment cmd to run meson from; the environments required to make those
compilers work is quite complex otherwise.

Once you have all of that installed you can invoke meson to configure the
build. By default meson will generate a ninja backend, if you would prefer to
use msbuild pass the backend flag `--backend=vs`. MSVC (and compatible
compilers like clang-cl and ICL) work with ninja as well.

```cmd
meson $builddir
ninja -C $builddir
meson test -C builddir --print-errorlogs
```

or:
```cmd
meson $builddir --backend=vs
cd $builddir
msbuild bzip2.sln /m
```

## Using CMake

### Build instructions for Unix & Windows (CMake)

Bzip2 can be compiled with the [CMake] build system.
You can use these commands to build Bzip2 in a certain `build` directory.

#### Basic Release build

```sh
mkdir build && cd build
cmake ..
cmake --build . --config Release
```

#### Basic Debug build

```sh
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE="Debug"
cmake --build . --config Debug
```

#### Build and install to a specific install location (prefix)

```sh
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/install ..
cmake --build . --target install --config Release
```

#### Build with example application (dlltest)

```sh
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/install .. -DENABLE_EXAMPLES=ON
cmake --build . --target install --config Release
```

#### Build and run tests

- `-V`: Verbose
- `-C`: Required for Windows builds

```sh
mkdir build && cd build
cmake ..
cmake --build . --config Release
ctest -C Release -V
```

## Using nmake on Windows

Bzip2 can be built with Microsoft Visual Studio 2013 or later. From a Visual
Studio Tools Command Prompt run:

```
nmake -f makefile.msc
```

The build will produce `bzip2.exe` and `bzip2recover.exe` files that are dependent
on `bz2-1.dll` and the Microsoft C Runtime library. Dynamic import and static
libraries are also built: `bz2-1.lib` and `bz2-static.lib`.
