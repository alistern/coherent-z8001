/* .ts=4
 * Disassembly of Commodore coherent using DDT from CPM-8000. DDT doesn't cope with
 * segmented code so there are lots of manual fixups in here. I may have missed some.
 * I have modified the syntax to be compatible with gas.
 *
 * TODO check .global some of them may not need to be.
 */


	SS = 0x3f00
	CS = 0x3000
	DS = 0x3100

.z8002
	.text

	.global _start, _u, _clock, _iprocp, _commodore
	.global _trap

_start:

	.global cmdblk_, psa, psavi, sattr, slen, start, lpclk
	.global tepa, tprv, tnmi, tnvi, tseg, tsys, vint

cmdblk_:	/* 3000:0000 : cmdblk_         : 0010 */
	ldar	r2,start-2
	jp	@r2



	.ds	0x300-3
psa:		/* 3000:0600 : psa             : 0000 */
	ldar	r2,start-2						/* take advantage of unused space to insert a jump */
	jp	@r2									/* to start */
	.word 0x0000
	/* the active part of the PSA */
	.word 0x0000, 0xc000, CS, tepa		/* unimplemented	tepa */
	.word 0x0000, 0xc000, CS, tprv		/* priv 			tprv */
	.word 0x0000, 0xc000, CS, tsys		/* system call 		tsys */
	.word 0x0000, 0xc000, CS, tseg 		/* segment trap		tseg */
	.word 0x0000, 0xc000, CS, tnmi		/* nmi				tnmi */
	.word 0x0000, 0xc000, CS, tnvi		/* nvi				tnvi */
	.word 0x0000, 0xc000					/* common to vi          */

psavi:		/* 3000:063c : psavi           : 0000 */

	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint,
	.word CS, vint, CS, vint, CS, vint, CS, vint


MMU_ATTRIB_RD	= 0x01
MMU_ATTRIB_SYS	= 0x02
MMU_ATTRIB_CPUI	= 0x04
MMU_ATTRIB_EXC	= 0x08
MMU_ATTRIB_DMAI	= 0x10
MMU_ATTRIB_DIRW	= 0x20
MMU_ATTRIB_CHG	= 0x40
MMU_ATTRIB_REF	= 0x80

sattr:		/* 3000:083c : sattr           : 0000 */
	.byte MMU_ATTRIB_SYS	/* Code seg 0x30 */
	.byte MMU_ATTRIB_SYS	/* Data seg 0x31 */
	.byte MMU_ATTRIB_SYS	/* 0x32 */
	.byte MMU_ATTRIB_SYS	/* 0x33 */
 	.byte MMU_ATTRIB_CPUI	/* DMA segment 0x34 */
 	.byte MMU_ATTRIB_CPUI	/* DMA segment 0x35 */
 	.byte MMU_ATTRIB_CPUI	/* DMA segment 0x36 */
 	.byte MMU_ATTRIB_CPUI	/* DMA segment 0x37 */
 	.byte MMU_ATTRIB_CPUI	/* DMA segment 0x38 */
	.byte MMU_ATTRIB_SYS	/* 0x39 */
	.byte 00
	.byte 00
	.byte MMU_ATTRIB_SYS	/* 0x3c */
	.byte MMU_ATTRIB_SYS	/* 0x3d ES used in interrupts */
	.byte MMU_ATTRIB_SYS	/* 0x3e OS used in interrupts */
	.byte MMU_ATTRIB_SYS	/* Stack seg 0x3f */

slen:		/* 3000:084c : slen            : 0000 */
	.byte 0xff	/* Data seg 0x31, size = (255 * 256) + 255 = 0xffff*/
	.byte 0xff
	.byte 0xff
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0x07	/* Stack seg 0x3f, size = (7 * 256) + 255 = 0x7ff */
	.byte 0x00

start:		/* 3000:085c : start           : 0000 */
	ldl	rr14, #0x3f000800	/* set system stack */

	sub	r0,r0
	ldctl	nspoff,r0		/* set user stack */
	ldctl	nspseg,r0

	/* Copy the first entry ( _vret) to the rest of the table */

	ldl	rr2, #DS|_vecs		/* vector array */
	ldl	rr4,rr2
	inc	r5,#4				/* rr4 = _vecs+4 */
	ld	r0,#0x00fe			/* count */
	ldir	@r4,@r2,r0		/*copy data  */

	ldar	r0,argv			/* overwrite 1st vec with argv */
	ldl	_vecs,rr0

	ldar	r0,psa
	ldctl	psapseg,r0
	ldctl	psapoff,r1

	/* setup segment attributes 0x30 to 0x3f*/
	ldar	r2,sattr
	ldl	rr0, #0x00300010	/* r0l = 0x30, r1l = 0x10 */
	soutb	#0x01fc,rl0		/* segment address register */
	ld	r4,#0x0efc			/* Attribute field */
	sotirb	@r4,@r2,r1

	/* setup size of segments 0x31 to 0x3f*/
	ldar	r2,slen
	ldl	rr0, #0x0031000f	/* rl0 = 31, rl1 = 0x0f
	soutb	#0x01fc,rl0		/* segment address register */
	ld	r4,#0x0dfc			/* limit field */
	sotirb	@r4,@r2,r1

	/* commodore specific stuff, initiaises coretop, corebot etc */
	call	_commodore

	/* setup the low end of the system stack segment */
	ld	r0,_corebot
	add	r0,r0
	add	r0,r0
	ld	r1,#0x3f3f			/* stack segment */
	soutb	#0x01fc,rh1		/* segment address register */
	soutb	#0x08fc,rh0		/* segment base high  = 0x3f */
	soutb	#0x08fc,rl0		/* segment base low = _corebot*4 */

	/* start the clock */

	call	lpclk
	ei	nvi,vi

	/* enter C land */
	call	_main

	/* on the way out, transfer back to ROM ??? */
	di	nvi,vi
	inc	_depth,#1

	/* set normal stack pointer */
	ld	r0,#0xfff0
	ldctl	nspoff,r0
	ldk	r0,#0
	ldctl	nspseg,r0
	ldps	l08fe
l08fe:
	.word 0x0000
	.word 0x9000	/* FCW SEG|NORMAL|VIE ???? */
	.word 0x0303	/* segment */
	.word 0x0000	/* offset */


	.global _romconf

lpclk:		/* 3000:0906 : lpclk           : 0000 */
	ldk		r0,#1
	outb	#0x0001,rl0
	outb	#0x0081,rl0
	outb	#0x0001,rh0
	outb	#0x0081,rh0

	outb	#PBSIOC,rh0
	outb	#PBDPP,rh0
	outb	#PBDD,rh0
	outb	#PBDATA,rh0

	outb	#PCDPP,rh0
	ldk		r0,#7
	outb	#PCDD,rl0
	outb	#PCSIOC,rh0
	ld		r0,#0x0070
	outb	PCDATA,rl0
	ld		r0,#0x0080
	ld		r1,#0x4e20
	test	_romconf+0x0e
	jp		z,l0956

	ld		r1,#0x7530
l0956:
	outb	#CT3MS,rl0
	sub		r2,r2
	outb	#CTIV,rl2
	outb	#CT3CH,rh1
	outb	#CT3CL,rl1
	ld		r2,#0x0020
	outb	#CT3CS,rl2
	ld		r2,#0x00c6
	outb	#CT3CS,rl2

	ldb		rl0,#8,#0
	outb	#MICR,rl0
	ldb		rl0,#9,#0
	outb	#MCCR,rl0

	ldb		rl0,#0,#6
	outb	#CT3CS,rl0

	ldk		r0,#2
	ldk		r1,#4
	outb	#0x00d1,rl1
	outb	#0x00d3,rh0
	outb	#0x00d5,rl0
	outb	#0x00d7,rl0
	outb	#0x00d9,rl0
	outb	#0x00db,rl0
	outb	#0x00dd,rh0
	outb	#0x00df,rl0
	ldb		rl1,#7,#0
	outb	#0x0087,rl1
	ldb		rl1,#2,#0
	outb	#0x0093,rl1
	ldb		rl1,#0xc,#0
	outb	#0x0093,rl1
	outb	#0x008b,rh0
	outb	#0x008d,rh0
	outb	#0x008f,rh0
	ldk		r1,#8
	outb	#0x009f,rl1
	outb	#0x00bd,rh0
	ldb		rl1,#8,#0
	outb	#0x0081,rl1
	ldb		rl1,#9,#0
	outb	#0x0083,rl1
	ret


tepa:
	push	@r14,#0x000c
	jp	l0a92

tprv:
	push	@r14,#0x000d
	jp	l0a92

tnmi:
	push	@r14,#0x000f
	jp	l0a92

tnvi:
	/* play with the FCW on the stack turn of the NVI bit turn on the vi bit */
	set	0x3f02(r15),#0x0c
	res	0x3f02(r15),#0x0b
	push	@r14,#0x000a
	jp	l0a92

tseg:
	ex	r0,@r14
	sinb	rl0,#0x02fc
	ex	r0,@r14
	soutb	#0x11fc,rl0
	bit	0x3f02(r15),#0x0e
	jp	z,l0a84

	cp	0x3f06(r15),#_pgetw
	jp	c,l0a84

	cp	0x3f06(r15),#_kkcopy
	jp	nc,l0a5c

	ex	r0,0x3f02(r15)
	ldctl	fcw,r0
	ex	r0,0x3f02(r15)
	inc	r15,#8
	ldb	_u,#0x0e
	ld	r1,#0xffff
	ret

l0a5c:
	cp	0x3f06(r15),#kkfix
	jp	nc,l0a84

	ex	r0,0x3f02(r15)
	ldctl	fcw,r0
	ex	r0,0x3f02(r15)
	inc	r15,#8
	dec	r5,#1
	ldb	_u,#0x0e
	jp	kkfix

l0a84:
	push	@r14,#0x000b
	jp	l0a92

tsys:
	push	@r14,#00007
l0a92:
	dec	_depth,#1
	sub	r8,@r4
	sub	r15,#00020
	ldm	@r14,r0,#10
	ldctl	r0,nspseg
	ldctl	r1,nspoff
	pushl	@r14,rr0
	ld	r0,#0x3d3d
	soutb	#0x01fc,rh0
	sinb	rh3,#0x0cfc
	sinb	rl3,#0x0cfc
	sinb	rh2,#0x0cfc
	sinb	rl2,#0x0cfc
	pushl	@r14,rr2
	ei	nvi
	call	_trap
	jp	vi0b26


vint:
	sub	r15,#00022		/* allocate some space */
	ldm	@r14,r0,#0x0e	/* save all but stack pointer */
	ldctl	r0,nspseg
	ldctl	r1,nspoff
	pushl	@r14,rr0	/* save normal stack pointer */

	ldl	_ddtregp,rr14	/* stash frame pointer for ddt */

	ld	r0,#0x3d3d		/* get segment 0x3d,0x3e info */
	soutb	#0x01fc,rh0
	sinb	rh3,#0x0cfc
	sinb	rl3,#0x0cfc
	sinb	rh2,#0x08fc
	sinb	rl2,#0x08fc
	pushl	@r14,rr2	/* save on stack */

	dec	_depth,#1

	ld	r2,0x3f2a(r15)
	and	r2,#0x00fe
	push	@r14,r2

	ld	r0,_vmaps(r2)		/* set segment 0x3f */
	soutb	#0x08fc,rh0		/* base field high */
	soutb	#0x08fc,rl0		/* base field low */

	add	r2,r2
	ldl	rr2,_vecs(r2)
	call	@r2				/* call the handler */
	inc	r15,#2

vi0b26:
	test	_depth
	jp	nz,vi0b54			/* jump if nested */

	ldl	rr0,_cprocp
	cpl	rr0,_iprocp
	jp	z,vi0b4e

	bit	0x3f2c(r15),#0x0e	/* check saved FCW s/n bit */
	jp	nz,vi0b54

vi0b4e:
	call	_stand			/* call if not system */

vi0b54:
	di	nvi
	inc	_depth,#1

	popl	rr0,@r14
	ld	r2,#0x3d3d
	soutb	#0x01fc,rh2	/* Segment address register 0x3d */

	soutb	#0x0cfc,rh1	/* base field 0x3d high */
	soutb	#0x0cfc,rl1	/* base field 0x3d low */
	soutb	#0x0cfc,rh0	/* base field 0x3e high */
	soutb	#0x0cfc,rl0	/* base field 0x3e low */

	/* set normal stack pointer from stack */
	popl	rr2,@r14
	ldctl	nspseg,r2
	ldctl	nspoff,r3

	ldm	r0,@r14,#0x0e		/* restore registers */
	add	r15,#0x0022			/* free stack allocation */

	/* restore NVI/VI status that was switched in entry */
	bit	0x3f02(r15),#0x0b
	jp	z,vi0b96

	res	0x3f02(r15),#0x0c

	/* coherent symbol table has SSTEP  as 0x0203 */
	outb	#0x0203,rl0

vi0b96:
	iret

/*
 *
 */
clk:
	push	@r14,#00000
	bit	0x3f34(r15),#0x0e
	jp	nz,c1

	inc	@r14,#1
c1:
	pushl	@r14,0x3f36(r15)
	call	_clock
	inc	r15,#6

	ld	r0,#00024
	outb	#CT3CS,rl0
	ret


/*
 *
 */
	.global _vret, _halt
_vret:
	ret


/*
 *
 */

_halt:
	di	nvi
h:	jp	h


/* memory management stuff needs porting */

	.global _consave, _envsave
/*
 * int envsave(MCON *);
 *
 * called from proc.c: pfork(),dispatch().
 *
 * TODO use this info to reverse engineer MCON structure.
 *
 *	r6		0x00
 *	r7		0x02
 *	r8		0x04
 *	r9		0x06
 *	r10		0x08
 *	r11		0x0a
 *	r12		0x0c
 *	r13		0x0e
 *	r14		0x10
 *	r15		0x12
 *	seg3dh	0x14	ES
 *	seg3dl	0x16
 *	seg3eh	0x18	OS
 *	seg3el	0x1a
 *	depth	0x1c
 *	fcw		0x1e
 *  tos		0x20
 */
_consave:
_envsave:

	ldl	rr2,SS|0x04(r15)	/* get pointer to MCON into rr2 */
	ldm	@rr2,r6,#0x0a		/* save regs r6 up */
	add	r3,#0x0020			/* rr2 now points to location after saved regs */

	ld	r1,#0x3d3d
	ldctl	r4,fcw			/* entry int enable status */
	di	nvi

	soutb	#0x01fc,rh1		/* get the bases for segments 0x3d and 0x3e */
	sinb	rh0,#0x0cfc
	sinb	rl0,#0x0cfc
	sinb	rh1,#0x0cfc
	sinb	rl1,#0x0cfc

	ldctl	fcw,r4

	pushl	@rr2,rr0	/* put bases in arg */
	ld	r5,DS|_depth
	pushl	@rr2,rr4	/* put fcw and depth */
	pushl	@rr2,@rr14	/* put stack pointer */
	sub	r1,r1			/* return 0 */
	ret





/*
 * envrest(MENV *);
 *
 * called from proc.c: sleep()
 */
 .global _envrest
_envrest:

	ldl     rr2,|%3f000004|(r15)
	jp		l0c2c			/* with arg in rr2 */


/*
 * conrest(MENV *);
 *
 * called from proc.c: dispatch()
 */
 .global _conrest

_conrest:
	dec	DS|_depth,#1
	ldl     rr0,|%3f000004|(r15)
	lda     rr2,%3f000000(r1)
	di	vi

	soutb	#0x01fc,rh2		/* segment of arg*/
	add	r0,r0
	add	r0,r0
	soutb	#0x08fc,rh0		/* set the base address */
	soutb	#0x08fc,rl0

	/* common code to _envrest and _conrest */

l0c2c:
	ldm	r6,@rr2,#0xa	/* restore regs 6 to 15 */
	add	r3,#0x0014		/* point to end of structure !!AWN don't see how this value gets to end of structure!!*/

	popl	@r14,@rr2	/*  to tos */
	popl	rr4,@rr2
	ld	DS|_depth,r5

	ld	r1,#0x3d3d		/* ES */
	di	vi
	soutb	#0x01fc,rh1	/* sement 0x3d */
	popl	rr0,@rr2
	soutb	#0x0cfc,rh0	/* ES */
	soutb	#0x0cfc,rl0
	soutb	#0x0cfc,rh1	/* OS */
	soutb	#0x0cfc,rl1

	ldctl	fcw,r4
	ldk	r1,#1			/* return 1 */
	ret

/*
 * if ported to gcc z8001
 * if -mstd not specified
 * param 1 in r7
 * param 2 in r6
 * gcc returns in r2, args on stack
 *
 */
	.global _spl, _sphi, _in, _inb, _out, _outb
	.global _inwcopy,_inbcopy, _outwcopy, _outbcopy
	.global _pgetw, _pgetb, _pgetp, _pputw, _pputb
	.global _pputp, _ukcopy, _kkcopy, _kclear


/*
 * int spl(int)
 */
_spl:
	ldctl	r1,fcw
	ld	r0,03f04(r15)
	ldctl	fcw,r0
	ret

_sphi:
	ldctl	r1,fcw
	di	nvi
	ret


_in:
	ld	r1,03f04(r15)
	in	r1,@r1
	ret


_inb:
	ld	r1,03f04(r15)
	inb	rl1,@r1
	subb	rh1,rh1
	ret


_out:
	ld	r1,03f04(r15)
	ld	r0,03f06(r15)
	out	@r1,r0
	ret


_outb:
	ld	r1,03f04(r15)
	ld	r0,03f06(r15)
	outb	@r1,rl0
	ret
/*
 *void inwcopy(int port, int seg, int address, int count);
 */
_inwcopy:
	ld	r1,03f04(r15)
	ldl	rr2,03f06(r15)
	ld	r0,03f0a(r15)
	srl	r0,#1
	inir	@r2,@r1,r0
	ret


_inbcopy:
	ld	r1,03f04(r15)
	ldl	rr2,03f06(r15)
	ld	r0,03f0a(r15)
	inirb	@r2,@r1,r0
	ret

_outwcopy:
	ld	r1,03f04(r15)
	ldl	rr2,03f06(r15)
	ld	r0,03f0a(r15)
	srl	r0,#1
	otir	@r1,@r2,r0
	ret

_outbcopy:
	ld	r1,03f04(r15)
	ldl	rr2,03f06(r15)
	ld	r0,03f0a(r15)
	otirb	@r1,@r2,r0
	ret


/*
 *	pgetw(int seg, int offset)
 */
_pgetw:
	ldl	rr2,03f04(r15)
	ld	r1,@r2
	ret


_pgetb:
	ldl	rr2,03f04(r15)
	sub	r1,r1
	ldb	rl1,@r2
	ret
/*
 *	long pgetp(int seg, int offset)
 */
_pgetp:
	ldl	rr2,03f04(r15)
	ldl	rr0,@r2
	ret

/*
 * void pputw(int seg, int offset, int val)
 *
 */
_pputw:
	ldl	rr2,03f04(r15)
	ld	r1,03f08(r15)
	ld	@r2,r1
	ret
/*
 * void pputb(int seg, int offset, char val)
 *
 */
_pputb:
	ldl	rr2,03f04(r15)
	ld	r1,03f08(r15)
	ldb	@r2,rl1
	ret

/*
 * void pputp(int seg, int offset, long val)
 *
 */
_pputp:

	ldl	rr2,03f04(r15)
	ldl	rr0,03f08(r15)
	ldl	@r2,rr0
	ret

/*
 * ukcopy(long, long, int)
 * @param src
 * @param dst
 * @param nbytes
 *
 * @returns
 */
_ukcopy:
	ldl	rr2,03f04(r15)
	and	r2,#01f00		/* enforce user segment */
	jp	l0d3a


/*
 * kkcopy(long, long, int)
 * @param src
 * @param dst
 * @param nbytes
 *
 * @returns # bytes copied
 */

_kkcopy:
	ldl		rr2,03f04(r15)		/* source */
l0d3a:
	ldl		rr4,03f08(r15)		/* destination */
	ld		r0,03f0c(r15)		/* count */
	test	r0
	jp		z,kkfix

	ld		r1,r0				/* check for odd src,dst or count */
	or		r1,r3
	or		r1,r5
	rr		r1,#1
	jp		c,l0d66				/* copy byte at a time if so */

	srl		r0,#1				/* # words */
	ldir	@r4,@r2,r0
	jp		kkfix

l0d66:
	ldirb	@r4,@r2,r0
kkfix:							/* r0 will be 0 */
	ld		r1,r5				/* r5 will be offset of dst after copy*/
	sub		r1,03f0a(r15)		/* sub offset of dst before copy*/
	ret							/* # bytes copied */

kclear:
	ldl		rr2,03f04(r15)
	ld		r0,03f08(r15)
	srl		r0,#1
	jp		nc,l0d86

	clrb	@r2
l0d86:
	dec		r0,#1
	jp		mi,l0d9e

	clr		@r2
	jp		z,l00d9e

	lda		r4,r2(#00002)
	ldir	@r4,@r2,r0
l0d9e:
	ret



/*
 * long pfix(int segment, long address)
 *
 * @param segment example value from commadore.c is 0x3a
 * @param address 32 bit segmented address
 *
 * @returns rr0 normalised segmented address
 *
 */
	.global _pfix
_pfix:
	ldctl	r4,fcw			/* save fcw so that interrupt enable status can be restored */

	ldb	rh0,0x3f05(r15)		/* get segment */
	subb	rl0,rl0			/* clear seg low for return value */

	ldl	rr2,0x3f06(r15)		/* get address */

							/* normalised offset into r1 for return value */
	ld	r1,r3				/* r1 = address offset */
	and	r1,#0x03ff			/* r1 = offset & 0x3ff */

	srll	rr2,#10			/* shift address down to loose bottom 10 bits*/
							/* adjust r3 to put segment in right place */
	add	r3,r3
	add	r3,r3				/* shift back up by 2 bits*/
	di	nvi,vi
	soutb	#0x01fc,rh0		/* segment address register*/
	soutb	#0x08fc,rh3		/* segment base high */
	soutb	#0x08fc,rl3		/* segment base low */

	ldctl	fcw,r4			/* restore fcw */
	ret

/*
 * ufix(void *p)
 */
	.global _ufix
_ufix:
	ldl	rr0,03f04(r15)
	and	r0,#01f00		/* mask off top seg bits to keep segment it in user space */
	ret

	.global _vtop
_vtop:
	ldl	rr0,0x3f04(r15)
	ldb	rl0,rh0
	and	r0,#0x007f
	ret

	.global _ptov
_ptov:
	ldl	rr0,0x3f04(r15)
	ldb	rh0,rl0
	and	r0,#0x7f00
	ret


/*
 * clear 512 byte blocks
 */
	.global _sclear
_sclear:
	call	omapget
	ld	r0,0x3f04(r15)
	add	r0,r0
	add	r0,r0
	pushl	@r14,rr0
	ld	r2,#0x3e3e
	ld	r4,r2

l0e04:
	dec	0x3f0a(r15),#1
	jp	mi,l0e2a

	call	omapset

	sub	r3,r3
	ldk	r5,#2
	ld	r0,#0x01ff
	clr	@r2					/* clear the first word */
	ldir	@r4,@r2,r0		/* clear the rest */
	inc	@r14,#4
	jp	l0e04				/* loop */

l0e2a:
	inc	r15,#2
	call	omapset
	inc	r15,#2
	ret

/*
 *
 */
	.global _slrcopy
_slrcopy:
	ldl	rr0,0x3f04(r15)
	addl	rr0,rr0
	addl	rr0,rr0
	ld	r2,0x3f08(r15)
	test	r2
	jp	z,l0eba

	ldctl	r3,fcw
	dec	r15,#0xa
	ldm	@r14,r6,#5
	ld	r4,#0x3d3d
	ld	r8,#0x3e3e

	di	nvi
	soutb	#0x01fc,rh4
	sinb	rh6,#0x0cfc
	sinb	rl6,#0x0cfc
	sinb	rh7,#0x0cfc
	sinb	rl7,#0x0cfc
	ldctl	fcw,r3

l0e72:
	di	nvi
	soutb	#0x01fc,rh4
	soutb	#0x0cfc,rh0
	soutb	#0x0cfc,rl0
	soutb	#0x0cfc,rh1
	soutb	#0x0cfc,rl1
	ldctl	fcw,r3
	ld	r10,#0x0200
	sub	r5,r5
	sub	r9,r9
	ldir	@r8,@r4,r10
	inc	r0,#4
	inc	r1,#4
	djnz	r2,l0e72

	di	nvi
	soutb	#0x01fc,rh4
	soutb	#0x0cfc,rh6
	soutb	#0x0cfc,rl6
	soutb	#0x0cfc,rh7
	soutb	#0x0cfc,rl7
	ldctl	fcw,r3
	ldm	r6,@r14,#5
	inc	r15,#0x0a

l0eba:	ret

/*
 *
 */
	.global _omapset
_omapset:
omapset:
	ld	r1,#0x3e3e
	ldctl	r0,fcw
	di	nvi
	soutb	#0x01fc,rh1
	ld	r1,0x3f04(r15)
	soutb	#0x08fc,rh1
	soutb	#0x08fc,rl1
	ldctl	fcw,r0
	ret

/*
 *
 */
	.global _emapset
_emapset:
	ld	r1,#0x3d3d
	ldctl	r0,fcw
	di	nvi
	soutb	#0x01fc,rh1
	ld	r1,0x3f04(r15)
	soutb	#0x08fc,rh1
	soutb	#0x08fc,rl1
	ldctl	fcw,r0
	ret

/*
 *	saddr_t omapget()
 *
 * @returns current base address of segment 0x3e
 */
	.global _omapget
_omapget:
omapget:
	ld	r1,#0x3e3e
	ldctl	r0,fcw			; save interrupt state
	di	nvi

	soutb	#0x01fc,rh1		; get base address of segment 0x3e
	sinb	rh1,#0x08fc
	sinb	rl1,#0x08fc

	ldctl	fcw,r0			; save interrupt state
	ret

/*
 *
 */
	.global _emapget
_emapget:
	ld	r1,#0x3d3d
	ldctl	r0,fcw
	di	nvi
	soutb	#0x01fc,rh1
	sinb	rh1,#0x08fc
	sinb	rl1,#0x08fc
	ldctl	fcw,r0
	ret

/*
 *
 *
 *	loadmmu(MPROTO *psegs, nsegs)
 */
	.global _loadmmu
_loadmmu:
	ld		r0,0x3f04(r15)	/* r0 is #segs */
	ld		r5,#0x0030
	sub		r5,r0			/* r5 will be 0 if #segs is 0x30 ???? */

	add		r0,r0
	add		r0,r0			/* translate #segs to #bytes to op to MMU ?? */

	ldl		rr2,0x3f06(r15)	/* rr2 is pointer to MPROTO */
	sub		r1,r1			/* r1 = 0 */
	ldctl	r4,fcw			/* save interrupt enable status */

	di		nvi
	soutb	#0x01fc,rh1		/* select MMU base reg 0 */
	soutb	#0x20fc,rl1		/* set counter reg to 0 */
	ld		r1,#0x0ffc
	sotirb	@r1,@r2,r0

	test	r5
	jp		z,l0f60
							/* set the remainning segment attributes to MMU_ATTRIB_CPUI */
	ldar	r2,cseg

	ld		r1,#0x0efc
	sotirb	@r1,@r2,r5		/* write attribute field */
l0f60:
	ldctl	fcw,r4			/* restore interrupt enable status */
	ret

/*
 * apears to be full of MMU_ATTRIB_CPUI. This would make segment
 * only available to DMA controller
 */
cseg:
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04
	.byte 04, 04, 04, 04



/*
 * copy mmu regs to pointer
 * getmmu(p1, p2, p3)
 */
	.global _getmmu
_getmmu:
	ldl	rr0,0x3f04(r15)
	ldl	rr2,0x3f08(r15)
	add	r1,r1
	add	r1,r1
	soutb	#0x01fc,rl0
	soutb	#0x20fc,rh0
	ld	r4,#0x0ffc
	sinirb	@r2,@r4,r1
	ret

/*
 *
 */
	.global _pscale
_pscale:
	ld	r1,0x3f04(r15)
	mult	rr0,0x3f06(r15)
	ld	r1,r0
	ret

/*
 * idle() C code calls this, wait for interrupt
 */
	.global __idle
__idle:

	ei	nvi,vi
	halt
	ret

/*
 *	Data segment
 */
	.data
	.global _vecs, _vmaps
/*
	.global icode, argv, file, swap, driv1, icend
	.global _icodep, _icodes, _ddtregp, _depth
*/
_vecs:
	.word 0x3000
	.word _vret
	.ds 0x100 -2
_vmaps:
	.ds 0x80


/*
 Code for init, 0x031a is argv, 0x032a is file

	subl	rr0,rr0
	pushl	@r14,rr0
	ld	r2,#0x0303
	ld	r3,#0x001a
	pushl	@r14,rr2
	ld	r3,#0x002a
	pushl	@r14,rr0
	sc	#0x0b
	jr	.
*/


icode:
	.byte 0x92
	.byte 0x00
	.byte 0x91
	.byte 0xe0
	.byte 0x21
	.byte 0x02
	.byte 0x03
	.byte 0x03
	.byte 0x21
	.byte 0x03
	.byte 0x00
	.byte 0x1a
	.byte 0x91
	.byte 0xe2
	.byte 0x21
	.byte 0x03
	.byte 0x00
	.byte 0x2a
	.byte 0x91
	.byte 0xe2
	.byte 0x91
	.byte 0xe0
	.byte 0x7f
	.byte 0x0b
	.byte 0xe8
	.byte 0xff

argv:
	.long 0x0303002a	/* file */
	.long 0x03030034	/* swap */
	.long 0x03030035	/* driv1 */
	.long 0x00000000

file:
	.asciz "/etc/init"
swap:
	.byte 0
driv1:
	.asciz "/drv/kv"
	.byte 0
icend:


_icodep:
	.long icode
_icodes:
	.word icend - icode
_ddtregp:
	.long 00000000
_depth:
	.word 0000








