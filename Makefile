SRC := test/hello.c test/plusplus.cpp

MAGIC_DEFAULT_PROFILE := debug

define PROFILE.debug
  MAGIC_TARGET := all
  CFLAGS += -g
endef

define PROFILE.release
  MAGIC_TARGET := all
  CFLAGS += -O2
  LDFLAGS += -s
endef

define PROFILE.clean
  MAGIC_NODEP := 1
endef

define PROFILE.run
  PROFILE := debug
  MAGIC_TARGET :=
endef

include magic.mk

CXXFLAGS := $(CFLAGS) -std=c++11
CFLAGS += -std=gnu99

EXEDIR = $(OBJDIR)
EXE := $(OBJ:%.o=%)

.PHONY: all clean

all: $(EXE)
	@echo "$(PROFILE) build complete."

run: $(EXE)
	$(foreach @,$(EXE),./$@ $(ARGS) $(\n))

$(EXE): %: %.o
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	rm -f `find build/ -name "*.[od]"`
