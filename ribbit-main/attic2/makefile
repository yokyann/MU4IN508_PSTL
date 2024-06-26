# Sector Scheme Makefile
#
# On MacOS, the makefile builds using gcc installed
# by brew.

UNAME = $(shell uname)

ifeq ($(UNAME), Darwin)
LD=/usr/local/Cellar/x86_64-elf-binutils/2.36.1/bin/x86_64-elf-ld
GCC=/usr/local/Cellar/x86_64-elf-gcc/11.1.0/bin/x86_64-elf-gcc
AS=/usr/local/Cellar/x86_64-elf-binutils/2.36.1/bin/x86_64-elf-as
OBJC=/usr/local/Cellar/x86_64-elf-binutils/2.36.1/bin/x86_64-elf-objcopy
NASM=nasm
else
LD=ld
GCC=gcc
AS=as
OBJC=objcopy
NASM=nasm
endif

GCC_DEFS += -DPC
CFLAGS += -g -Os -fno-stack-protector -Wall -fomit-frame-pointer -ffreestanding -nostdlib -nostdinc -fno-pie -m16 -fno-asynchronous-unwind-tables
AS_FLAGS += --32
LDFLAGS += --strip-all --discard-all -static

ifeq ($(UNAME), Darwin)
else
LDFLAGS += -no-pie
endif

clean:
	rm -rf *.bin *.o *.elf *.elf.stripped *.in lib.scm.py lib.scm.js

vm.js.in: ./vm_js/generic-vm.js makefile
	sed \
	  -e 's|.*/\*debug\*/.*||g' \
	  -e 's|.*/\*nodezzz\*/.*||g' \
	  -e 's|domdoc|A|g' \
	  -e 's|dombody|B|g' \
	  -e 's|selstart|C|g' \
	  -e 's|txtarea|D|g' \
	  -e 's|putchar|E|g' \
	  -e 's|getchar|F|g' \
	  -e 's|pos|G|g' \
	  -e 's|get_byte|H|g' \
	  -e 's|FALSE|I|g' \
	  -e 's|TRUE|J|g' \
	  -e 's|NIL|K|g' \
	  -e 's|boolean|L|g' \
	  -e 's|is_clump|M|g' \
	  -e 's|stack|N|g' \
	  -e 's|push|O|g' \
	  -e 's|pop|P|g' \
	  -e 's|prim1|Q|g' \
	  -e 's|prim2|R|g' \
	  -e 's|prim3|S|g' \
	  -e 's|primitives|T|g' \
	  -e 's|get_byte|U|g' \
	  -e 's|get_code|V|g' \
	  -e 's|get_int|W|g' \
	  -e 's|list_tail|X|g' \
	  -e 's|run|Z|g' \
	  -e 's|symbol_table|q|g' \
	  -e 's|symbol_ref|r|g' \
	  -e 's|accum|s|g' \
	  -e 's|is_num|t|g' \
	  -e 's|get_opnd|u|g' \
	  -e 's|get_cont|v|g' \
	  -e 's|set_global|w|g' \
	  -e 's|input|y|g' \
	  -e 's|pc|z|g' \
	  ./vm_js/generic-vm.js > ./vm.js.in

vm.py.in: ./vm_py/generic-vm.py makefile
	sed \
	  -e 's|.*#debug#.*||g' \
	  -e 's|#.*||g' \
	  -e 's|putchar|E|g' \
	  -e 's|getchar|F|g' \
	  -e 's|pos|G|g' \
	  -e 's|get_byte|H|g' \
	  -e 's|FALSE|I|g' \
	  -e 's|TRUE|J|g' \
	  -e 's|NIL|K|g' \
	  -e 's|boolean|L|g' \
	  -e 's|is_clump|M|g' \
	  -e 's|stack|N|g' \
	  -e 's|push|O|g' \
	  -e 's|pop|P|g' \
	  -e 's|prim1|Q|g' \
	  -e 's|prim2|R|g' \
	  -e 's|prim3|S|g' \
	  -e 's|primitives|T|g' \
	  -e 's|get_byte|U|g' \
	  -e 's|get_code|V|g' \
	  -e 's|get_int|W|g' \
	  -e 's|list_tail|X|g' \
	  -e 's|run|Z|g' \
	  -e 's|symbol_table|q|g' \
	  -e 's|symbol_ref|r|g' \
	  -e 's|accum|s|g' \
	  -e 's|is_num|t|g' \
	  -e 's|get_opnd|u|g' \
	  -e 's|get_cont|v|g' \
	  -e 's|set_global|w|g' \
	  -e 's|input|y|g' \
	  -e 's|pc|z|g' \
	  ./vm_py/generic-vm.py > vm.py.in

lib.scm.min.js: vm.js.in lib.scm ssc.scm makefile
	gsi ./ssc.scm --target js lib.scm
	npx google-closure-compiler --language_in=ECMASCRIPT_2020 --language_out=ECMASCRIPT_2020 --js lib.scm.js --js_output_file lib.scm.min.js
	sed -i -e s"|'use strict';input=|y=|" lib.scm.min.js
	wc lib.scm.min.js

lib.scm.min.py: vm.py.in lib.scm ssc.scm makefile
	gsi ./ssc.scm --target py lib.scm
	sed -i -e s"|input = |y=|" lib.scm.py
	pyminify lib.scm.py > lib.scm.min.py
	wc lib.scm.min.py
