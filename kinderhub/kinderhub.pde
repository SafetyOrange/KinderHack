/*
 * String Example
 *
 * 	 Send messages up to 50 chars long. Receive string messages
 *   from other spacebrew clients as well.
 * 
 */

import spacebrew.*;

String server="54.201.24.223";
String name="Game Hub";
String description ="Client that sends and receives string messages on different ports.";

PFont serif;

Spacebrew sb;

// Keep track of our current place in the string
String incoming_val = "111";

int numComputers = 1;

boolean gameBegun = false;

void setup() {
  size(550, 150);
  background(0);

  serif = loadFont("Serif-48.vlw");

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "Port 0", "string", incoming_val );
  sb.addPublish( "Port 1", "string", incoming_val );
  sb.addPublish( "Port 2", "string", incoming_val );
  sb.addPublish( "Port 3", "string", incoming_val );
  sb.addPublish( "Port 4", "string", incoming_val );
  sb.addPublish( "Port 5", "string", incoming_val );
  sb.addPublish( "Port 6", "string", incoming_val );
  sb.addPublish( "Port 7", "string", incoming_val );
  sb.addPublish( "Port 8", "string", incoming_val );
  sb.addPublish( "Port 9", "string", incoming_val );

  // declare your subscribers
  sb.addSubscribe( "Incoming", "string" );

  // connect!
  sb.connect(server, name, description );
}

void draw() {
  background(200, 0, 0);
  fill(255);
  stroke(250);
  textFont(serif, 24);
  textAlign(TOP, LEFT);
  text("Incoming/Outgoing String: ", 10, 50);  
  text(incoming_val, 10, 80);  

  if(gameBegun){
    text("A game is in session", 10, 110);
  } else {
    text("Press any key to start game", 10, 110);
  }
  
  
}

void keyPressed() {

  if (gameBegun == false) {

    //send data to two random computers to start game
    int rand1 = int(random(numComputers));
    sb.send( "Port " + rand1, "100" );

    int rand2 = int(random(numComputers));

    //check code several times to make sure we're not sending both starting points to the same computer.
    //the odds of getting rand 1 = rand2 after 20 calls to random is very very small

    for (int i = 0; i < 100; i++) {
      if (rand2 == rand1) {
        rand2 = int(random(numComputers));
      }
    }

    sb.send( "Port " + rand2, "200" );
    
    gameBegun = true;
  }
}



void onStringMessage( String name, String value ) {
  println("got int val " + name + " : " + value);
  incoming_val = value;


  if (int(incoming_val) == 110) {
    //send to all that player 1 wins
    sb.send( "Port 0", "888" );
    sb.send( "Port 1", "888" );
    sb.send( "Port 2", "888" );
    sb.send( "Port 3", "888" );
    sb.send( "Port 4", "888" );
    sb.send( "Port 5", "888" );
    sb.send( "Port 6", "888" );
    sb.send( "Port 7", "888" );
    sb.send( "Port 8", "888" );
    sb.send( "Port 9", "888" );
  } 
  else if (int(incoming_val) == 210) {
    //send to all that player 2 wins
    sb.send( "Port 0", "999" );
    sb.send( "Port 1", "999" );
    sb.send( "Port 2", "999" );
    sb.send( "Port 3", "999" );
    sb.send( "Port 4", "999" );
    sb.send( "Port 5", "999" );
    sb.send( "Port 6", "999" );
    sb.send( "Port 7", "999" );
    sb.send( "Port 8", "999" );
    sb.send( "Port 9", "999" );
  } 
  else {

    int rand = int(random(numComputers));

    switch(rand) {
    case 0:
      sb.send( "Port 0", incoming_val );
      break;
    case 1:
      sb.send( "Port 1", incoming_val );
      break;
    case 2:
      sb.send( "Port 2", incoming_val );
      break;
    case 3:
      sb.send( "Port 3", incoming_val );
      break;
    case 4:
      sb.send( "Port 4", incoming_val );
      break;
    case 5:
      sb.send( "Port 5", incoming_val );
      break;
    case 6:
      sb.send( "Port 6", incoming_val );
      break;
    case 7:
      sb.send( "Port 7", incoming_val );
      break;
    case 8:
      sb.send( "Port 8", incoming_val );
      break;
    case 9:
      sb.send( "Port 9", incoming_val );
      break;
    }
  }
}


