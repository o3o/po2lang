NAME = po2lang
PROJECT_VERSION = 0.1.0

ROOT_SOURCE_DIR = src
SRC = $(getSources)
TARGET = "exe"
SRC_TEST = $(filter-out $(ROOT_SOURCE_DIR)/app.d, $(SRC))
SRC_TEST += $(wildcard tests/*.d)

# Compiler flag
# -----------
ifeq ($(TARGET), "lib")
	DCFLAGS += -lib
	DCFLAGS_REL += -lib
endif

DCFLAGS += $(DBG_CODE) #compile in debug code
DCFLAGS += $(OPTIMIZE) #optimize
DCFLAGS += -g # add symbolic debug info
DCFLAGS += $(WARN_AS_ERR) # warnings as errors (compilation will halt)
DCFLAGS += $(WARN_AS_MSG) # warnings as messages (compilation will continue)

# release flags
DCFLAGS_REL += -O -wi -release -inline -boundscheck=off

DCFLAGS_TEST += -unittest
# DCFLAGS_TEST += -main -quiet

# Linker flag
# -----------
# DCFLAGS_LINK += 
# DCFLAGS_LINK += $(LINKERFLAG)-L/usr/lib/

# Version flag
# -----------
#VERSION_FLAG += -version=StdLoggerDisableLogging
#VERSION_FLAG += -version=use_gtk

# Packages
# -----------
PKG = $(wildcard $(BIN)/$(NAME))
PKG_SRC = $(PKG) $(SRC) makefile

# -----------
# Libraries
# -----------

# -----------
# Test  library
# -----------

# unit-threaded
# -----------
LIB_TEST += $(D_DIR)/unit-threaded/libunit-threaded.a
DCFLAGS_IMPORT_TEST += -I$(D_DIR)/unit-threaded/source

# dmocks-revived
# -----------
LIB_TEST += $(D_DIR)/DMocks-revived/libdmocks-revived.a
DCFLAGS_IMPORT_TEST += -I$(D_DIR)/DMocks-revived

LIB_TEST += $(LIB)
DCFLAGS_IMPORT_TEST += $(DCFLAGS_IMPORT)

include common.mk
