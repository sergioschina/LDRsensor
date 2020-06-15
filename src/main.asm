
.INCLUDE "../atmega328p.inc"
.nolist
.list
.org 0x0000
.def on = r20
.def off = r21
.def adclow = r18
.def adchigh = r19
	rjmp start
start:
	ldi on, 0xff
	ldi off, 0x00
	out ddrb, on 		; Coloca os pinos b como output
	call configure_adc

loop:
    call read_adc 
    call wait_adc
    lds adclow, ADCL 		; Ler o ADCL antes do ADCH por ser o low byte do adc
    lds adchigh, ADCH
	cpi adchigh, 0x02 
	brsh led_off		; se o ADCH > 0x80 desliga o led
	out portb, on		; senão liga o led
	rjmp loop

led_off:
	out portb, off
	rjmp loop

configure_adc:
    ldi r22, 0b01000000   ; os ultimos 3 bits seleciona o canal ADC0 como pino de entrada
    sts ADMUX, r22

    ldi r22, 0b10000101   ; Habiliita o ADC e seleciona o modo "Single Conversion"
    sts ADCSRA, r22       ; Configura o fator de divisão da tensão para 32
    ret

read_adc:
    ldi r22, 0b01000000   ; Inicia de fato a conversão ADC
    lds r23, ADCSRA
    or  r23, r22
    sts ADCSRA, r23
    ret
wait_adc:
    lds r23, ADCSRA       ; Fazemos uma repetição checando o quarto bit
    sbrs r23, 4           ; se o quarto bit for 1 ele sai do loop
    jmp wait_adc           ; o 4 bit significa que acabou a conversão ADC

    ldi r22, 0b00010000   ; Configura a flag novamente para o hardware limpá-la
    lds r23, ADCSRA 
    or  r23, r22
    sts ADCSRA, r23
    ret
