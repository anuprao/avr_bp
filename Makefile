# Author: Anup Jayapal Rao
# Copyright: 2025
# License: MIT License
# 
# $ export PATH=/mnt/workspace/sdks/gnuavr/bin/:$PATH
#
# $ make or make-j4
#

# Use following colours for syntax
# 
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
#
# No Color     0
#

BLACK=\033[0;30m
RED=\033[0;31m
GREEN=\033[0;32m
ORANGE=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHT_GRAY=\033[0;37m

DARKGRAY=\033[1;31m
LIGHT_RED=\033[1;31m
LIGHT_GREEN=\033[1;32m
YELLOW=\033[1;33m
LIGHT_BLUE=\033[1;34m
LIGHT_PURPLE=\033[1;35m
LIGHT_CYAN=\033[1;36m
WHITE=\033[1;37m

NC=\033[0m 

######## Build options ########

verbose = 0

######## Source folder setup ########

SRCROOT = .

######## Build setup ########

OUTPUT_DIR = build

OUTPUT_NAME = $(OUTPUT_DIR)/demo

OUTPUT_BIN = $(OUTPUT_NAME).bin

OUTPUT_ELF = $(OUTPUT_NAME).elf

OUTPUT_MAP = $(OUTPUT_NAME).map

OUTPUT_DUMP = $(OUTPUT_NAME).dump

# .o directory
OBJDIR = obj

####### GENERIC

CSRCDIR = src

ASMDIR = asm

CC      = avr-gcc
CXX     = avr-g++
LD      = avr-gcc
AR      = avr-ar
AS      = avr-as
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size

#######
		
DEVICE     = attiny2313

CLOCK      = 8000000

#######

CHIP_SPECIFIC_FLAGS = -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

COMMON_FLAGS = $(CHIP_SPECIFIC_FLAGS) 

ASFLAGS = $(COMMON_FLAGS) -x assembler-with-cpp 

# -Og or -Os
CFLAGS = -g -Os $(COMMON_FLAGS) -Wall 

CFLAGS += -I./inc -I./inc/hw

LDSCRIPT = 

#  
LDFLAGS = -g -Os $(COMMON_FLAGS)  -Wl,-Map,"$(OUTPUT_MAP)"

LD_LIBS = 
#LD_LIBS = -lgcc

OBJCOPY_FLAGS = -O binary

SZ_FLAGS = --format=berkeley

#######

ASMSRCS = $(wildcard $(ASMDIR)/*.s)

CSRCS =	$(wildcard $(CSRCDIR)/*.c)

C_OBJS = $(patsubst $(CSRCDIR)/%,$(OBJDIR)/$(CSRCDIR)/%,$(CSRCS:.c=.o))   
#C_OBJS = $(CSRCS:.c=.o) 

ASM_OBJS = $(patsubst $(ASMDIR)/%,$(OBJDIR)/$(ASMDIR)/%,$(ASMSRCS:.s=.ao)) 
#ASM_OBJS = $(ASMSRCS:.s=.ao)

#######

%.bin: %.elf
# If verbose, print
ifeq ($(verbose),1)
	$(OBJCOPY) $< $(OBJCOPY_FLAGS) $@
	$(SIZE) $(SZ_FLAGS) $(OUTPUT_ELF)
	$(OBJDUMP) -d $(OUTPUT_ELF) > $(OUTPUT_DUMP)
# else, hide
else
	@$(OBJCOPY) $< $(OBJCOPY_FLAGS) $@
	@$(SIZE) $(SZ_FLAGS) $(OUTPUT_ELF)
	@$(OBJDUMP) -d $(OUTPUT_ELF) > $(OUTPUT_DUMP)
endif
	
$(OUTPUT_ELF): $(C_OBJS) $(ASM_OBJS) $(LDSCRIPT)
# If verbose, print
ifeq ($(verbose),1)
	$(LD) $(LDFLAGS) -o $@ $(C_OBJS) $(ASM_OBJS) $(LD_LIBS)
# else, hide
else
	@$(LD) $(LDFLAGS) -o $@ $(C_OBJS) $(ASM_OBJS) $(LD_LIBS)
endif

$(OBJDIR)/%.o: %.c
	@mkdir -p $(@D)
	@printf "${LIGHT_GREEN}>>${NC}ARM C >> Compiling : ${LIGHT_BLUE}$<${NC}\n"
# If verbose, print
ifeq ($(verbose),1)
	$(CC) $(CFLAGS) -c $< -o $@
# else, hide
else
	@$(CC) $(CFLAGS) -c $< -o $@
endif

$(OBJDIR)/%.ao: %.s
	@mkdir -p $(@D)
	@printf "${LIGHT_GREEN}>>${NC}ARM ASM >> Assembling : ${LIGHT_BLUE}$<${NC}\n"
# If verbose, print
ifeq ($(verbose),1)
	#$(AS) $(ASFLAGS) $< -o $@
	$(CC) $(CFLAGS) -x assembler-with-cpp  -c $< -o $@
# else, hide
else
	#@$(AS) $(ASFLAGS) $< -o $@
	@$(CC) $(CFLAGS) -x assembler-with-cpp  -c $< -o $@
endif

#######

.DEFAULT_GOAL := all

#######

.PHONY : all 

all: $(OUTPUT_BIN) 
	@echo "----------------------------------------------------------------------------------------------------"
	@printf "${GREEN}BUILD COMPLETE: ${LIGHT_BLUE}$^${NC}\n"
	@echo 

#######

.PHONY: clean

clean:
	@rm -f $(OUTPUT_BIN)
	@rm -f $(OUTPUT_ELF)
	@rm -f $(OUTPUT_MAP)
	@rm -f $(C_OBJS)
	@rm -f $(ASM_OBJS)
	@echo "----------------------------------------------------------------------------------------------------"
	@printf "${LIGHT_GREEN}CLEAN COMPLETE${NC}\n"
	@echo 

#######

debug_prints:
	@printf "${LIGHT_RED}$(OUTPUT_BIN)${NC}\n"
	@echo "--------------------------------------"	
	@echo 


