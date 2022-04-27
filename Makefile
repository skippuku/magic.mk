SRC = test/hello.c test/plusplus.cpp

.DEFAULT_GOAL := all
.PHONY: all
ifdef PROFILE
ifeq ($(PROFILE),debug)
    CFLAGS := -g
else ifeq ($(PROFILE),release)
    CFLAGS := -O2
    LDFLAGS := -s
else
    $(error Invalid profile: $(PROFILE))
endif
CXXFLAGS := $(CFLAGS) -std=c++11
CFLAGS += -std=gnu99

include magic.mk

EXEDIR := $(OBJDIR)
EXE := $(addprefix $(EXEDIR)/,$(basename $(notdir $(SRC))))

all: $(EXE)
	@echo "$(PROFILE) build is complete."

$(EXE): %: %.o
	$(CC) $^ $(LDFLAGS) -o $@
else # PROFILE
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
	rm -rf `find build/ -name "*.[od]"`

$(MAKECMDGOALS):
	@$(MAKE) PROFILE=$(MAKECMDGOALS) --no-print-directory
endif # PROFILE
