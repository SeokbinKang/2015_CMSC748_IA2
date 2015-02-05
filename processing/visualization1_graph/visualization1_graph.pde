 // Analog, Digital Oscilloscope
 
 // This program takes input from serial port and display analog/digital signals on the screen
 // The serial massage format : "CMSC838IA2 numberofAnalogData numberofDigitalData Analog0 Analog1 ... Digital0 Digital1..."
 
  

 
 import processing.serial.*;
 
 Serial myPort;        // The serial port
 int xPos = 1;         // horizontal position of the graph
 int nAnalog = 3;
 int nDigital = 4;
 
 int screenW=1200;
 int screenH=600;
 
 String[] digitalLegend= {"D1","D2","D3","D4"};
 color digitalColor = #95a5a6;
 color[] analogColor =  {#2ecc71,#e67e22,#9b59b6,#3498db};
 String[] analogLegend= {"A1","A2","A3"};
 
 int[] digitalY= {0,0,0,0};
 PFont font;
 int xMargin=80;
 int[][] analogVal ;
 int[][] digitalVal;
 
 int analogIndex =0;
 int digitalIndex=0;
 int digitalHeight;
 int analogHeight =0;
 int dataCap = 250;
 int horizonY=0;
 
 
 //initialization
 void setup () {
 // set the window size:
 size(screenW, screenH);       
 if (frame != null) {
    frame.setResizable(true);
  }
 
 font = loadFont("FranklinGothic-Heavy-20.vlw");
 // List all the available serial ports
 println(Serial.list());
 myPort = new Serial(this, Serial.list()[0], 9600);
 myPort.bufferUntil('\n');
 
 

 background(0);
 dataCap=(screenW-xMargin*2)/3;
 analogVal = new int[3][2000];
   digitalVal =  new int[4][2000];
   
   for(int i=0;i<dataCap;i++)
   {
     analogVal[0][i]=-1;
     analogVal[1][i]=-1;
     analogVal[2][i]=-1;
     digitalVal[0][i]=-1;
     digitalVal[1][i]=-1;
     digitalVal[2][i]=-1;
     digitalVal[3][i]=-1;
           
   }
 
 
 }
 
 
 //draw axis and label
 void drawAxis() {
   horizonY = screenH*2/3;
   strokeWeight(10);
   stroke(#95a5a6);
   line(0,horizonY,screenW-1,horizonY);
   int nDigital = digitalLegend.length;
   digitalHeight=(screenH/3)/(nDigital+1);
   analogHeight = horizonY-xMargin;
   for(int i=0;i<nDigital;i++)
   {
     digitalY[i]=horizonY+((screenH/3)/(nDigital+1))/2+((screenH/3)/(nDigital+1))*(i+1);
     textFont(font, 20);
     fill(#89C4F4);
     text(digitalLegend[i],20,digitalY[i]);
     strokeWeight(4.0);
     stroke(#89C4F4);
     strokeCap(SQUARE);
     line(xMargin,digitalY[i]-4,screenW-xMargin,digitalY[i]-4);
   }
   for(int i=0;i<analogLegend.length;i++)
   {
     
     textFont(font, 20);
     fill(analogColor[i]);
     text(analogLegend[i],20+40*i,30);
    
   }
   for(int i=0;i<6;i++)
   {
     textFont(font, 10);
     fill(#95a5a6);
     text(i*200,xMargin/2,horizonY-xMargin/2-(i*200)*analogHeight/1022);
      strokeWeight(1.0);
     stroke(#95a5a6);
     line(xMargin,horizonY-xMargin/2-(i*200)*analogHeight/1022,screenW-xMargin-1,horizonY-xMargin/2-(i*200)*analogHeight/1022);
     
   }
   
   
   
  
 }
 
 //push received serial data into internal data array
 void pushData(int[] digitalVals, int[] analogVals) {
   
   analogVal[0][analogIndex]=analogVals[0];
   analogVal[1][analogIndex]=analogVals[1];
   analogVal[2][analogIndex]=analogVals[2];

    digitalVal[0][digitalIndex]=digitalVals[0];
   digitalVal[1][digitalIndex]=digitalVals[1];
   digitalVal[2][digitalIndex]=digitalVals[2];
   digitalVal[3][digitalIndex]=digitalVals[3];  
   analogIndex++;
   digitalIndex++;
   if(analogIndex==dataCap) analogIndex=0;
   if(digitalIndex==dataCap) digitalIndex=0;
   
 }
 
 
 // everything happens in the serialEvent()
 void draw () {

  if(screenW!=width || screenH!=height){
    screenW=width;
    screenH=height;
    dataCap=(screenW-xMargin*2)/3;
    analogIndex=0;
    digitalIndex=0;
    
  }
 }
 void drawSerial() {
    background(0);

 
 
  drawAxis(); 
  drawGraph();
 }
 
 //draw digital and analog graph
 void drawGraph() {
   //graph region : (xMargin,xMargin/2)~(xMArgine+dataCap,horizonY-xMargine/2);
   //analog
   int analogWidth = dataCap;
  analogHeight = horizonY-xMargin;
   int startI = analogIndex;
   int endI=analogIndex-1;
   if(endI<0) endI=dataCap-1;
   
   for(int row=0;row<nAnalog;row++){
     int xIndex=1;  
      strokeWeight(2.0);
     stroke(analogColor[row]);
     strokeCap(ROUND);
   
     for(int i=startI;xIndex<dataCap-1;i++) {
           
     if(i==dataCap) {
          i=0;
        
     }
     int prevI=i-1;
     if(prevI<0 ) prevI=dataCap-1; 
     
     if(analogVal[row][i]!=-1) line(xMargin+xIndex*3,horizonY-xMargin/2-(analogVal[row][prevI]*analogHeight/1022),xMargin+xIndex*3+3,horizonY-xMargin/2-(analogVal[row][i]*analogHeight/1022));
       
      xIndex++;       
     
     }
     
   }
   
   
   //digital
   
   for(int row=0;row<nDigital;row++)
   {
     int y_=digitalY[row]-2;     
     
     int xIndex=1;  
     strokeWeight(3.0);
     stroke(#89C4F4);
     strokeCap(SQUARE);
     
     for(int i=startI;xIndex<dataCap-1;i++) {
           
     if(i==dataCap) {
          i=0;
        
     }
     int prevI=i-1;
     if(prevI<0 ) prevI=dataCap-1; 
     
     if(digitalVal[row][i]>0) {
       line(xMargin+xIndex*3,y_,xMargin+xIndex*3,y_-digitalHeight);
     }
       
      xIndex++;       
     
     }
   }
 }
 
 //receive and parse serial data
 void serialEvent (Serial myPort) {
 
 
 String inString = myPort.readStringUntil('\n');
 int[] analogV={0,0,0};
 int[] digitalV={0,0,0,0};
  String keyword="CMSC838IA2";
 if (inString != null) {
   // trim off any whitespace:
   inString = trim(inString);
   // convert to an int and map to the screen height:
   String[] splitted = split(inString,"  ");
  
   if(keyword.equals(splitted[0])) {
     int nAnalog = int(splitted[1]);
     int nDigital = int(splitted[2]);
     int i;
     for(i=0;i<nAnalog;i++)
       analogV[i]=int(splitted[3+i]);
     for(i=0;i<nDigital;i++)
       digitalV[i]=int(splitted[3+nAnalog+i]);

     pushData(digitalV,analogV);
    
  
     drawSerial();
   }
 }
 }
 
 //for test
 void pushRandomData() {
   int[] a={1,2,3};
   int[] b={1,1,1,1};
   if(analogIndex<dataCap/2) {
     b[0]=0;
     b[1]=0;
     b[2]=0;
     b[3]=0;
   } 
   a[0]= analogIndex;
   a[1]= analogIndex+200;
   a[2]= analogIndex/2;
      pushData(b,a);
   
 }
