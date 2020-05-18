/*
Main idea : 
 - Create a randomizable grid for layout
 - This grid may used the quadtree paradigme (?) / not (?) (find references)
 
 The last time we made : 
 X — Step 1 : Start with a simple squared grid + filled randomization
 X — Step 1.5 : Convert squared grid to rectangular one to filled space
 X — Step 2 : Add some margins
 X — Step 3 : Manipulate the rndRatio on a curve to add more organic/sweat feeling
 X — Step 4 : Back to the photoshop fil to see how we can randomize our poster distribution
 
 Today we cill try to
 #Define a Random  Grid layout Algorithm
 X — 0 - Create a filledCell class which is defines by a position (xy on the grid) and a size in Row/Cols
 X — 1 - We will use row based image per element : Stay, Home, Safe and information
 X — 2 - Each row image we have a 4×1 colsrows
 X — 3 - Define the number of element you want to dispatch on the (grid per element)
 X — 4 - For each, find a place which is available on the grid, place the image, define the place as filled
 (Option) - use a subsize ? Not sure of the layout is we use variable images size (colsrows * 2, *0.5, 0.25...)
 X — 5 - Animate the poster using the shaders from the previous streams
 X - 6 - create vairous ramp to generate random poster
 
 AND IT'S FINISHED :)
 
 Thak you for watching ;)
 
 That will be for the next stream ;)
 */

import fpstracker.core.*;
import gpuimage.core.*;

//main
int owidth = 1428;
int oheight = 2000;
float scale = 0.5;
String datapath;

//grid
int seed            = 2445831;
int numberOfCol     = 12;
int numberOfRow;
int marginLeft      = 100;
int marginRight     = 100;
int marginTop       = 100;
int marginBottom    = 100;
float rndRatio      = 0.25; //25% filled 
ArrayList<Cell> cellsList;

//Rnd layout
PVector filledCellSize;
int numberOfCells;
ArrayList<FilledCell> filledCellList;
FilledCell cellTest;

//Buffers
ArrayList<PImage> imgElementList;
ArrayList<PImage> rampList;
int rampIndex;
PGraphics rawposter;
PImage toplayerImg;
PImage toplayerFixedImg;
Filter toplayer;
PShader topLayerKinetic;
Compositor compositor;
Filter finalposter;

//Exports
int exportLoop = 0;
int numberOfExport = 20;

//debug and control
PerfTracker pt;
boolean pause;
boolean debug;
boolean livecoding;
int actualLoop;

void settings() {
  int width = round(owidth * scale);
  int height = round(oheight * scale);
  size(width, height, P2D);
  smooth(8);
}

void setup() {
  datapath = sketchPath("../data/");
  surface.setLocation(displayWidth - width, -displayHeight*0 + 10);
  pt = new PerfTracker(this, 120);

  rawposter = createGraphics(owidth, oheight, P2D);
  imgElementList = new ArrayList<PImage>();
  for (int i=0; i<3; i++) {
    imgElementList.add(loadImage(datapath+"Elements2/Type-"+i+".bmp"));
  }

  toplayerImg         = loadImage(datapath+"topLayer.bmp");
  toplayerFixedImg    = loadImage(datapath+"topFixedLayer.bmp");
  toplayer            = new Filter(this, toplayerImg.width, toplayerImg.height);
  topLayerKinetic     = loadIncludeFragment(this, datapath+"kinectic.glsl", false);
  topLayerKinetic.set("displacementmap", loadImage(datapath+"Displacement-0.bmp"));

  compositor          = new Compositor(this, toplayerImg.width, toplayerImg.height);

  rampList = new ArrayList<PImage>();
  for (int i=0; i<9; i++) {
    rampList.add(loadImage(datapath+"/Ramps/ramp-"+i+".bmp"));
  }
  rampIndex = round(random(0, rampList.size()-1));
  finalposter     = new Filter(this, toplayerImg.width, toplayerImg.height);

  cellsList = new ArrayList<Cell>();

  int gridWidth   = rawposter.width - (marginLeft + marginRight);
  int gridHeight  = rawposter.height - (marginTop + marginBottom);
  int cellwidth   = gridWidth / numberOfCol; 
  int cellHeight  = gridHeight / numberOfCol;
  numberOfRow = floor(gridHeight / cellHeight);
  PVector gridResolution = new PVector(numberOfCol, numberOfRow);

  for (int r=0; r<numberOfRow; r++) {
    for (int c=0; c<numberOfCol; c++) {
      PVector pos = new PVector(c * cellwidth + cellwidth * 0.5 + marginLeft, //c is col → x
        r * cellHeight + cellHeight * 0.5 + marginTop); //r is row → y//pos from center
      PVector size = new PVector(cellwidth, cellHeight);
      PVector index2D = new PVector(c, r);
      Cell cell = new Cell(pos, size, index2D, gridResolution);
      cellsList.add(cell);
    }
  }


  filledCellList = new ArrayList<FilledCell>();
  PImage imgref = imgElementList.get(0);
  filledCellSize = new PVector(imgref.width/cellwidth, imgref.height/cellHeight);
  numberOfCells = 8;
  spawnCells(numberOfCells, filledCellSize);

  Time.setStartTime(this);


  //define exports
  initFFMPEG(compositor.getBuffer());
}

void draw() {
  Time.update(this, pause);
  Time.computeTimeAnimation(Time.time, 15000.0);

  float nmx = norm(mouseX, 0, width);
  float nmy = norm(mouseY, 0, height);

  //if (actualLoop != Time.timeLoop) {
  //  resetLayout();
  //  actualLoop = Time.timeLoop;
  //} 

  for (FilledCell cell : filledCellList) {
    cell.compute();
  }

  topLayerKinetic.set("time", (float)Time.time / 1000.0, Time.normTime, (float)Time.modTime, (float)Time.timeLoop);
  toplayer.getCustomFilter(toplayerImg, topLayerKinetic);

  rawposter.beginDraw();
  rawposter.background(0);
  for (FilledCell cell : filledCellList) {
    cell.display(rawposter);
  }

  if (debug) {
    for (Cell cell : cellsList) {
      cell.displayDebug(rawposter);
    }
    for (FilledCell cell : filledCellList) {
      cell.displayDebug(rawposter);
    }
  }

  rawposter.endDraw();

  compositor.getBlendAdd(rawposter, toplayer.getBuffer(), 100.0);
  compositor.getBlendAdd(compositor.getBuffer(), toplayerFixedImg, 100.0);

  // finalposter.getRamp1D(compositor.getBuffer(), rampList.get(rampIndex));
  // image(finalposter.getBuffer(), 0, 0, width, height);
  image(compositor.getBuffer(), 0, 0, width, height);


  //infos
  String UI = "Time: "+Time.time+"\n"+
    "Pause: "+pause+"\n"+
    "Livecoding: "+livecoding;
  if (debug) {


    fill(0);
    noStroke();
    rect(0, 0, width, 60);
    fill(255);
    text(UI, 120, 20);
    pt.display(0, 0);
  } else {
    pt.displayOnTopBar("kinectic Poster"+UI);
  }


  exportVideoPerFrame();
}

void keyPressed() {
  switch(key) {
  case 'p':
  case 'P':
    pause = !pause;
    break;
  case 'd':
  case 'D':
    debug = !debug;
    break;
  case 'l':
  case 'L':
    livecoding = !livecoding;
    break;
  case 'r' :
  case 'R' :
    seed = (int)Time.time;
    break;
  case 'i' :
  case 'I' :
    //println("\n");
    resetLayout();
    break;
  case 's':
  case 'S' :
    Time.resetTimeForExport(this);
    resetLayout();
    startExport();
    break;
  }
}



//----------------------- SNIPPETS
void spawnCells(int numberOfCells, PVector cellSize) {
  int numberOfTries = 10;
  for (int i=0; i<numberOfCells; i++) {
    //println("Cell: "+i);
    FilledCell cell = spawnCell(i, cellSize, numberOfTries);
    if (cell != null) {
      filledCellList.add(cell);
    }
  }
  /*
    The main idea is, for each cell
   1 - Define a random place
   2 - check if available
   3 - if not → retry // for retry we can use a while loop but we might be end up in a infinite loop if their is no available space
   So it might be better to use a recursive method with a defined number a try
   4 - else define as a good place, create the cell, define the place as filled
   
   Comment:
   A better algorithm will be to define a random filledCell position by taking only available cell and 
   check if there is no overlaps... Using this method we will have the cells 0, 1, 2, 3... instead of 0, 1, 2, 6
   But I kind of like this randomness
   */
}

FilledCell spawnCell(int index, PVector cellSize, int numberOfTries) {
  //println("\tTry: "+numberOfTries);
  //Define a algorithm to fond the random position inside the grid
  int randomCol   = round(random(0, numberOfCol-cellSize.x));//pick a random value between 0 and the number of Col available
  int randomRow   = round(random(0, numberOfRow-cellSize.y));//do the same for row
  int topLeftIndex       = randomCol + randomRow * numberOfCol;//convert from 2D coordinate to 1D coordinate

  //check if place is available
  boolean available = true;
  for (int r=0; r<cellSize.y; r++) {
    for (int c=0; c<cellSize.x; c++) {
      int cellindex = (c + randomCol) + (r + randomRow) * numberOfCol; //from 2D to 1D is x + y * width
      if (cellsList.get(cellindex).filled) {
        available = false;
      }
    }
  }

  if (available == true) {
    Cell ref = cellsList.get(topLeftIndex);
    int rndImageIndex = round(random(0, imgElementList.size()-1));
    FilledCell cell = new FilledCell(this, index, ref, cellSize, imgElementList.get(rndImageIndex));//Cell ref, Vector iSize

    //when cell is created, define the cells on the grid as picked
    for (int r=0; r<cellSize.y; r++) {
      for (int c=0; c<cellSize.x; c++) {
        int cellindex = (c + randomCol) + (r + randomRow) * numberOfCol; //from 2D to 1D is x + y * width
        cellsList.get(cellindex).filled = true;
      }
    }

    return cell;
  } else {
    if (numberOfTries <= 0) {
      return null;
    } else {
      numberOfTries --;
      return spawnCell(index, cellSize, numberOfTries);
    }
  }
}

void resetLayout() {
  seed = (int)Time.time; //redefine seed beacuase we use a fixed one all along the sketch
  filledCellList.clear();
  for (Cell cell : cellsList) {
    cell.filled = false;
  }
  spawnCells(numberOfCells, filledCellSize);
  rampIndex = round(random(0, rampList.size()-1));
}


float fract(float x) {
  //return the fractional part of a number
  return x - floor(x);
}
