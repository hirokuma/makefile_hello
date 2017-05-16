OUTPUT_FILENAME := tst
OBJECT_DIRECTORY = _build
PRJ_PATH = src
OUTPUT_BINARY_DIRECTORY = .

C_SOURCE_FILES += $(PRJ_PATH)/hello.c
C_SOURCE_FILES += $(PRJ_PATH)/hello2/hello2.c
INC_PATHS += -Iinclude

##################################################################
MK      := mkdir
RM      := rm -rf
CC      := gcc
AS      := as
AR      := ar -r
LD      := ld
NM      := nm
OBJDUMP := objdump
OBJCOPY := objcopy
SIZE    := size

remduplicates = $(strip $(if $1,$(firstword $1) $(call remduplicates,$(filter-out $(firstword $1),$1))))
LISTING_DIRECTORY = $(OBJECT_DIRECTORY)
BUILD_DIRECTORIES := $(sort $(OBJECT_DIRECTORY) $(OUTPUT_BINARY_DIRECTORY) $(LISTING_DIRECTORY) )

CFLAGS += -std=c99
CFLAGS += -Wall -Werror -Wno-error=unused-function -fno-common
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += $(INC_PATHS)
LDFLAGS += -Wl,--gc-sections
C_SOURCE_FILE_NAMES = $(notdir $(C_SOURCE_FILES))
C_PATHS = $(call remduplicates, $(dir $(C_SOURCE_FILES) ) )
C_OBJECTS = $(addprefix $(OBJECT_DIRECTORY)/, $(C_SOURCE_FILE_NAMES:.c=.o) )
vpath %.c $(C_PATHS)
OBJECTS = $(C_OBJECTS) $(ASM_OBJECTS)

default: .Depend debug

debug: CFLAGS += -ggdb3 -O0
debug: LDFLAGS += -ggdb3 -O0
debug: $(BUILD_DIRECTORIES) $(OBJECTS)
	$(CC) -o $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME) $(OBJECTS)

$(BUILD_DIRECTORIES):
	$(MK) $@

$(OBJECT_DIRECTORY)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME): $(BUILD_DIRECTORIES) $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME)

clean:
	$(RM) $(OBJECT_DIRECTORY) $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME) .Depend

.Depend:
	$(foreach SRC,$(C_SOURCE_FILES),$(CC) $(CFLAGS) -MM -MT $(OBJECT_DIRECTORY)/$(notdir $(SRC:%.c=%.o)) $(SRC) >> .Depend;)

depend:
	$(RM) .Depend
	make .Depend

-include .Depend
