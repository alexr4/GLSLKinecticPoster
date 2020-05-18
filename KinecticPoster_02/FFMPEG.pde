import com.hamoid.*;

VideoExport videoExport;
ControlledTime videoTime;
String pre;

static class FFMPEGParams {
  static boolean export = false;
  static String filename = "StopCovid-BW-";
  static int exportTime = 1000 * 15;
  static int videoQuality = 80;
  static int audioQuality = 16;
  static int FPS = 60;
  static boolean debugOutput = false;
  static int startFrame;
  static int maxFrame;
}

void initFFMPEG(PGraphics target) {
  pre = year()+""+month()+""+day()+"_";//+"-"+hour()+""+minute()+""+second()+"_";
  videoTime = new ControlledTime();
  videoExport = new VideoExport(this, "export/"+pre+FFMPEGParams.filename+exportLoop+".mp4", target); 
  videoExport.setQuality(FFMPEGParams.videoQuality, FFMPEGParams.audioQuality);
  videoExport.setFrameRate(FFMPEGParams.FPS);
  videoExport.setDebugging(FFMPEGParams.debugOutput);

  FFMPEGParams.maxFrame = floor(FFMPEGParams.exportTime / 1000.0) * FFMPEGParams.FPS;
}

void startExport() {
  if (!FFMPEGParams.export) {
    FFMPEGParams.startFrame = frameCount;
    FFMPEGParams.export = true;
    Time.resetTimeForExport(this);
    videoTime.resetTimeForExport();
    videoExport.setMovieFileName(pre+FFMPEGParams.filename+exportLoop+".mp4");

    videoExport.startMovie();
  }
}

void exportVideo() {
  if (FFMPEGParams.export) {
    videoTime.update(false);
    videoTime.computeTimeAnimation(FFMPEGParams.exportTime);
    if (videoTime.timeLoop == 0) {
      videoExport.saveFrame();
    } else {
      videoExport.endMovie();
      FFMPEGParams.export = false;
    }
    String uiExportProgress = "FFMPEG export: "+round(videoTime.normTime * 100)+"%";
    float headerWidth = width;
    float headerHeight = height/10;
    float progressWidth = width * 0.95;
    float pogressHeight = headerHeight * 0.15;
    float yOffset = 10;
    color headerColor = color(255, 200, 0);
    color progressColor = color(255, 127, 0);

    pushStyle();
    fill(headerColor);
    noStroke();
    rectMode(CENTER);
    rect(width/2, height/2, headerWidth, headerHeight);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(uiExportProgress, width/2, height/2 - yOffset);
    stroke(progressColor);
    noFill();
    rect(width/2, height/2 + yOffset, progressWidth, pogressHeight);
    fill(progressColor);
    noStroke();
    rect(width/2, height/2 + yOffset, progressWidth * videoTime.normTime, pogressHeight);
    popStyle();
  }
}

void exportVideoPerFrame() {
  if (FFMPEGParams.export) {

    float normFrameCount = float(frameCount - FFMPEGParams.startFrame) / float(FFMPEGParams.maxFrame);
    println(normFrameCount, float(frameCount - FFMPEGParams.startFrame), float(FFMPEGParams.maxFrame));
    if (frameCount - FFMPEGParams.startFrame < FFMPEGParams.maxFrame) {
      videoExport.saveFrame();
    } else {
      videoExport.endMovie();
      FFMPEGParams.export = false;

      if (numberOfExport > 0) {
        exportLoop ++;
        Time.resetTimeForExport(this);
        resetLayout();
        startExport();
        numberOfExport --;
      }
    }

    String uiExportProgress = "FFMPEG export: "+round(normFrameCount * 100)+"%";
    float headerWidth = width;
    float headerHeight = height/10;
    float progressWidth = width * 0.95;
    float pogressHeight = headerHeight * 0.15;
    float yOffset = 10;
    color headerColor = color(255, 200, 0);
    color progressColor = color(255, 127, 0);

    pushStyle();
    fill(headerColor);
    noStroke();
    rectMode(CENTER);
    rect(width/2, height/2, headerWidth, headerHeight);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(uiExportProgress, width/2, height/2 - yOffset);
    stroke(progressColor);
    noFill();
    rect(width/2, height/2 + yOffset, progressWidth, pogressHeight);
    fill(progressColor);
    noStroke();
    rect(width/2, height/2 + yOffset, progressWidth * normFrameCount, pogressHeight);
    popStyle();
  }
}
