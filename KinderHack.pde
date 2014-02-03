/*
 * Dear Adiel
 *
 *  The missing assets are here:
 *   https://www.dropbox.com/sh/sl7pk6i8ljmw7ec/BZ2ZIZu5LH
 *  Also, I love you.
 *   
 *  Anthony
 */

import spacebrew.*;

String server="54.201.24.223";
String name="Game Client";
String description ="LOLGAMEZ";
float timer = 6000;
float timeW;
float timeMark;
color timeC = color(0, 255, 0);
int player = 0;
color pColor;
int qNum = 0;
boolean active = false;

Spacebrew sb;

// Keep track of our current place in the range
String local_string = "";
String remote_string = "";
String last_string = "";

void setup() {
  size(1024, 768);
  background(0);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "Output", "string", local_string ); 

  // declare your subscribers
  sb.addSubscribe( "Input", "string" );

  // connect!
  sb.connect(server, name, description );
}

void draw() {
  if (!active) {
    background(150, 150, 150);
  } 
  else {
    if (player==1) pColor = color(255, 0, 0);
    if (player==2) pColor = color(0, 0, 255);
    background(pColor);
  }
  fill(255);
  stroke(250);

  // draw lines
  line(0, 35, width - 60, 35);
  line(30, 95, width, 95);

  // draw instruction text
  text("Type messages up to 50 chars long and hit return to send so Spacebrew. ", 30, 20);  

  // draw message being typed
  text("Type Message: ", 30, 60);  
  text(local_string, 150, 60);  

  // draw message that was just sent
  text("Message Sent: ", 30, 80);  
  text(last_string, 150, 80);  

  // draw latest received message
  text("Message Received: ", 30, 120);  
  text("Player: " + player + " qNum: " + qNum, 150, 120);


  //PROTOCODE
  if (active) {
    switch(qNum) {
    case 1:
      break;

    case 2:
      break;

    case 3:
      break;

    case 4:
      break;

    case 5:
      break;

    case 6:
      break;

    case 7:
      break;

    case 8:
      break;

    case 9:
      break;

    case 10:
      break;

    case 11:
      //LOL U WIN
      break;
    }

 // TIMER. THIS IS THE TIMER. IT TIMES
    if (millis()-timeMark<timer) {
      pushStyle();
      timeW=map(millis(), timeMark, timeMark+timer, width, 0);
      println(timeW);
      float temp = map(millis(), timeMark, timeMark+timer, 0, 1);
      color from = color(0, 255, 0);
      color to = color(255, 0, 0);
      timeC=lerpColor(from, to, temp);
      fill(timeC);
      rectMode(CENTER);
      rect(width/2, height/2, timeW, 100);
      rectMode(CORNER);
      popStyle();  
      
      
      // Check input

      //Send
    }
    else {
      active = false;
      println("DONE");
    }
  }
}

void keyPressed() {

  //IDIOT DEBUG OPTION
  if (key=='1') {
    timeMark=millis();
    println("TIMER SET AT: " +timeMark);
    active=true;
  }
  /////////////////////

  if (key != CODED) {
    if (key == DELETE || key == BACKSPACE) {
      if (local_string.length() - 1 >= 0) {
        local_string = local_string.substring(0, (local_string.length() - 1));
      }
    }

    else if (key == ENTER || key == RETURN) {
      sb.send("listen_to_me", local_string);
      last_string = local_string;
      local_string = "";
    } 

    else {
      if (local_string.length() <= 50) {
        local_string += key;
      }
    }
  }
}

void onStringMessage( String name, String value ) {
  if (!active) {
    println("got string message " + name + " : " + value);
    remote_string = value;
    player = (int(value)-int(value)%100)/100;
    qNum = int(value)%100;  
    timeMark=millis();
    active = true;
  } 
  else {
    //SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST//SEND BACK TO HOST
  }
}

