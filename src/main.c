// ~/apps/avrdude/bin/avrdude ~/apps/avrdude/etc/avrdude.conf -F -v -V -pattiny2313 -cavrisp -P/dev/ttyUSB0 -b19200 -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h
// ~/apps/avrdude/bin/avrdude ~/apps/avrdude/etc/avrdude.conf -F -v -V -pattiny2313 -cavrisp -P/dev/ttyUSB0 -b19200 -U flash:w:build/demo.hex
// ~/apps/avrdude/bin/avrdude ~/apps/avrdude/etc/avrdude.conf -F -v -V -pattiny2313 -cavrisp -P/dev/ttyUSB0 -b19200 -U flash:r:build/verify.hex
//

#include <avr/io.h>

int main(void)
{
    char toggle = 0;        // toggle LED flag
    
    DDRA |= (1 << PA0);     // LED on PA0

    OCR1A = 0x4000;         // number to count to
    TCCR1A = 0;             // CTC mode
    
    // CTC mode, clk src = clk/8, start timer
    TCCR1B = (1 << WGM12) | (1 << CS11);
    
    while(1)
    {
	    // count reached?
        if (TIFR & (1 << OCF1A)) 
        {  
            TIFR |= (1 << OCF1A);   // clear flag
            
            if (toggle) 
            {   
            	// toggle LED
                toggle = 0;
                PORTA &= ~(1 << PA0);
            }
            else 
            {
                toggle = 1;
                PORTA |=  (1 << PA0);
            }
        }            
    }	
}


