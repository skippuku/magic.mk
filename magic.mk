PROFILE := $(filter-out all,$(firstword $(MAKECMDGOALS)))
ifeq (,$(PROFILE))
    ifndef MAGIC_DEFAULT_PROFILE
        $(error No profile and MAGIC_DEFAULT_PROFILE is not defined)
    endif
    PROFILE := $(MAGIC_DEFAULT_PROFILE)
    MAKECMDGOALS := $(PROFILE)
endif

ifeq ($(flavor PROFILE.$(PROFILE)), undefined)
    $(error Invalid profile: $(PROFILE))
endif

ifndef SRC
    $(info SRC is not defined.)
endif

$(eval $(PROFILE.$(PROFILE)))

.PHONY: $(MAKECMDGOALS)
$(MAKECMDGOALS): $(MAGIC_TARGET)

BUILDDIR ?= build
PROFILEDIR ?= $(PROFILE)
DEPFILE ?= $(BUILDDIR)/deps.d
OBJDIR := $(BUILDDIR)/$(PROFILEDIR)

DEPGENFLAGS ?= -MM
DEPGEN.c = $(CC) $(CFLAGS) $(DEPGENFLAGS)
DEPGEN.cpp = $(CXX) $(CXXFLAGS) $(DEPGENFLAGS)
DEPGEN.cc = $(DEPGEN.cpp)

getobj = $(addsuffix .o,$(basename $(notdir $(1))))
OBJ := $(addprefix $(OBJDIR)/,$(call getobj,$(SRC)))

define \n


endef

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(DEPFILE): $(MAKEFILE_LIST) | $(OBJDIR)
	> $(DEPFILE)
	$(foreach f,$(SRC),$(DEPGEN$(suffix $(f))) -MT '$$(OBJDIR)/$(call getobj,$(f)) $(DEPFILE)' $(f) >> $(DEPFILE)$(\n))

$(OBJ):
	$(COMPILE$(suffix $<)) $< $(OUTPUT_OPTION)

ifndef MAGIC_NODEP
    include $(DEPFILE)
endif
