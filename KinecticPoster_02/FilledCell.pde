class FilledCell{
    int index;
    PVector position;
    PVector size;
    PVector iPosition; //position described as a 2D cell index coordinated on the grid
    PVector iSize;// position described as a 2D cell size on the grid
    Cell topLeftReference;

    //Design
    Filter buffer;
    PShader kinetic;
    PImage img;
    
    //Debug
    color debug;

    FilledCell(PApplet ctx, int index, Cell ref, PVector iSize, PImage img){
        this.index = index;
        topLeftReference = ref;
        this.iPosition = this.topLeftReference.index2D.copy();
        this.iSize = iSize;

        this.position = topLeftReference.position.copy().sub(topLeftReference.size.copy().div(2));
        this.size = new PVector(topLeftReference.size.x * iSize.x, 
                                topLeftReference.size.y * iSize.y);

        this.img = img;
        this.buffer = new Filter(ctx, this.img.width, this.img.height);
        
        ArrayList<String> paramsFrag = new ArrayList<String>();
        int TYPE = round(random(0, 14));
        paramsFrag.add("#define TYPE "+TYPE);
        this.kinetic   = loadIncludeFragment(ctx, datapath+"kinecticBase2.glsl", false, paramsFrag);
        PVector dirmap  = new PVector();
        float rndDirXY  = random(1.0);
        float rndDir    = random(1.0);
        if(rndDirXY > 0.5){
            if(rndDir > 0.5){
                dirmap.x = 1.0;
            }else{
                dirmap.x = -1.0;
            }
        }else{
            if(rndDir > 0.5){
                dirmap.y = 1.0;
            }else{
                dirmap.y = -1.0;
            }
        }
        kinetic.set("dirmap", dirmap.x, dirmap.y);
        kinetic.set("offset", random(10000.0));
        if(TYPE == 2 || TYPE == 3 || TYPE == 4 || TYPE == 7 || TYPE == 9 ||
         TYPE == 10 || TYPE == 11 || TYPE == 12 || TYPE == 13 || TYPE == 14){
             kinetic.set("isTimeAnimated", (float) round(random(1.0)));
         }
        

        debug = color(random(255), random(255), random(255));
    }

    public void compute(){
        this.kinetic.set("time", (float)Time.time / 1000.0, Time.normTime, (float)Time.modTime, (float)Time.timeLoop);
        this.buffer.getCustomFilter(this.img, this.kinetic);
    }

    public void displayDebug(PGraphics b){ //b as a target buffer X
        b.fill(debug, 50);
        b.stroke(0);
        b.rectMode(CORNER);
        b.rect(this.position.x, this.position.y, this.size.x, this.size.y);
        b.fill(0);
        b.textAlign(LEFT);
        b.text(index, this.position.x + this.size.x * 0.1, this.position.y + this.size.y * 0.1);
    }

    public void display(PGraphics b){
        b.imageMode(CORNER);
        b.image(this.buffer.getBuffer(), this.position.x, this.position.y, this.size.x, this.size.y);
    }
}