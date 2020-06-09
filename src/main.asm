
.INCLUDE "../atmega328p.inc"
.nolist
.list
.org 0x0000
.def on = r20
.def off = r21
	rjmp start
start:
	ldi on, 0xff
	ldi off, 0x00
	out ddrb, on 		; Coloca os pinos b como output
	call adcInit

loop:
    call adcRead 
    call adcWait
    lds r18, ADCL 		; Ler o ADCL antes do ADCH por ser o low byte do adc
    lds r19, ADCH
	cpi r19, 0x80 
	brsh led_off		; se o ADCH > 0x80 desliga o led
	out portb, on		; senão liga o led
	rjmp loop

led_off:
	out portb, off
	rjmp loop

adcInit:
    ldi r16, 0b01100000   ; os ultimos 3 bits seleciona o canal ADC0 como pino de entrada
    sts ADMUX, r16

    ldi r16, 0b10000101   ; Habiliita o ADC e seleciona o modo "Single Conversion"
    sts ADCSRA, r16       ; Configura o fator de divisão da tensão para 32
    ret

adcRead:
    ldi r16, 0b01000000   ; Inicia de fato a conversão ADC
    lds r17, ADCSRA
    or  r17, r16
    sts ADCSRA, r17
    ret
adcWait:
    lds r17, ADCSRA       ; Fazemos uma repetição checando o quarto bit
    sbrs r17, 4           ; se o quarto bit for 1 ele sai do loop
    jmp adcWait           ; o 4 bit significa que acabou a conversão ADC

    ldi r16, 0b00010000   ; Configura a flag novamente para o hardware limpá-la
    lds r17, ADCSRA 
    or  r17, r16
    sts ADCSRA, r17
    ret
