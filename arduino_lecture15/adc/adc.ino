/*
 * ADC Demo
 * Arduino
 *
 * This code uses analog-to-digital converter (ADC) and an external light sensor
 * to determine the ambient brightness, and then light the LED in response to
 * the changes in brightness. 
 * 
 * The sensed brightness will be reported using the LED, as shown below:
 *  - Brightness:   LED off
 *  - Darkness:     LED on
 *
 * The following external hardware is required:
 *   - photo-resistor between A0 and GND
 *
 *
 * I am using the internal pull-up resistor on the ADC input pin to form a
 * voltage divider with the photo-resistor, which is grounded. 
 * This allows me to have minimal external components (only the photo-
 * resistor). Note that it is unconventional to use the internal pull-up in
 * this way, and typically the pull-up/downs should be disabled on any analog
 * input pins. In addition, enabling a pull-up on an analog pin is not supported
 * by the Arduino API, so I am using the underlying AVR registers to accomplish
 * this. This is an example of how low level registers can also be used within
 * an Arduino project.
 *
 * @author Gabe Cohn
 * @date 02/01/2012 - Gabe Cohn     @li initial revision
 *updted by Eric Larson for resistance calc
******************************************************************************/

/* constants */
#define SAMPLE_PERIOD   50      // milliseconds between ADC samples
#define DARK            200     // ADC values >= this are considered dark

/* pin definitions */
#define LED    13               // LED is on pin 13
#define SENSOR 0                // sensor on A0
#define SENSOR_PIN  0x1         // bit mask for sensor (PC0)

#define RSUM 10 // in kOhms
#define VREF 3.3 //volts
#define VRESIST 5.0 //volts

/* initialization code */
void setup() {                
    pinMode(LED, OUTPUT);       // configure LED as an output
  
     Serial.begin(9600);
     
     analogReference(DEFAULT);
     // can also set reference as DEFAULT, INTERNAL, INTERNAL1V1, INTERNAL2V56, or EXTERNAL
     
    /* enable the pull-up resistor on the SENSOR input
     * the Arduino API does not allow me to do this, but I can just write to 
     * the underlying registers which allow me to do this */
    DDRC &= ~(SENSOR_PIN);      // configure as input
    PORTC |= SENSOR_PIN;        // enable pull-up resistor
}

/* mainloop - runs forever */
void loop() {

    unsigned short data;        // ADC data
    float resistance;
    
    data = analogRead(SENSOR);  // read value from ADC
    //convert the analog input a resistance, 
    // knowing that the sum of the resistors is 10k
    // and that VRESIST is 5V
    resistance = 2*((float)(data))/1024.0*VREF;
    
    Serial.print(resistance);
    Serial.print(" kohms\n");
    // change LEDs to indicate sensor value
    if (data < DARK) {          // bright
        digitalWrite(LED, LOW); //turn off LED
        
    } else {                    // dark
        digitalWrite(LED, HIGH); //turn on LED
    }
    
    // wait before sampling ADC again
    delay(SAMPLE_PERIOD);
}
