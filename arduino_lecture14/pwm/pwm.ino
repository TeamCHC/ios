/*
 * PWM Demo
 * Arduino
 *
 * This code uses pulse width modulation (PWM) to control the brightness of the
 * LED. The LED slowly gets brighter and then dimmer in a loop.
 *
 * The following external hardware is required:
 *   - a wire connecting pin 11 to pin 13
 *
 * @author Gabe Cohn, Eric Larson
 ******************************************************************************/

/* constants */
#define BRIGHT_CHG_PERIOD   10  // milliseconds between LED brightness chagnes

/* pin definitions */
#define LED     13              // LED is on pin 13
#define LED_PWM 11              // PWM output which we will use for the LED

/* variables */
byte ledBrightness = 1;         // LED brightness (PWM value)
char delta = 1;                 // amount to change brightness each step

/* initialization code */
void setup() {       

    //default is to not have any pull up, resistor on Arduino > 0016  
    pinMode(LED, INPUT);        /* set LED pin as an input so that it does 
                                 * not interfere with the PWM signal which
                                 * is also connected (externally) to the
                                 * same pin */
    
    // setting PWM without arduino code
//    pinMode(3, OUTPUT);
//    pinMode(11, OUTPUT);
//    TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);
//    TCCR2B = _BV(CS22);
//    OCR2A = 200;
//    OCR2B = 120;
}

/* mainloop - runs forever */
void loop() {

    // change brightness directions at end of scale
    if (ledBrightness == 0 || ledBrightness == 255) {
        delta *= -1;           //flip brightness change direction
    }
    
    ledBrightness += delta;    // change brightness setting
    analogWrite(LED_PWM, ledBrightness); // set new brightness
    
    // wait before changing brightness again
    delay(BRIGHT_CHG_PERIOD);
}
