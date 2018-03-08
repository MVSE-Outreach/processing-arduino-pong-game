void stop()
{
  arduino.stop();
}

void connectToArduinoWin()
{
  // If trouble connecting, hardwire serial device name below
  try {
    // Usually the last serial device !
    String[] ports = Serial.list();
    arduino = new Serial(this, ports[ports.length-1], 9600);
  } catch(Exception e) {
    // println("Cannot connect to Arduino !");
  }
}

void connectToArduinoMac()
{
  // If trouble connecting, hardwire serial device name below
  try {
    for(int i=0; i<Serial.list().length ;i++) {
      if(Serial.list()[i].contains("tty.usb")) {
        arduino = new Serial(this, Serial.list()[i], 9600);
      }
    }
  } catch(Exception e) {
    // println("Cannot connect to Arduino !");
  }
}