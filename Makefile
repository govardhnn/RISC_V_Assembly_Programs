# Makefile for RISC-V Assembly Programs

# Compiler and Linker
AS := riscv64-unknown-elf-as
LD := riscv64-unknown-elf-ld

# QEMU
QEMU := qemu-system-riscv64
SPIKE_CMD := $(shell which spike)
PK_CMD := $(shell which pk)

# --- Include user configuration ---
# This file should define TARGET_DIR, TARGET_SRC, and ASFLAGS_TARGET.
# It will override the defaults below if it exists and they are defined with ':=' or '='.
# Use a hyphen to suppress errors if makefile.inc is not found.
-include makefile.inc

# --- User-defined variables (defaults if not set in makefile.inc or command line) ---
# Specify the directory and source file to build:
# Example: make TARGET_DIR=basic_examples TARGET_SRC=6_19_fibonacci.s
# Example: make TARGET_DIR=vector TARGET_SRC=vrgather_full_test.s
TARGET_DIR  ?= basic_examples # Default directory if not specified
TARGET_SRC  ?= 6_19_fibonacci.s # Default source file if not specified
ASFLAGS_TARGET ?= -march=rv64gc -g # Default ASFLAGS if not set by makefile.inc or command line

# --- Derived variables ---
SRC_PATH    := $(TARGET_DIR)/$(TARGET_SRC)
OBJ_NAME    := $(TARGET_SRC:.S=.o)
ELF_NAME    := $(TARGET_SRC:.S=.elf)
DUMP_NAME   := $(TARGET_SRC:.S=.dump)

OBJ         := $(TARGET_DIR)/$(OBJ_NAME)
ELF         := $(TARGET_DIR)/$(ELF_NAME)
DUMP_FILE   := $(TARGET_DIR)/$(DUMP_NAME)

# Assembler Flags (uses ASFLAGS_TARGET from makefile.inc or the default above)
ASFLAGS := $(ASFLAGS_TARGET)

# Linker Flags
LDFLAGS := -g -e _start

# QEMU Flags for debugging (starts GDB server)
QEMUFLAGS_DEBUG := -cpu rv64,v=true -g 1234

# QEMU Flags for direct execution (no GDB server)
QEMUFLAGS_DIRECT := -M virt,htif=off -cpu rv64,v=true -no-reboot -semihosting -bios none

.PHONY: all clean run debug_server objdump gdb

# Default target
all: $(ELF)

# Rule to assemble .S file to .o file
# This rule expects OBJ and SRC_PATH to be set correctly
$(OBJ): $(SRC_PATH)
	@mkdir -p $(TARGET_DIR)
	@echo "[AS] $(SRC_PATH) -> $(OBJ)"
	@$(AS) $(ASFLAGS) -o $(OBJ) $(SRC_PATH)

# Rule to link .o file to .elf file
# This rule expects ELF and OBJ to be set correctly
$(ELF): $(OBJ)
	@echo "[LD] $(OBJ) -> $(ELF)"
	@$(LD) $(LDFLAGS) -o $(ELF) $(OBJ)

# Target to run the elf file with QEMU and GDB server
qemu_run_gdb: $(ELF)
	@echo "[QEMU] Starting $(ELF) with GDB server on port 1234. QEMU will wait for GDB connection."
	@echo "       Use 'make gdb' in another terminal to connect."
	@$(QEMU) $(QEMUFLAGS_DEBUG) -kernel $(ELF)

# Alias for run, as per user's description
debug_server: run

# Target to run the elf file directly with QEMU (no GDB server)
qemu_run_direct: $(ELF)
	@echo "[QEMU] Running $(ELF) directly."
	@$(QEMU) $(QEMUFLAGS_DIRECT) -kernel $(ELF)

# Target to generate object dump
objdump: $(ELF)
	@echo "[OBJDUMP] Generating disassembly to $(DUMP_FILE)"
	@riscv64-unknown-elf-objdump -D $(ELF) > $(DUMP_FILE)

# Target to open GDB
qemu_open_gdb: $(ELF)
	@echo "[GDB] Starting GDB for $(ELF). Connect to QEMU GDB server using: target remote :1234"
	@riscv64-unknown-elf-gdb $(ELF)

# Target to run with Spike debugger (interactive mode)
spike_debug: $(ELF)
	@echo "[SPIKE_DEBUG] Running $(ELF) with Spike debugger (interactive mode, using pk)"
	@$(SPIKE_CMD) -d --isa=rv64gcv $(PK_CMD) $(ELF)

# Target to run with Spike directly (non-interactive mode)
spike_run_direct: $(ELF)
	@echo "[SPIKE_RUN_DIRECT] Running $(ELF) directly with Spike (using pk)"
	@$(SPIKE_CMD) --isa=rv64gcv $(PK_CMD) $(ELF)

# Target to clean generated files
clean:
	@echo "[CLEAN] Removing $(TARGET_DIR)/*.o, $(TARGET_DIR)/*.elf, $(TARGET_DIR)/*.dump for $(TARGET_SRC)"
	@rm -f $(OBJ) $(ELF) $(DUMP_FILE)
