
/*
 * Create a triangle wave output
 * Arduino
 *
 *
 * @author  Eric Larson
 ******************************************************************************/



/* initialization code */
void setup() {                
  
    // setup switch pin as an output
    pinMode(9, INPUT);

}

/* mainloop - runs forever */
void loop() {
  for(int analogValue = 0; analogValue<255; analogValue++){
      analogWrite(9,analogValue);  
      delay(10);  
  }  
  for(int analogValue = 254; analogValue>0; analogValue--){
      analogWrite(9,analogValue);  
      delay(10);  
  }  
    
}

