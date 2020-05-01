import fpstracker.core.*;

PerfTracker pt;
int owidth = 1428;
int oheight = 2000;
float scale = 0.5;

//Buffers
PGraphics buffer;
PImage poster;
PImage displacementMap;
PImage speedMap;
PShader kinecticsh;


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
    surface.setLocation(displayWidth - width, -displayHeight + 10);
    pt = new PerfTracker(this, 120);

    buffer = createGraphics(owidth, oheight, P2D);
    kinecticsh = loadIncludeFragment(this, "kinectic.glsl", false);
    poster = loadImage("20200429-StopCovid.png");
    displacementMap = loadImage("displacementMap-32-4.bmp");
    speedMap = loadImage("speedMap-5.bmp");

    Time.setStartTime(this);
}

void draw(){
    Time.update(this, pause);
    Time.computeTimeAnimation(Time.time, 4000.0);

    float nmx = norm(mouseX, 0, width);
    float nmy = norm(mouseY, 0, height);

    try{
        if(livecoding){
            //reload the shader
            kinecticsh = loadIncludeFragment(this, "kinectic.glsl", false);
        }

        //use the shader
        kinecticsh.set("time", (float)Time.time / 1000.0, Time.normTime, (float)Time.modTime, (float)Time.timeLoop);
        kinecticsh.set("displacementMap", displacementMap);
        kinecticsh.set("speedMap", speedMap);
        kinecticsh.set("mouse",nmx, nmy);

        buffer.beginDraw();
        buffer.shader(kinecticsh);
        buffer.image(poster, 0, 0, buffer.width, buffer.height);
        buffer.endDraw();

    }catch(Exception e){
        e.printStackTrace();
    }

    background(127);
    image(buffer, 0, 0, width, height);

    String UI = "Time: "+Time.time+"\n"+
                "Pause: "+pause+"\n"+
                "Livecoding: "+livecoding;
    if(debug){

        fill(0);
        noStroke();
        rect(0,0, width, 60);
        fill(255);
        text(UI, 120, 20);
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
    }
}