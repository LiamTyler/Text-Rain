/**
    CSCI 4611 Spring '17 Assignment #1: Text Rain
**/


import processing.video.*;

public class Char {
  public float x;
  public float y;
  public char letter;
  public float speed;
  public color c;

  public Char(int x2, int y2, char l, float s, color cc) {
    x = x2;
    y = y2;
    letter = l;
    speed = s;
    c = cc;
  }

  public void move() {
    int nextcoord = ((int) (y + speed * timestep + tHeight + 1)) * width + (int)x;
    
    if (nextcoord < width * height && brightness(pg.pixels[nextcoord]) >= threshold ||
        nextcoord >= width * height) {
      y = (y + speed * timestep) % height;
    } else {
      int midcoord = ((int) y + tHeight) * width + (int) x;
      int leftcoord = ((int) y + tHeight) * width + (int) (x - tWidth / 2);
      int rightcoord = ((int) y + tHeight) * width + (int) (x + tWidth / 2);

      if (brightness(pg.pixels[leftcoord]) >= threshold && 
          brightness(pg.pixels[midcoord]) >= threshold) {
          y = (y + speed / frameRate * .707) % height;
          x = max(tWidth / 2, x - speed * timestep * 2 * .707);
      } else if (brightness(pg.pixels[rightcoord]) >= threshold && 
                 brightness(pg.pixels[midcoord]) >= threshold) {
          y = (y + speed / frameRate * .707) % height;
          x = min(width - tWidth / 2, x + speed * timestep * 2 * .707);
      }
      resolve();
    }
  }
  
  public void resolve() {
    int coord = ((int) y + tHeight) * width + (int) x;
    while(coord > width && brightness(pg.pixels[coord]) < threshold) {
        coord -= width;
      }
      y = max(0, (coord - (int)x ) / width - tHeight);
  }

  public void draw() {
    pg.fill(c);
    pg.text(letter, x, y);
  }
}


// Global variables for input selection and data
String[] cameras;
Capture cam;
PImage mov;
PImage inputImage;
boolean inputMethodSelected = false;
int startTime;
int frame;
PFont font;
int fontSize;
PGraphics pg;
Char[] myChars;
boolean debug;
int threshold;
int thresholdVelocity; 
int maxCharVel;
int tHeight;
int tWidth;
int time;
float timestep;

void setup() {
  time = 0;
  timestep = 0;
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  debug = false;
  threshold = 128;
  thresholdVelocity = 4; 
  fontSize = 28;
  maxCharVel = 100;
  pg = createGraphics(width, height);
  font = createFont("Georgia", 28);
  textFont(font);
  textSize(fontSize);
  tWidth = (int) textWidth('W');
  tHeight = (int) textAscent();
  myChars = new Char[ width / tWidth - 1];
  int A = (int)'A';
  for(int i = 0; i < myChars.length; i++) {
    myChars[i] = new Char(tWidth * i + tWidth / 2,
                          0,
                          (char)(A + random(26)),
                          20 + random(maxCharVel),
                          color(random(255), random(255), random(255)));
  }
}


void loadFrame() {
  int newFrame = 1 + (millis() - startTime)/100; // get new frame every 0.1 sec
  if (newFrame == frame)
    return;
  frame = newFrame;
  String movieName = "TextRainInput";
  String filePath = movieName + "/" + nf(frame,3) + ".jpg";
  mov = loadImage(filePath);
  if (mov == null) {
    startTime = millis();
    loadFrame();
  }
}

void draw() {
  // When the program first starts, draw a menu of different options for which camera to use for input
  // The input method is selected by pressing a key 0-9 on the keyboard
  if (!inputMethodSelected) {
    cameras = Capture.list();
    int y=40;
    text("0: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
    y += 40; 
    for (int i = 0; i < min(9,cameras.length); i++) {
      text(i+1 + ": " + cameras[i], 20, y);
      y += 40;
    }
    time = millis();
    return;
  }


  // This part of the draw loop gets called after the input selection screen, during normal execution of the program.


  // STEP 1.  Load an image, either from the image sequence or from a live camera feed. Store the result in the inputImage variable
  if (cam != null) {
    if (cam.available())
      cam.read();
    inputImage.copy(cam, 0,0,cam.width,cam.height, 0,0,inputImage.width,inputImage.height);
      pg.beginDraw();

    flipVideo();

  }
  else if (mov != null) {
    loadFrame();
    inputImage.copy(mov, 0,0,mov.width,mov.height, 0,0,inputImage.width,inputImage.height);
      pg.beginDraw();
      copyVideo();

  }
  

  // Fill in your code to implement the rest of TextRain here..
  
  if (debug) {
    debugMode();
  }
  timestep = (millis() - time) / 1000.0;
  time = millis();
  pg.textFont(font, 28);
  pg.textAlign(CENTER, TOP);
  drawObjects();
  
  pg.endDraw();
  image(pg, 0, 0);

}

void drawObjects() {
  pg.fill(255);
  for(int i = 0; i < myChars.length; i++) {
    myChars[i].move();
    myChars[i].draw();
  }
}

void flipVideo() {
  pg.loadPixels();
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      float b = brightness(inputImage.pixels[h * width + width - w - 1]);
      pg.pixels[h * width + w] = color(b,b,b);
    }
  }
  pg.updatePixels();
}

void copyVideo() {
  pg.loadPixels();
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      float b = brightness(inputImage.pixels[h * width + w]);
      pg.pixels[h * width + w] = color(b,b,b);
    }
  }
  pg.updatePixels();
}

void debugMode() {
  pg.loadPixels();
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      color c = pg.pixels[h * width + w];
      float b = brightness(c);
      if (b < threshold) {
      pg.pixels[h * width + w] = color(0, 0, 0);
      } else {
        pg.pixels[h * width + w] = color(255, 255, 255);
      }
    }
  }
  pg.updatePixels();
}

void keyPressed() {
  
  if (!inputMethodSelected) {
    // If we haven't yet selected the input method, then check for 0 to 9 keypresses to select from the input menu
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        println("Offline mode selected.");
        startTime = millis();
        loadFrame();
        inputMethodSelected = true;
      }
      else if ((input >= 1) && (input <= 9)) {
        println("Camera " + input + " selected.");           
        // The camera can be initialized directly using an element from the array returned by list():
        cam = new Capture(this, cameras[input-1]);
        cam.start();
        inputMethodSelected = true;
      }
    }
    return;
  }

  // This part of the keyPressed routine gets called after the input selection screen during normal execution of the program
  // Fill in your code to handle keypresses here..
  
  if (key == CODED) {
    if (keyCode == UP) {
      // up arrow key pressed
      threshold = min(256, threshold + thresholdVelocity);

    }
    else if (keyCode == DOWN) {
      // down arrow key pressed
      threshold = max(0, threshold - thresholdVelocity);

    }
  }
  else if (key == ' ') {
    // space bar pressed
    debug = !debug;

  } 
  
}