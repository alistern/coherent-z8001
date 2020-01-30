# Tools
CC = /home/alistern/Project/z8kgcc/opt/z8kgcc-jan-19-2009/bin/z8k-coff-gcc
AR = /home/alistern/Project/z8k-coff/z8k-coff/bin/ar
AS = /home/alistern/Project/z8k-coff/z8k-coff/bin/as
NM = /home/alistern/Project/z8k-coff/z8k-coff/bin/nm
LD = /home/alistern/Project/z8k-coff/z8k-coff/bin/ld
OBJDUMP = /home/alistern/Project/z8k-coff/z8k-coff/bin/objdump
STRIP = /home/alistern/Project/z8k-coff/z8k-coff/bin/strip

# Paths
LIBPATH =  -L/opt/z8kgcc-jan-19-2009/z8k-coff/lib -L/opt/z8kgcc-jan-19-2009/lib/gcc-lib/z8k-coff/2.9-ecosSWtools-990319-m20z8k-3/std

#Flags
ASFLAGS = -al=${*}.lst

# set .data segment to 0 for split I and D 

LDFLAGS = -mz8002 -T z8002.x -Tdata 0x0000 -M=coherent.map -x --no-define-common --cref --no-check-sections --print-gc-sections
LDFLAGS_1 = -g -mz8001 -T z8001.x -M=coherent.map -x --no-define-common --cref --no-check-sections --print-gc-sections

CPPFLAGS = -nostdinc -I../include
# DO NOT use -O3 it bloats .data and .bss
# -mstd pass args on stack. Bigger code but may be need for compatibility

#CFLAGS = -ffreestanding -fno-builtin -fhosted -mz8002 -O2 -mstd

# Try with passing args in registers and using builtins
CFLAGS = -mz8002 -O2
CFLAGS_1 = -g -ffreestanding -fno-builtin -fhosted -mz8001 -O2 -mstd

# Segment start
#DATASTART =  --section-start=.data=0x0000
#USTART= --section-start=u=0xc000
#BSSSTART =  -Wl,"--section-start=.bss=0x6bf8"
#STACK = --section-start=.stack=0xc000
#PDPIO = --section-start=pdpio=0xf000

HDRS =

#wd.o tty.o

OBJS = mch0.o al.o commodore.o md.o io.o ddt.o alloc.o bio.o ct.o clock.o main.o misc.o null.o printf.o proc.o seg.o \
	sig.o sys1.o sys2.o sys3.o timeout.o clist.o exec.o fd.o fs1.o fs2.o fs3.o \
	pipe.o  canon.o var.o stub.o copyright.o

all: makefile clean unix

#all: testclean test

test: test.o mch0.o
	${LD} -o coherent ${LDFLAGS} mch0.o test.o

coherent:   ${OBJS}
	${LD} -o coherent ${LDFLAGS}  ${LIBPATH} ${OBJS} ${DATASTART} ${STACK} -lgcc -lg -lc
	${LD} -o coherent.bin --oformat=binary ${LDFLAGS} ${LIBPATH} ${OBJS} ${DATASTART} ${STACK}-lgcc -lg -lc
	${NM} -n coherent >coherent.nm
	${OBJDUMP} -d coherent >coherent.dis

testclean:
	rm -f test.o mch0.o coherent
clean:
	rm -f coherent ${OBJS}
        
