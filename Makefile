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

src_tests := $(wildcard tests/*_test.asm)

# TODO: use this Makefile syntax instead of shell
# all: $(src_test:.asm=) $(src_tests:.asm=.o)
all_tests := $(shell find tests -name "*_test.asm" | rev | cut -c 5- | rev)
test: $(all_tests) run_tests

tests/%_test.o : tests/%_test.asm
	nasm -f elf64 -gstabs $<

tests/%_test : tests/%_test.o
	$(LD) $(LDFLAGS) -o $@ $^

.PHONY: run_tests

run_tests:
	find tests -name '*_test' -type f -executable -exec {} \;

.PHONY: clean

clean:
	rm -rf build
