ASSEMBLY_FILES := $(wildcard *.s)
TARGETS := $(ASSEMBLY_FILES:.s=)

# Make file to assemble RISC-V assembly language program(s) in myprog folder
#   ... relocate instruction to start at 0xBFC00000
#   ... output hex file ready to be read into instruction memory

all: $(TARGETS)

clean:
	@rm -f *.hex *.asm *.out *.bin

%: %.s
	@riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o $@.out $<
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o $@.out.reloc $@.out
	@riscv64-unknown-elf-objcopy -O binary -j .text $@.out.reloc $@.bin
	@riscv64-unknown-elf-objdump -D -S -l -F -Mno-aliases $@.out.reloc > $@.asm
	@set -euo pipefail
	@od -v -An -t x1 $@.bin | tr -s '\n' | awk '{$$1=$$1};1' > $@.hex
	@rm $@.out
	@rm $@.out.reloc
	@rm $@.bin
