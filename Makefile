SRC = test/hello.c test/plusplus.cpp

.PHONY: all
ifdef PROFILE
BUILDDIR := build/$(PROFILE)
ifeq ($(PROFILE),debug)
    CFLAGS := -g
    EXE_PREFIX := $(BUILDDIR)/db_
else ifeq ($(PROFILE),release)
    CFLAGS := -O2
    LDFLAGS := -s
    EXE_PREFIX := $(BUILDDIR)/r_
else
    $(error Invalid profile: $(PROFILE))
endif
CXXFLAGS := $(CFLAGS) -std=c++11
CFLAGS += -std=gnu99

EXE := $(addprefix $(EXE_PREFIX),$(basename $(notdir $(SRC))))

all: $(EXE)
	$(info $(PROFILE) build is complete.)

include magic.mk

$(EXE): $(EXE_PREFIX)%: $(BUILDDIR)/%.o
	$(CC) $^ $(LDFLAGS) -o $@
else
    ifeq ($(MAKECMDGOALS),clean)
    MAKECMDGOALS :=
    TARGET := clean
    else
        ifeq (,$(filter-out all,$(MAKECMDGOALS)))
            MAKECMDGOALS := debug
        endif
        TARGET := $(MAKECMDGOALS)
    endif
.PHONY: $(TARGET)
all: $(TARGET)

clean:
	rm -rf build/**/*.o build/**/*.d

$(MAKECMDGOALS):
	@$(MAKE) PROFILE=$(MAKECMDGOALS) --no-print-directory
endif
