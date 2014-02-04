/*
 * Dear Adiel
 *  The missing assets are here:
 *  https://www.dropbox.com/sh/sl7pk6i8ljmw7ec/BZ2ZIZu5LH
 *  
 * If you get to the parsing answers without me,  be sure to call these functions:
 * playSound(2) for correct answer, and playSound(3) for incorrect answers.
 *
 *  Also, I love you.
 *  Anthony
 
 
 
 NOTE: parsed question data must be from 0-9 with 9 being the winning question
 
 
 
 
 */

import spacebrew.*;
import ddf.minim.*;

Minim minim;
AudioPlayer correctSound;
AudioPlayer incorrectSound;
AudioPlayer boop1;
AudioPlayer boop2;
AudioPlayer boop3;
AudioPlayer boop4;
AudioPlayer boop5;
AudioPlayer boop6;
AudioPlayer gameOver;

String server="54.201.24.223";
String name="Game Client";
String description ="LOLGAMEZ";


PImage h4xWhite;
PVector hPos;
float timer = 10000;
float timeW;
float timeMark;
color timeC = color(0, 255, 0);
int playerNum = 0;
color pColor;
int qNum = 0;
boolean active = false;
float clockVal = 0;
int clockPadding = 20;
int clockRad = 0;

int codeScroll1 = 0;
int codeScroll2 = 0;
int sideCodeScroll1 = 0;
int sideCodeScroll2 = 0;
int sideCodeScroll3 = 0;

Spacebrew sb;

//QUESTION STUFF
PFont mono;
String[] questions = {
  "What color results from mixing red and yellow?", "What is 2 + 3 + 5 – 1?", "The cat says...", "What shape has 4 sides?", "Fill in the missing number 2, 4, 6, __, 10 , 12", "Practice writing your first name...", "The opposite of fast is...", "\"In 1492, Columbus sailed the ocean _____\"", "The opposite of right is...", "Released in 2005 under an MIT license, this cross-platform C++ toolkit was designed to tie together powerful open source libraries to empower creative coders everywhere"
};
String[] answers = {
  "orange", "9", "meow", "square", "8", "", "slow", "blue", "wrong", "openframeworks"
};



//ANSWER STUFF
String userData = "";    //stores user data packet i.e. "203"
String userInput = "";   //string currently being typed by user
String userAnswer = "";  //string after user hits enter

boolean correct = false;
boolean playEnd = true;

boolean answered = false;
int answeredMark = 0;
int answeredTimer = 1500;

boolean timesUp = false;

boolean yellowWins = false;      //data code = 888
boolean blueWins = false;     //data code = 999
float winTrans = 0;



void setup() {
  size(displayWidth, displayHeight);
  background(0);



  h4xWhite = loadImage("white.png");
  mono = loadFont("Monospaced-200.vlw");

  minim = new Minim(this);
  boop1 = minim.loadFile("boop1.wav");
  boop2 = minim.loadFile("boop2.wav");
  boop3 = minim.loadFile("boop3.wav");  
  boop4 = minim.loadFile("boop4.wav");
  boop5 = minim.loadFile("boop5.wav");
  boop6 = minim.loadFile("boop6.wav");  
  correctSound = minim.loadFile("correct.wav");
  incorrectSound = minim.loadFile("incorrect.wav");  
  gameOver= minim.loadFile("gameover.wav");


  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "Output", "string", userInput ); 

  // declare your subscribers
  sb.addSubscribe( "Input", "string" );

  // connect!
  sb.connect(server, name, description );

  clockRad = height/4 - clockPadding;

  codeScroll1 = height;
  codeScroll2 = height + h4xWhite.height;

  sideCodeScroll1 = height;
  sideCodeScroll2 = height + h4xWhite.height/2;
  sideCodeScroll3 = height + h4xWhite.height;
}

void draw() {


  //continuous code scrolling
  background(0);

  tint(pColor);
  image(h4xWhite, 0, codeScroll1);
  image(h4xWhite, 0, codeScroll2);

  int scrollSpeed = 3;

  codeScroll1 -= scrollSpeed;
  codeScroll2 -= scrollSpeed;

  if (codeScroll1 < -h4xWhite.height) {
    codeScroll1 = codeScroll2 + h4xWhite.height;
  }
  if (codeScroll2 < -h4xWhite.height) {
    codeScroll2 = codeScroll1 + h4xWhite.height;
  }

  image(h4xWhite, 0, codeScroll1);
  image(h4xWhite, 0, codeScroll2);


  //scrolling in side panel
  int sideScrollSpeed = 5;

  sideCodeScroll1 -= sideScrollSpeed;
  sideCodeScroll2 -= sideScrollSpeed;
  sideCodeScroll3 -= sideScrollSpeed;

  if (sideCodeScroll1 < -h4xWhite.height/2) {
    sideCodeScroll1 = sideCodeScroll3 + h4xWhite.height/2;
  }
  if (sideCodeScroll2 < -h4xWhite.height/2) {
    sideCodeScroll2 = sideCodeScroll1 + h4xWhite.height/2;
  }
  if (sideCodeScroll3 < -h4xWhite.height/2) {
    sideCodeScroll3 = sideCodeScroll2 + h4xWhite.height/2;
  }

  image(h4xWhite, width-2*(clockRad + clockPadding), sideCodeScroll1, h4xWhite.width/2, h4xWhite.height/2);
  image(h4xWhite, width-2*(clockRad + clockPadding), sideCodeScroll2, h4xWhite.width/2, h4xWhite.height/2);
  image(h4xWhite, width-2*(clockRad + clockPadding), sideCodeScroll3, h4xWhite.width/2, h4xWhite.height/2);  


  //spinning circle thing on idle screen
  if (!active) {
    float time = radians(map(millis()%4000, 0, 4000, 0, 360));

    ellipseMode(RADIUS);

    noStroke();

    fill(100);
    arc(width - clockRad - clockPadding, clockRad + clockPadding, clockRad, clockRad, 0, time, PIE);

    int num = 10;
    for (int i = 0; i < num; i++) {

      fill(0, 255*0.2);
      arc(width - clockRad - clockPadding, clockRad + clockPadding, clockRad - clockRad*i/num, clockRad - clockRad*i/num, 0, time, PIE);
    }
  }


  //------------------------------------------------------------ IF ACTIVE THEN DO SOME SHIT... ------------------------------------------------------------
  if (active) {


    if (playerNum==1) {
      pColor = color(255, 255, 0);
      //      float temp = map(millis(), timeMark, timeMark+timer, height, -500);
      //      hPos = new PVector(0, temp);
      //      image(h4xRed, hPos.x, hPos.y);
    }
    if (playerNum==2) {
      pColor = color(0, 0, 255);
      //      float temp = map(millis(), timeMark, timeMark+timer, height, -500);
      //      hPos = new PVector(0, temp);
      //      image(h4xBlue, hPos.x, hPos.y);
    }


    //----------TIMER. THIS IS THE TIMER. IT TIMES----------
    if (millis() - timeMark < timer) {

      //original bar timer
      //      pushStyle();
      //      timeW=map(millis(), timeMark, timeMark+timer, width, 0);
      //      float temp = map(millis(), timeMark, timeMark+timer, 0, 1);
      //      color from = color(0, 255, 0);
      //      color to = color(255, 0, 0);
      //      timeC=lerpColor(from, to, temp);
      //      fill(timeC);
      //      noStroke();
      //      rectMode(CENTER);
      //      rect(width/2, height/2, timeW, 100);
      //      rectMode(CORNER);
      //      popStyle();  

      //round timer
      pushStyle();



      if (!answered) {
        clockVal = map(millis(), timeMark, timeMark + timer, 360, 0);
      }

      fill(pColor);
      ellipseMode(RADIUS);
      noStroke();
      arc(width - clockRad - clockPadding, clockRad + clockPadding, clockRad, clockRad, 0, radians(clockVal), PIE);

      popStyle();
    } 
    else {          //if timer runs out, deactivate
      if (timesUp == false) {
        playSound(3);

        //mark question as answered and note time 
        answered = true;
        answeredMark = millis();
        correct = false;

        timesUp = true;
      }
    }


    //----------QUESTIONS AND ANSWERS. THIS IS WHERE THEY ARE. BE PUZZLED----------
    if (qNum < 10 && qNum >= 0) {    //prevents crashing due to array out of bounds, just in case data is sent improperly formatted

      int margin = 50;
      pushStyle();
      //draw transparent box behind text to make more readable
      fill(40, 255*0.8);
      rectMode(CORNERS);
      rect(margin, 80, width*2/3, height - 250);


      textFont(mono, 50);
      fill(pColor);
      if (qNum == 9) {
        textFont(mono, 40);
      }
      text(questions[qNum], margin + 10, 80 + 10, width*2/3 - margin, height);
      popStyle();


      //TEXT BOX
      pushStyle();
      fill(255);
      strokeWeight(3);
      stroke(150);
      rect(margin, height - 100, width*2/3 - margin, 50);
      textFont(mono, 50);
      fill(0);
      textAlign(LEFT, CENTER);
      text(userInput, margin + 5, height - 100, width*2/3 - margin, 50);

      popStyle();
    }

    //answer checking code in keyPressed function

    if (answered) {

      if (correct) {
        pushStyle();
        textAlign(CENTER, CENTER);
        textFont(mono);
        fill(0, 255, 0);
        text("PASS", width/2, height/2);
        popStyle();
      } 
      else {
        pushStyle();
        textAlign(CENTER, CENTER);
        textFont(mono);
        fill(255, 0, 0);
        text("FAIL", width/2, height/2);
        popStyle();
      }

      //timer to end active state but make sure user has time to see answer
      if (millis() - answeredMark > answeredTimer) {
        active = false;
        answered = false;
        correct = false;
        timesUp = false;
        sb.send("Output", userData);
      }
    }
  } 
  else {                  //--------------------INACTIVE SCREEN CODE--------------------


    pColor = color(180);
  }


  if (yellowWins) {
    pushStyle();    
    fill(255, 0, 0, winTrans);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    textFont(mono, 100);
    fill(0);
    text("YELLOW WINS", width/2, height/2);
    if (playEnd==true) {
      playSound(4);
      playEnd=false;
    }  

    if (winTrans < 255) {
      winTrans += 3;
    }

    popStyle();
  } 
  else if (blueWins) {
    pushStyle();    
    fill(0, 0, 255, winTrans);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    textFont(mono, 100);
    fill(0);
    text("BLUE WINS", width/2, height/2); 
    if (playEnd==true) {
      playSound(4);
      playEnd=false;
    }     

    if (winTrans < 255) {
      winTrans += 3;
    }

    popStyle();
  }
}


void keyPressed() {

  playSound(1);

  //IDIOT DEBUG OPTION
  //  if (key=='1') {
  //    timeMark=millis();
  //    playerNum=1;
  //    qNum=1;
  //    active=true;
  //  }
  //
  //  if (key=='2') {
  //    timeMark=millis();
  //    playerNum=2;
  //    qNum=1;
  //    active=true;
  //  }
  /////////////////////

  if (key != CODED) {
    if (key == DELETE || key == BACKSPACE) {
      if (userInput.length() - 1 >= 0) {
        userInput = userInput.substring(0, (userInput.length() - 1));
      }
    }

    else if (key == ENTER || key == RETURN) {
      //sb.send("listen_to_me", local_string);
      //last_string = local_string;
      //local_string = "";
      userAnswer = userInput.toLowerCase();
      userInput = "";

      //check to see if userAnswer string is equal to correct answer 


      if (userAnswer.equals(answers[qNum]) || qNum == 5) {
        correct = true;
        println("correct: " + userData);
        //convert user data string to int, add one then convert back to string
        userData = str(int(userData) + 1);
        println(userData);

        playSound(2);
      } 
      else {
        correct = false;
        println("wrong: " + userData);
        playSound(3);
      }


      //mark question as answered and note time 
      answered = true;
      answeredMark = millis();
    } 
    else {
      if (userInput.length() <= 50) {
        userInput += key;
      }
    }
  }
}

void onStringMessage( String name, String value ) {

  if (int(value) == 888) {
    yellowWins = true;
  } 
  else if (int(value) == 999) {
    blueWins = true;
  } 
  else if (!active) {
    active = true;
    userData = value;
    userInput = "";
    println("got string message " + name + " : " + value);
    playerNum = (int(value)-int(value)%100)/100;
    qNum = int(value)%100;
    println("player: " + playerNum + "    Question: " + qNum);  
    timeMark=millis();
  } 
  else {
    println("Following string sent back to hub: " + value);
    sb.send("Output", value);
  }
}




void playSound(int type) {

  // 1 IS BOOP
  // 2 IS CORRECT
  // 3 IS INCORRECT
  // 4 IS GAMEOVER

  switch(type) {
  case 1:
    int rand = floor(random(1, 7));

    switch(rand) {
    case 1:
      boop1.play();
      boop1.rewind();
      break;
    case 2:
      boop2.play();      
      boop2.rewind();
      break;
    case 3:
      boop3.play();      
      boop3.rewind();
      break;
    case 4:
      boop4.play();      
      boop4.rewind();
      break;
    case 5:
      boop5.play();      
      boop5.rewind();
      break;
    case 6:
      boop6.play();      
      boop6.rewind();
      break;
    }


    break;
  case 2:
    correctSound.play();
    correctSound.rewind();
    break;
  case 3:
    incorrectSound.play();
    incorrectSound.rewind();
    break;
  case 4:
    gameOver.play();
  }
}

void reset() {
  answered = false;
  correct = false;
}


boolean sketchFullScreen() {
  return true;
}

