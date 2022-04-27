ifndef SRC
    $(error SRC must be defined.)
endif

OBJDIR := build/$(PROFILE)
DEPFILE ?= build/deps.d
DEPGENFLAGS ?= -MM

getobjpath = $(addprefix $(OBJDIR)/,$(addsuffix .o,$(basename $(notdir $(1)))))
OBJ = $(call getobjpath,$(SRC))

define \n


endef

$(OBJDIR):
	mkdir -p $(OBJDIR)

DEPGEN.c = $(CC) $(CFLAGS) $(DEPGENFLAGS)
DEPGEN.cpp = $(CXX) $(CXXFLAGS) $(DEPGENFLAGS)
DEPGEN.cc = $(DEPGEN.cpp)

$(DEPFILE): $(MAKEFILE_LIST) | $(OBJDIR)
	> $(DEPFILE)
	$(foreach f,$(SRC),$(DEPGEN$(suffix $(f))) -MT '$(call getobjpath,$(f)) $(DEPFILE)' $(f) >> $(DEPFILE)$(\n))

$(OBJ):
	$(COMPILE$(suffix $<)) $< $(OUTPUT_OPTION)

clean:
	$(RM) $(DEPFILE) $(OBJ)

ifneq ($(MAKECMDGOALS),clean)
    include $(DEPFILE)
endif
