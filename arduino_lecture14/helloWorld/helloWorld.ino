/*
 * Hello World
 * Arduino
 *
 * This code simply blinks an LED forever.
 *
 * @author Gabe Cohn and Eric Larson
 ******************************************************************************/

/* constants */
#define BLINK_DELAY    500      // number of milliseconds between LED toggles

/* pin definitions */
#define LED    13               // LED is on pin 13 of the Uno board

/* initialization code */
void setup() {                
    pinMode(LED, OUTPUT);       // set LED pin as an output
    
    Serial.begin(9600);
}

/* mainloop - runs forever */
void loop() {
    digitalWrite(LED, HIGH);    // turn LED on
    delay(BLINK_DELAY);         // wait before turning it off
    digitalWrite(LED, LOW);     // turn LED off
    delay(BLINK_DELAY);         // wait before turning it back on
                                // now return to the top of the loop
                                
    Serial.print("LED Blinked\n");
}
