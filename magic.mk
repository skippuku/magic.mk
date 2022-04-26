BUILDDIR ?= build/debug
DEPFILE ?= $(BUILDDIR)/deps.d
DEPGENFLAGS ?= -MM

ifeq ($(flavor SRC),undefined)
    $(error SRC must be defined)
else
    getobjpath = $(addprefix $(BUILDDIR)/,$(addsuffix .o,$(basename $(notdir $(1)))))
    OBJ = $(call getobjpath,$(SRC))
endif

define \n


endef

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

SRC_C := $(filter %.c,$(SRC))
SRC_CXX := $(filter %.cpp,$(SRC))

$(DEPFILE): $(MAKEFILE_LIST) | $(BUILDDIR)
	> $(DEPFILE)
	$(foreach f,$(SRC_C),$(CC) $(CFLAGS) $(DEPGENFLAGS) -MT '$(call getobjpath,$(f)) $(DEPFILE)' $(f) >> $(DEPFILE)$(\n))
	$(foreach f,$(SRC_CXX),$(CC) $(CXXFLAGS) $(DEPGENFLAGS) -MT '$(call getobjpath,$(f)) $(DEPFILE)' $(f) >> $(DEPFILE)$(\n))

$(OBJ):
	$(COMPILE$(suffix $<)) $< $(OUTPUT_OPTION)

clean:
	$(RM) $(DEPFILE) $(OBJ)

ifneq ($(MAKECMDGOALS),clean)
    include $(DEPFILE)
endif
