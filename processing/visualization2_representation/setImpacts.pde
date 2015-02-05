


public void event1_generateR( Fluid2D fluid2d,int r,int g, int b) {
  //println(fluid2d.getSizeXTotal());
   setDens(fluid2d, int(random(0,2200)), int(random(0,1400)), int(random(4,10)), int(random(4,10)), r, g, b);
}

public void event2_generate( Fluid2D fluid2d,int a1,int a2,int a3) {
  //println(fluid2d.getSizeXTotal());
  if(a3>500) fluid2d.addVelocity(55, 170, 0, a3*(-1)*0.003f);
  fluid2d.addVelocity(190, 30, a2*(-1)*0.005f, a2*0.003f);  
  fluid2d.addVelocity(5, 35, a1*0.005f,a1*0.001f);
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fluidInfluence();
//
public void fluidInfluence( Fluid2D fluid2d ) {
  if (mouseButton == LEFT ) {
    if ( edit_quader) {
      int quader_size = 4;
      int xpos = (int)(mouseX/(float)cell_size) - quader_size/2;
      int ypos = (int)(mouseY/(float)cell_size) - quader_size/2;
      addObject(fluid2d, xpos, ypos, quader_size, quader_size, 0);
    } 
    else {
      setDens(fluid2d, mouseX, mouseY, 5, 5, 2, 2, 2);
    }
  }
  if (mouseButton == CENTER ) {
    if ( edit_quader ) {
      int quader_size = 4;
      int xpos = (int)(mouseX/(float)cell_size) - quader_size/2;
      int ypos = (int)(mouseY/(float)cell_size) - quader_size/2;
      addObject(fluid2d, xpos, ypos, quader_size, quader_size, 1);
    } 
    else {
      setDens(fluid2d, mouseX, mouseY, 5, 5, 2, 0, 0);
    }
  }
  if (mouseButton == RIGHT ) {
    float vel_fac = 0.13f;
    int size = (int)(((fluid_size_x+fluid_size_y)/2.0) / 70.0);
    size = max(size, 1);
    setVel(fluid2d, mouseX, mouseY, size, size, (mouseX - pmouseX)*vel_fac, (mouseY - pmouseY)*vel_fac);
  }
}    


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// setDens();
//
void setDens(Fluid2D fluid2d, int x, int y, int sizex, int sizey, float r, float g, float b) {
  for (int y1 = 0; y1 < sizey; y1++) {
    for (int x1 = 0; x1 < sizex; x1++) {
      //int xpos = (int)(x/(float)cell_size) + x1 - sizex/2;
      //int ypos = (int)(y/(float)cell_size) + y1 - sizey/2;
      int xpos = (int)(x/(float)cell_size) + x1 - sizex/2;
      int ypos = (int)(y/(float)cell_size) + y1 - sizey/2;
      //int xpos=x;
      //int ypos=y;
      fluid2d.addDensity(0, xpos, ypos, r);
      fluid2d.addDensity(1, xpos, ypos, g);
      fluid2d.addDensity(2, xpos, ypos, b);
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// setVel();
//
void setVel(Fluid2D fluid2d, int x, int y, int sizex, int sizey, float velx, float vely) {
  for (int y1 = 0; y1 < sizey; y1++) {
    for (int x1 = 0; x1 < sizex; x1++) {
      int xpos = (int)((x/(float)cell_size)) + x1 - sizex/2;
      int ypos = (int)((y/(float)cell_size)) + y1 - sizey/2;
      fluid2d.addVelocity(xpos, ypos, velx, vely);
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// addObject();
//
public void addObject(Fluid2D fluid2d, int posx, int posy, int sizex, int sizey, int mode) {
  int offset = 0;
  int xlow = posx;
  int xhig = posx + sizex;
  int ylow = posy;
  int yhig = posy + sizey;

  for (int x = xlow-offset ; x < xhig+offset ; x++) {
    for (int y = ylow-offset ; y < yhig+offset ; y++) {
      if ( x < 0 || x >= fluid2d.getSizeXTotal() || y < 0 || y >= fluid2d.getSizeYTotal() )
        continue;
      if ( mode == 0) fluid2d.addObject(x, y); 
      if ( mode == 1) fluid2d.removeObject(x, y);
    }
  }
}

