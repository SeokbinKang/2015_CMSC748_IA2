//------------------------------------------------------------------------------
//
// author: Seokbin Kang
// date: 2/4/2015
//
// Fluid simulation with digital and analog inputs. 
// digital0 to digital3 signals are mapped to randomly generated color patches
// analog0 to analog2 signals are mapped to three specific fluid force.

//
//------------------------------------------------------------------------------

 import processing.serial.*;
import processing.opengl.*;
//import codeanticode.glgraphics.*;
import diewald_fluid.Fluid2D;
import diewald_fluid.Fluid2D_CPU;
import diewald_fluid.Fluid2D_GPU;

int  CPU_GPU        = 1; // 0 is GPU, 1 is CPU;
int  cell_size      = 9;
int  fluid_size_x   =240;
int  fluid_size_y   = 180;
int  window_size_x  = fluid_size_x  * cell_size + (cell_size * 2);
int  window_size_y  = fluid_size_y  * cell_size + (cell_size * 2);
boolean edit_quader = false;

Fluid2D fluid;
PImage output_densityMap, input_density_values;
PFont font;
color[] analogColor =  {#2ecc71,#e67e22,#9b59b6,#3498db};
String[] analogLegend= {"A1","A2","A3"};
 Serial myPort;    
int mResetTimer=2000;
int mLastReset=0;

//initialize
public void setup() {
  window_size_x=1200;
  window_size_y=900;
  if ( CPU_GPU == 0 ){
    size(window_size_x, window_size_y, GLConstants.GLGRAPHICS);
  }
  if ( CPU_GPU == 1 ){
      size(window_size_x, window_size_y, JAVA2D);
  }

  input_density_values = loadImage("starrynight_1600x1200.jpg");
  output_densityMap    = createImage(window_size_x, window_size_y, RGB);

  fluid = createFluidSolver(CPU_GPU);
  reset(fluid);

  frameRate(60);
  font = loadFont("FranklinGothic-Heavy-20.vlw");
   
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
}



//draw fluid simulation
public void draw() {
  background(255);
  if ( mousePressed ) fluidInfluence(fluid);

  //for(int y = 5; y < height; y+=10)
   // setVel(fluid, 10*cell_size, 15*cell_size, 3, 3, 0.1f, 0);

  fluid.smoothDensityMap(!( keyPressed && key == 's'));

  if ( !(keyPressed && key == ' ') ) 
    fluid.update();

  image(fluid.getDensityMap(), 0, 0);
  
  textFont(font, 20);
  fill(analogColor[0]);
  text(analogLegend[0],25,185);
  fill(analogColor[1]);
  text(analogLegend[1],950,150);
  fill(analogColor[2]);
  text(analogLegend[2],275,850);
  
  
  //println(frameRate);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void keyPressed() {
  if ( key == 'y') edit_quader = true;
  if (key=='e') event1_generateR(fluid,1,0,0);
  if (key=='g') event1_generateR(fluid,0,1,0);
  if (key=='b') event1_generateR(fluid,0,0,1);
  if (key=='w') event1_generateR(fluid,1,1,1);
  if (key=='[') event2_generate(fluid,300,300,300);
  
}


public void keyReleased() {
  edit_quader = false;
  if ( key == 'r') reset(fluid);
}


//processing received digital and analog data
 void serialEvent (Serial myPort) {
 // get serial stream from Arduino
 

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

  
  
  //map each data to visualization event
     if(digitalV[0]>0) event1_generateR(fluid,1,0,0);
     if(digitalV[1]>0) event1_generateR(fluid,0,1,0);
     if(digitalV[2]>0) event1_generateR(fluid,0,0,1);
     if(digitalV[3]>0) event1_generateR(fluid,1,1,1);
     event2_generate(fluid,analogV[0],analogV[1],analogV[2]);
   }
   
   
   
   
   
    
   }
   
 }


