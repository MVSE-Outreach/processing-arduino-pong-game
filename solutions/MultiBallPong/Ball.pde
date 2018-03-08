public class Ball
{
  float ballX, ballY;
  float vertSpeed, horiSpeed;
  
  void resetBall()
  {
    ballX = random(20,width-20);
    ballY = 200;
    vertSpeed = 3;
    horiSpeed = random(-3, 3);
  }

  void updateBallPosition()
  {
    ballX = ballX + horiSpeed;
    ballY = ballY + vertSpeed;
    if (ballY >= height) resetBall();
    if (ballY <= 0) ceilingBounce();
    if (ballX >= width) wallBounce();
    if (ballX <= 0) wallBounce();
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
    pushMatrix();
    translate(ballX, ballY);
    if (vertSpeed > 0) rotate(-sin(horiSpeed/vertSpeed));
    else rotate(PI-sin(horiSpeed/vertSpeed));
    image(ballImage, 0, 0);
    popMatrix();
  }

  void checkForCollision()
  {
    if (batTouchingBall()) {
      float distFromBatCenter = batPosition-ballX;
      horiSpeed = -distFromBatCenter/10;
      vertSpeed = -vertSpeed;
      ballY = height-(batImage.height*2);
      batSound.rewind();
      batSound.play();
    }
  }
  
  boolean batTouchingBall()
  {
    float batHeight = batImage.height;
    float distFromBatCenter = batPosition-ballX;
    return (ballY>height-(batHeight*2)) && (ballY<height-(batHeight/2)) && (abs(distFromBatCenter)<batImage.width/2);
  }
  
}