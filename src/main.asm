
.INCLUDE "../atmega328p.inc"
.nolist
.list
.org 0x0000
.def on = r16
.def off = r17
.def ldr = r18
	rjmp start
start:
	ldi on, 0xff
	ldi off, 0x00
	out ddrb, on
	out ddrd, off
	out portb, off
	rjmp loop

loop:
	in ldr, pind0
	cpi ldr, 0x0f
	brlo led
	rjmp loop
led:	
	out portb, on
	rjmp loop