int ledPin = 9;    // LED connected to digital pin 9
int digitalinPin1=7;
int digitalinPin2=6;
int digitalinPin3=5;
int digitalinPin4=3;
int analoginPin1=0;
int analoginPin2=1;
int analoginPin3=2;


int filterSlideLowThresh=100;
void setup()  {
  // nothing happens in setup
  Serial.begin(9600);
  pinMode(digitalinPin1,INPUT);
  pinMode(digitalinPin2,INPUT);
  pinMode(digitalinPin3,INPUT);
  pinMode(digitalinPin4,INPUT);
}
 
void loop()  {
  //read in from Analog pin 1,2,3,4 
  int analin1 = analogRead(analoginPin1);
  int analin2 = analogRead(analoginPin2);
  int analin3 = analogRead(analoginPin3);
  
  //read in from digital pin 1,2,3,4
  int digitalin1 = digitalRead(digitalinPin1);
  int digitalin2 = digitalRead(digitalinPin2);
  int digitalin3 = digitalRead(digitalinPin3);
  int digitalin4 = digitalRead(digitalinPin4);
  
 
  // filter for sliding switch
  if(analin1<filterSlideLowThresh) analin1=0;
  if(analin2<filterSlideLowThresh) analin2=0;
  
  //send serial data to Processing module
  String delim="  ";
  String printOut = "CMSC838IA2"+delim+"3"+delim+"4"+delim+String(analin1) + delim+String(analin2)+ delim + String(analin3) +delim + String(digitalin1) +delim+String(digitalin2) +delim+String(digitalin3) +delim+String(digitalin4);
  Serial.println(printOut);
  delay(100);
}
