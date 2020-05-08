class Cell{
    public PVector index2D;
    public PVector normalIndex2D;
    public PVector gridResolution;
    public PVector position;
    public PVector size;
    boolean filled;

    Cell(PVector position, PVector size, PVector index2D, PVector gridResolution){
        this.position = position;
        this.size = size;
        this.index2D = index2D;
        this.gridResolution = gridResolution;
        this.normalIndex2D = new PVector(this.index2D.x / this.gridResolution.x,
                                        this.index2D.y / this.gridResolution.y);
    }

    public void displayDebug(PGraphics b){ //b as a target bufferX — 
        int grey = filled ? 255 : 50;
        b.fill(127, 50);
        b.stroke(0);
        b.rectMode(CENTER);
        b.rect(this.position.x, this.position.y, this.size.x, this.size.y);
        b.noStroke();
        b.fill(0);
        b.textAlign(CENTER);
        b.text(floor(index2D.x) + ":" + floor(index2D.y), this.position.x, this.position.y);
    }
}