ASM=nasm
LD=ld

all: teeworlds_asmr

build/teeworlds_asmr.o: teeworlds_asmr.asm
	mkdir -p build
	$(ASM) -f elf64 teeworlds_asmr.asm -o build/teeworlds_asmr.o

teeworlds_asmr: build/teeworlds_asmr.o
	$(LD) -o teeworlds_asmr build/teeworlds_asmr.o

.PHONY: clean

clean:
	rm -rf build
