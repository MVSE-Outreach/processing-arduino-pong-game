void setup()
{
  pinMode(A6,INPUT);
  Serial.begin(9600);
}

void loop()
{
  // analog read returns a value up to 1024, must divide by 4 to reduce it to a char for sending !
  char current = analogRead(A6)/4;
  Serial.write(current);
  delay(50);
}
 
