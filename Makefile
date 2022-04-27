SRC := test/hello.c test/plusplus.cpp

BUILDDIR := obj
MAGIC_DEFAULT_PROFILE := debug

define PROFILE.debug
  MAGIC_TARGET := build
  CFLAGS += -g
  EXE_PREFIX := db_
endef

define PROFILE.release
  MAGIC_TARGET := build
  CFLAGS += -O2
  LDFLAGS += -s
  EXE_PREFIX := r_
endef

define PROFILE.profile
  MAGIC_TARGET := build
  CFLAGS += -O2 -g
  EXE_PREFIX := p_
endef

define PROFILE.clean
  MAGIC_NODEP := 1
endef

define PROFILE.run
  $(PROFILE.debug)
  PROFILEDIR := debug
endef

include magic.mk

CXXFLAGS := $(CFLAGS) -std=c++11
CFLAGS += -std=gnu99

EXEDIR := .
EXE := $(addprefix $(EXEDIR)/$(EXE_PREFIX),$(basename $(notdir $(SRC))))

.PHONY: build clean

build: $(EXE)
	@echo "$(PROFILE) build complete."

run: $(EXE)
	$(foreach @,$(EXE),./$@ $(ARGS) $(\n))

$(EXE): $(EXEDIR)/$(EXE_PREFIX)%: $(OBJDIR)/%.o
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	rm -f `find $(BUILDDIR)/ -name "*.[od]"`
