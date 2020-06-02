
.INCLUDE "../atmega328p.inc"
.nolist
.list
.org 0x0000
.def high = r16
.def low = r17
.def ldr = r18
	rjmp start
start:
	ldi high, 0xff
	ldi low, 0x00
	out ddrb, high
	out ddrd, low
	out portb, low
	rjmp loop

loop:
	in ldr, pind0
	cpi ldr, 0x0f
	brlo led
	rjmp loop
led:	
	out portb, high
	rjmp loop