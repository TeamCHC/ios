
  /*
 * Servo Demo with for continuous delta movements
 * Arduino
 * Motor will move in slight succession clockwise 10 clicks
 * Then will move counter clockwise for 10 clicks
 * Every so often the micro will spit out a long clockwise movement and sit idle
 * can you tell what this is? And how often it iterates?
 *
 * @author Eric Larson
 ******************************************************************************/

   
   
   
  void setup() 
  { 
    pinMode(9, OUTPUT); // set pin as output
    Serial.begin(9600);
  } 
   
  void loop() 
  { 
      int val;    // variable to read the value from the analog pin
      for(int j=0;j<5;j++){
        for(val=1450;val<1550;val+=10) // the microseconds for each pulse width
        {        
          for(int i=0; i<2; i++){ // send the pulse twice
            Serial.println(val);
            // send one pulse for each movement you want
            // there is no feedback circuit, so one pulse results in a delta movement
            // no matter what the current servo position
            digitalWrite(9,HIGH);
            delayMicroseconds(val);
            digitalWrite(9,LOW);
            delay(1000); // delay in milliseonds so that the motor will turn
          }
        }           
      }    
    digitalWrite(9,HIGH); 
    delayMicroseconds(800); // full rotation
    digitalWrite(9,LOW);
    delay(20000);  
  } 
  
  
