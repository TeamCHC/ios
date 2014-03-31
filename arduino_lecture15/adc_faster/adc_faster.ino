     // For fast ADC conversion, faster than the ATmega datasheet recommends
     //   see: http://www.marulaberry.co.za/index.php/tutorials/code/arduino-adc/
     // the effect of using a higher sampling rate will be that the you may not get 
     // 10 bits of resolution
    
    // Arrays to save our results in
    unsigned long start_times[100];
    unsigned long stop_times[100];
    unsigned long values[100];
    
    
    // Define various ADC prescaler
    // 16 MHz / 2 = 8 MHz
    // 16 MHz / 4 = 4 MHz
    // 16 MHz / 8 = 2 MHz
    // 16 MHz / 16 = 1 MHz
    // 16 MHz / 32 = 500 kHz
    // 16 MHz / 64 = 250 kHz
    // 16 MHz / 128 = 125 kHz
    const unsigned char PS_16 = (1 << ADPS2);
    const unsigned char PS_32 = (1 << ADPS2) | (1 << ADPS0);
    const unsigned char PS_64 = (1 << ADPS2) | (1 << ADPS1);
    const unsigned char PS_128 = (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
    
    // Setup the serial port and pin 2
    void setup() {
      Serial.begin(9600);
      pinMode(2, INPUT);
      
      // set up the ADC
      ADCSRA &= ~PS_128;  // remove bits set by Arduino library
      
      // you can choose a prescaler from above.
      // PS_16, PS_32, PS_64 or PS_128
      ADCSRA |= PS_64;    // set our own prescaler to 64 
//      
//      /* Enable the ADC */
//      ADCSRA |= _BV(ADEN);
// 
//      /* Set the PIN pin as an output. */
//      pinMode(A0, INPUT);
      
    }
    
    
    void loop() {  
      unsigned int i;
      
      // capture the values to memory
      for(i=0;i<100;i++) {
        start_times[i] = micros();
        values[i] = analogRead(0);
        stop_times[i] = micros();
      }
    
      // print out the results
      Serial.println("\n\n--- Results ---"); 
      for(i=0;i<100;i++) {
        Serial.print(values[i]);
        Serial.print(" elapse = ");
        Serial.print(stop_times[i] - start_times[i]);
        Serial.print(" us\n");
      }
      delay(6000);
    }
    
    int adc_read(byte adcx) {
	/* adcx is the analog pin we want to use.  ADMUX's first few bits are
	 * the binary representations of the numbers of the pins so we can
	 * just 'OR' the pin's number with ADMUX to select that pin.
	 * We first zero the four bits by setting ADMUX equal to its higher
	 * four bits. */
	ADMUX	&=	0xf0;
	ADMUX	|=	adcx;
 
	/* This starts the conversion. */
	ADCSRA |= _BV(ADSC);
 
	/*  wait around until the conversion is finished. */
	while ( (ADCSRA & _BV(ADSC)) );
 
	/* return the converted value */
	return ADC;
    }
