import ddf.minim.*;
import processing.serial.*;

Serial arduino;
Minim minim;
AudioPlayer wallSound, batSound;
PImage ball, bat, back;
int batPosition;
float ballX, ballY;
float vertSpeed, horiSpeed;
int command;
int currentScore = 1;

void setup()
{
  size(960,720,P2D);
  connectToArduinoWin();
  imageMode(CENTER);
  textSize(20);
  ball = loadImage("ball.png");
  bat = loadImage("bat.png");
  back = loadImage("back.png");
  minim = new Minim(this);
  wallSound = minim.loadFile("wall.mp3");
  batSound = minim.loadFile("bat.mp3");
  batPosition = bat.width/2;
  resetBall();
}

void resetBall()
{
  // EXTENSION...
  // Keep track of the score - loose a point each reset
  currentScore--;
  ballX = 20;
  ballY = 200;
  // EXTENSION...
  // Only start off slowly to allow acceleration due to gravity  
  vertSpeed = 0;
  horiSpeed = random(-6,6);
}

void draw()
{
  image(back,width/2,height/2,width,height);
  text("Score: " + currentScore, 10, 20);
  updateBatPosition();
  drawBat();
  updateBallPosition();
  drawBall();
  checkForCollision();
}

void updateBatPosition()
{
  if((arduino != null) && (arduino.available()>0)) {
    command = arduino.read();
    if(command == 'z') batPosition = batPosition - 8;
    else if(command == 'x') batPosition = batPosition + 8;
    // EXTENSION...
    // Read in the byte value from the potentiometer
    // Need to scale up the value from a 1 byte char to cover the whole width of screen
    batPosition = command * 4;
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
  image(bat,batPosition,height-bat.height);
}

void updateBallPosition()
{
  ballX = ballX + horiSpeed;
  ballY = ballY + vertSpeed;
  // EXTENSION...
  // Keep on increasing the vertical speed to simulate the effects of gravity
  vertSpeed+=0.15;
  if(ballY >= height) resetBall();
  if(ballY <= 0) ceilingBounce();
  if(ballX >= width) wallBounce();
  if(ballX <= 0) wallBounce();
}

void wallBounce()
{
  horiSpeed = -horiSpeed;
  wallSound.rewind();
  wallSound.play();
}

void ceilingBounce()
{
  vertSpeed = -vertSpeed;
  wallSound.rewind();
  wallSound.play();
}

void drawBall()
{
  translate(ballX,ballY);
  if(vertSpeed > 0) rotate(-sin(horiSpeed/vertSpeed));
  else rotate(PI-sin(horiSpeed/vertSpeed));
  image(ball,0,0);
}

void checkForCollision()
{
  if(batTouchingBall()) {
    // EXTENSION...
    // Keep track of the score - gain a point each hit !
    currentScore++;

    // EXTENSION...
    // Increase the speed of the ball slightly each time it is hit
    vertSpeed = vertSpeed * 1.1;
    horiSpeed = horiSpeed * 1.1;
    float distFromBatCenter = batPosition-ballX;
    horiSpeed = -distFromBatCenter/10;
    vertSpeed = -vertSpeed;
    ballY = height-(bat.height*2);
    batSound.rewind();
    batSound.play();
  }
}

boolean batTouchingBall()
{
  float distFromBatCenter = batPosition-ballX;
  return (ballY>height-(bat.height*2)) && (ballY<height-(bat.height/2)) && (abs(distFromBatCenter)<bat.width/2);
}