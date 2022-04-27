# magic.mk
[magic.mk](./magic.mk) is a tiny file that handles build dependencies and profiles without any meta-build system convolution.

## Manual
The following is a guide on using magic.mk which references the example [Makefile](./Makefile) included in this repository.

```mk
SRC := test/hello.c test/plusplus.c
```
`SRC` is set to a list of translation units that should be compiled. magic.mk creates rules for compiling each file in `SRC` to an object file.  

```mk
BUILDDIR := obj
MAGIC_DEFAULT_PROFILE := debug
```
`BUILDDIR` sets the directory that will be used for build files. Each profile will have its own subdirectory in here unless defined otherwise with `PROFILEDIR`. If undefined, this is set to "build".   
`MAGIC_DEFAULT_PROFILE` specifies the profile that will be used if make is called without a target argument.

```mk
define PROFILE.debug
  MAGIC_TARGET := build
  CFLAGS += -g
endef
```
Profiles are defined using PROFILE.*\[profile name\]*. The text inside a profile definition is evaluated only when that profile is targeted.    
`MAGIC_TARGET` is the actual target that will be run by make for this profile.    

```mk
define PROFILE.clean
  MAGIC_NODEP := 1
endef
```
The "clean" profile does not define `MAGIC_TARGET`. "clean" is a real target in the Makefile already, so it does not need to be forwarded.   
`MAGIC_NODEP` specifies that this profile does not care about dependencies. Otherwise, dependency information would could be wastefully generated and immediately deleted.   

```mk
define PROFILE.run
  $(PROFILE.debug)
  PROFILEDIR := debug
endef
```
Like "clean", run is a real target so the target is not forwarded.    
"run" needs the debug executables, so it inherits the "debug" profile.   
`PROFILEDIR` is explicitly set to debug, otherwise the "run" profile would be built in a new directory which would be unnecessary. 

```mk
include magic.mk
```
After the profiles are defined magic.mk can be included.    
After it has been included, the chosen profile has been evaluated, and new variables are defined.    
`OBJ` is the list of object files that correspond to `SRC`.    
`OBJDIR` is the location in which the objects will be stored.    
`PROFILE` is the name of the profile that was evaluated.    
