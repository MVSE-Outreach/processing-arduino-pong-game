import ddf.minim.*;
import processing.serial.*;

Serial arduino;
Minim minim;
AudioPlayer wallSound, batSound;
PImage ballImage, batImage, back;
int batPosition;
int command;
int currentScore = 1;
ArrayList balls;

void setup()
{
  size(960,720,P2D);
  connectToArduinoWin();
  imageMode(CENTER);
  textSize(20);
  ballImage = loadImage("ball.png");
  batImage = loadImage("bat.png");
  back = loadImage("back.png");
  minim = new Minim(this);
  wallSound = minim.loadFile("wall.mp3");
  batSound = minim.loadFile("bat.mp3");
  batPosition = batImage.width/2;
  balls = new ArrayList();
  for(int i=0; i<3; i++) {
    Ball nextBall = new Ball();
    balls.add(nextBall);
    nextBall.resetBall();
  }
}

void draw()
{
  image(back,width/2,height/2,width,height);
  text("Score: " + currentScore, 10, 20);
  updateBatPosition();
  drawBat();
  for(int i=0; i<balls.size(); i++) {
    Ball nextBall = (Ball)balls.get(i);
    nextBall.updateBallPosition();
    nextBall.drawBall();
    nextBall.checkForCollision();
  }
}

void updateBatPosition()
{
  if((arduino != null) && (arduino.available()>0)) {
    command = arduino.read();
    if(command == 'z') batPosition = batPosition - 8;
    else if(command == 'x') batPosition = batPosition + 8;
  }
  if(key == 'z') batPosition = batPosition - 8;
  if(key == 'x') batPosition = batPosition + 8;
  if(mousePressed && (mouseX<width/2)) batPosition = batPosition - 8;
  if(mousePressed && (mouseX>width/2)) batPosition = batPosition + 8;

  // Stop the bat from going off the edge of the screen !
  if(batPosition>width) batPosition = width;
  if(batPosition<0) batPosition = 0;
}

void drawBat()
{
  image(batImage,batPosition,height-batImage.height);
}