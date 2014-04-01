/*
 * Watch Dog tmer example
 * Arduino
 * @ Author: Eric C Larson
 ******************************************************************************/
#include <avr/wdt.h>

/* constants */
#define LED    13               // PWM is on pin 11
#define SW     2                // switch input on pin 2
#define SW_GND 4                // other side of switch on pin 4
#define USE_WDT 1               // whether to use or not use the WDT

boolean on_start = true;

/* initialization code */
void setup() {

    // setup switch pin as a digital input with pull-up resistor
    pinMode(SW, INPUT_PULLUP);

    // connect the other side of the switch to ground
    pinMode(SW_GND, OUTPUT);
    digitalWrite(SW_GND, LOW);
    
    // tell LED to be out put for 2 seconds
    pinMode(LED, OUTPUT);

    // configure interrupts when switch is pressed
    attachInterrupt(0, SW_ISR, FALLING);  
  
    if(USE_WDT==1)
      wdt_enable(WDTO_8S); // watch dog set at 8 seconds, don't go much lower
    else
      wdt_disable();
}

/* mainloop - runs forever */
void loop() {
    if(on_start){
      on_start = false;
      digitalWrite(LED, HIGH);
      delay(1000);
      digitalWrite(LED, LOW);
    }
}

/* switch press interrupt service routine */
void SW_ISR() {
  // if you do not interrupt the WDT, then the board will reset
  wdt_reset();
}
