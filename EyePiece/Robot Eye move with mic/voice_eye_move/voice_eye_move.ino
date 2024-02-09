#include <Servo.h>

Servo servo;
Servo servo1;
Servo servo2;


//Sound variables
const int sampleWindow = 250; // Sample window width in mS (250 mS = 4Hz)
unsigned int sound;


void setup()
{
  servo.attach(5);
  servo1.attach(3);
  servo2.attach(4);
  Serial.begin(9600);
}


void loop()
{
  int position = 0;
  servo.write(90);
  servo1.write(90);
  servo2.write(90);

  servo1.write(180);
  servo2.write(0);
  delay(500);
  servo1.write(90);
  servo2.write(90);
  delay(50);


  unsigned long start = millis(); // Start of sample window
  unsigned int peakToPeak = 0;    // peak-to-peak level
  unsigned int signalMax = 0;
  unsigned int signalMin = 1024;

  // collect data for 250 miliseconds
  while (millis() - start < sampleWindow)
  {
    sound = analogRead(A0) && (A1);
    if (sound < 1024)  //This is the max of the 10-bit ADC so this loop will include all readings
    {
      if (sound > signalMax)
      {
        signalMax = sound;  // save just the max levels
      }
      else if (sound < signalMin)
      {
        signalMin = sound;  // save just the min levels
      }
    }
  }
  peakToPeak = signalMax - signalMin;
  double volts = (peakToPeak * 3.3) / 1024;
  Serial.print("Volts:");
  Serial.print("\t");
  Serial.println(volts);
  if (analogRead(A0) == volts >= 1.0)
  {

    for (position = 0; position <= 75; position += 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 75; position >= 0; position -= 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 0; position <= 75; position += 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 75; position >= 0; position -= 5)
    {
      servo.write(position);

      delay(20);
    }
    delay(800);
  }




  if (analogRead(A1) == volts >= 1.0)
  {

    for (position = 75; position <= 0; position += 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 0; position >= 75; position -= 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 75; position <= 0; position += 5)
    {
      servo.write(position);
      delay(20);
    }
    for (position = 0; position >= 75; position -= 5)
    {
      servo.write(position);

      delay(20);
    }
    delay(800);
  }

  servo1.write(180);
  servo2.write(0);
  delay(500);
  servo1.write(90);
  servo2.write(90);
  delay(50);
}
