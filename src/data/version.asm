; teeworlds-asmr version info

TEEWORLDS_ASMR_VERSIONSTR db "teeworlds-asmr v0.0.1", 0

%ifdef __NASM_VER__
NASM_VERSIONSTR db "nasm: ", __NASM_VER__, 0
%else
NASM_VERSIONSTR db "nasm: (not nasm)", 0
%endif

%ifdef __DATE__ and __TIME__
BUILD_DATE db "built on ", __DATE__, " ", __TIME__, 0
%else
BUILD_DATE db "built date unknown", 0
%endif

%ifdef GIT_HASH
GIT_HASH_STR db GIT_HASH, 0
%else
GIT_HASH_STR db "(git hash unknown)", 0
%endif
