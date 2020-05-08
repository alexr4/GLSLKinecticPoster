import fpstracker.core.*;
import gpuimage.core.*;

PerfTracker pt;
int owidth = 1428;
int oheight = 2000;
float scale = 0.5;
String datapath;

//Buffers, Filters and Compositor
int nbOfLayers;
int TYPE = 0;
String define = "#define TYPE ";
ArrayList<String> paramsFrag;
PVector keymap;
PImage poster;
ArrayList<PImage> postersList;
ArrayList<Filter> filterlist;
ArrayList<PShader> shaderList;
ArrayList<PImage> displacementList;
Filter finalBuffer;
Compositor comp;
PImage ramp;
PVector[] minmaxSpeed = {
    new PVector(1.0, 1.0),
    new PVector(0.985, 1.0),
    new PVector(0.9, 1.0),
    new PVector(0.85, 1.0),
    new PVector(0.9, 1.0)
};


//debug
boolean pause;
boolean debug;
boolean livecoding;

void settings(){
    int width = round(owidth * scale);
    int height = round(oheight * scale);
    size(width, height, P2D);
    smooth(8);
}

void setup(){
    datapath = sketchPath("../data/");
    surface.setLocation(displayWidth - width, -displayHeight*1 + 10);
    pt = new PerfTracker(this, 120);

    postersList = new ArrayList<PImage>();
    for(int i=0; i<4; i++){
        postersList.add(loadImage(datapath+"SimpleLetter/Letter-"+i+".bmp"));
    }
    poster = postersList.get(0);
    comp = new Compositor(this, owidth, oheight);
    finalBuffer = new Filter(this, owidth, oheight);
    filterlist = new ArrayList<Filter>();
    shaderList = new ArrayList<PShader>();
    displacementList = new ArrayList<PImage>();
    nbOfLayers = 1;
    paramsFrag = new ArrayList<String>();
    paramsFrag.add(define+TYPE);
    for(int i=0; i<nbOfLayers; i++){
        filterlist.add(new Filter(this, owidth, oheight));
        shaderList.add(loadIncludeFragment(this, datapath+"kinecticBase.glsl", false, paramsFrag));
        displacementList.add(loadImage(datapath+"SimpleLetter/displacementMap.bmp"));
    }
    keymap = new PVector(-1, 0, 1.0);
    ramp = loadImage(datapath+"ramp-1.png");

    Time.setStartTime(this);
}

void draw(){
    Time.update(this, pause);
    Time.computeTimeAnimation(Time.time, 4000.0);

    float nmx = norm(mouseX, 0, width);
    float nmy = norm(mouseY, 0, height);

    try{
        if(livecoding){
            shaderList.clear();
            paramsFrag.clear();
            paramsFrag.add(define+TYPE);
            for(int i=0; i<nbOfLayers; i++){
                shaderList.add(loadIncludeFragment(this, datapath+"kinecticBase.glsl", false, paramsFrag));
            }
        }


        //animation per layer
        randomSeed(1000);
        for(int i=0; i<filterlist.size(); i++){
            Filter filter = filterlist.get(i);
            PShader shader = shaderList.get(i);

            shader.set("displacementmap", displacementList.get(i));
            shader.set("minSpeed", minmaxSpeed[i].x);
            shader.set("maxSpeed", minmaxSpeed[i].y);
            shader.set("offset", random(10000.0));
            shader.set("mouse", nmx, nmy);
            shader.set("time", (float)Time.time / 1000.0, Time.normTime, (float)Time.modTime, (float)Time.timeLoop);
            shader.set("keymap", keymap.x, keymap.y, keymap.z);
            
            filter.getCustomFilter(poster, shader);
        }

        // comp.getBlendAdd(filterlist.get(1).getBuffer(), filterlist.get(0).getBuffer(), 100);
        // for(int i=2; i<filterlist.size(); i++){
        //     comp.getBlendAdd(filterlist.get(i).getBuffer(), comp.getBuffer(), 100);
        // }

        finalBuffer.getRamp1D(filterlist.get(0).getBuffer(), ramp);

    }catch(Exception e){
        e.printStackTrace();
    }

    background(127);
    image(filterlist.get(0).getBuffer(), 0, 0, width, height);

    String UI = "Time: "+Time.time+"\n"+
                "Pause: "+pause+"\n"+
                "Livecoding: "+livecoding;
    String UI2 = "TYPE: "+TYPE+"\n";

    if(debug){

        fill(0);
        noStroke();
        rect(0,0, width, 60);
        fill(255);
        text(UI, 120, 20);
        text(UI2, 120 * 2, 20);
        pt.display(0, 0);

    }else{
        pt.displayOnTopBar("kinectic Poster"+UI);
    }
}

void keyPressed(){
    switch(key){
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
        case 'r':
        case 'R':
            Time.resetTimeForExport(this);
        break;
        case '0':
            poster = postersList.get(0);
        break; 
        case '1':
            poster = postersList.get(1);
        break; 
        case '2':
            poster = postersList.get(2);
        break; 
        case '3':
            poster = postersList.get(3);
        break; 
        case '+':
            TYPE ++;
        break; 
        case '-':
            if(TYPE > 0)
                TYPE --;
        break; 
    }
     switch(keyCode){
         case LEFT :
            println("X++");
            keymap.x = 1.0;
            keymap.y = 0.0;
         break;
         case RIGHT :
            println("X--");
            keymap.x = -1.0;
            keymap.y = 0.0;
         break;
         case UP :
            println("Y++");
            keymap.y = 1.0;
            keymap.x = 0.0;
         break;
         case DOWN :
            println("Y--");
            keymap.y = -1.0;
            keymap.x = 0.0;
         break;
         case 10 :
         break;
     }
}
