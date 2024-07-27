ASM=nasm
LD=ld
LDFLAGS=-s

all: teeworlds_asmr

debug: LDFLAGS=
debug: all

build/teeworlds_asmr.o: $(shell find -name "*.asm")
	mkdir -p build
	$(ASM) -f elf64 src/teeworlds_asmr.asm -o build/teeworlds_asmr.o

teeworlds_asmr: build/teeworlds_asmr.o
	$(LD) $(LDFLAGS) -o teeworlds_asmr build/teeworlds_asmr.o

.PHONY: clean

clean:
	rm -rf build
