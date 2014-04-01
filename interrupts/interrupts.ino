/*
 * Interrupt Demo
 * Arduino
 *
 * This code blinks an LED constantly until the switch is pressed. The switch
 * press triggers and interrupt which changes the state of the system so that
 * the LED stops blinking. Pressing the botton again starts the LED blinking
 * again.
 *
 * The following external hardware is required:
 *   - switch between pin 2 and pin 4
 *
 * One end of the switch is tied to ground using a digital output, and the other
 * end is pulled up to Vcc using the internal pull-up resistor on the digital
 * input pin.
 *
 * The code may appear to not always respond to button presses. This is because
 * the switch is not being debounced. The problem is that the switch physically 
 * "bounces" causing the connection to be made, broken, and made again many times
 * just after it is pressed. We only want to respond to one of those events, but 
 * an interrupt is being triggered with every falling edge, so if there are an 
 * even number of bounces, then the state will not appear to change. There are 
 * severl ways to prevent this from happening (called switch debouncing) both 
 * in hardware and in software, but I will leave that to you to add to this
 * code.
 *
 * @author Gabe Cohn
 * @date 02/01/2012 - Gabe Cohn     @li initial revision
 ******************************************************************************/

/* constants */
#define BLINK_DELAY 100         // number of milliseconds between LED toggles

/* pin definitions */
#define LED    13               // LED is on pin 13
#define SW     2                // switch input on pin 2
#define SW_GND 4                // other side of switch on pin 4


/* global variables */
boolean blinkLED = true;
int potPin = A0;
int val = 0;


/* initialization code */
void setup() {
    Serial.begin(9600); // setup serial  
    pinMode(LED, OUTPUT);       // set LED pin as an output

    // setup switch pin as a digital input with pull-up resistor
    pinMode(SW, INPUT_PULLUP);

    // connect the other side of the switch to ground
    pinMode(SW_GND, OUTPUT);
    digitalWrite(SW_GND, LOW);

    // configure interrupts when switch is pressed
    attachInterrupt(0, SW_ISR, FALLING);
}

/* mainloop - runs forever */
void loop() {
  val = analogRead(potPin); // read input from analogPin
  Serial.println(val);
  
    if (blinkLED) {                 // blink LED if in that state
        digitalWrite(LED, HIGH);    // turn LED on
        delay(BLINK_DELAY);         // wait before turning it off
        digitalWrite(LED, LOW);     // turn LED off
        delay(BLINK_DELAY);         // wait before turning it back on
    }
}

/* switch press interrupt service routine */
void SW_ISR() {
    blinkLED = !blinkLED;           // toggle blink state
}
