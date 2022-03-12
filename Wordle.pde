float displayDensity = 1;
boolean isJava = true;

String answerString;
Cell[][] array = new Cell[6][5];
Counter[] counters = new Counter[26];
KeyCell[] keycells = new KeyCell[26];
BigKey EnterKey;
BigKey DelKey;
Button[] buttons = new Button[3];

String[] allowedWords;
char[] answer;
enum CellType {
  DEFAULT, GREY, YELLOW, GREEN, BLUE, LIGHTGREY
};
CellType DEFAULT  = CellType.DEFAULT;
CellType GREY  = CellType.GREY;
CellType YELLOW  = CellType.YELLOW;
CellType GREEN  = CellType.GREEN;
CellType BLUE = CellType.BLUE;
CellType LIGHTGREY  = CellType.LIGHTGREY;
color grey, black, stroke, light_grey;
color yellow, green, blue;
int currentLine = 0;
int currentLetter = 0;
boolean gameOver;
float cellOutline, cellSize;
float fontSize;
boolean winSplash, loseSplash;
int timer, timerIterate;
boolean animate, init;
boolean start;

void settings() {
  if (isJava) size(500, 1000);
  else size(displayWidth, displayHeight);
}

void setup() {
  background(black);
  orientation(PORTRAIT);
  frameRate(20);
  strokeWeight(3);
  fontSize = 40*displayDensity;
  textAlign(CENTER, CENTER);
  cellOutline = width/6;
  cellSize = cellOutline*0.9;
  grey = color(#333333);
  black = color(#0E0F10);
  stroke = color(#3A3A3C);
  yellow = color(#B59F3B);
  green = color(#538D4E);
  blue = color(#207EE0);
  light_grey = color(#818384);
  PFont myFont = createFont("LSANS.TTF", fontSize);
  textFont(myFont);
  loadingScreen();
  thread("init");
}

void init() {
  allowedWords = loadStrings("allowedwords.txt");
  setWord();

  //Cells
  for (int i = 0; i < array.length; i++) {
    Cell[] currentArray = array[i];
    for (int j = 0; j < currentArray.length; j++) {
      //j+1 for half cell at start, the other half is off-screen
      //Cellsize is width/6, so draw 5 leaves one extra divided either size
      currentArray[j] = new Cell((j+1)*cellOutline, (i+1)*cellOutline);
    }
  }

  //KeyCells
  String qwerty = "QWERTYUIOPASDFGHJKLZXCVBNM";
  for (int i = 0; i < 10; i++) {
    char ch = qwerty.charAt(i);
    keycells[i] = new KeyCell(i*width/10+width/20, height*.75, ch);
  }
  for (int i = 10; i < 19; i++) {
    char ch = qwerty.charAt(i);
    keycells[i] = new KeyCell((i-9)*width/10, height*.83, ch);
  }
  for (int i = 19; i < keycells.length; i++) {
    char ch = qwerty.charAt(i);
    keycells[i] = new KeyCell((i-17)*width/10, height*.91, ch);
  }
  EnterKey = new BigKey(width/12, height*.91, "ENT");
  DelKey = new BigKey(width*11/12, height*.91, "DEL");

  buttons[0] = new ClearButton(width/8, height*.6);
  buttons[1] = new NewGameButton(width/2, height*.6);
  buttons[2] = new EndButton(width*7/8, height*.6);
  init = true;
}

void setWord() {
  String[] possibleAnswers = loadStrings("wordle_answers.txt");
  int index = floor(random(0, possibleAnswers.length));
  answerString = possibleAnswers[index].toUpperCase();
  //answerString = "allay";
  answer = answerString.toUpperCase().toCharArray();

  //Counters
  for (int i = 0; i < counters.length; i++) {
    counters[i] = new Counter(char(i+65), 0);
    Counter thisCounter = counters[i];
    for (char ch : answer) {
      if (ch == thisCounter.character) {
        thisCounter.amount++;
      }
    }
  }
}

void draw() {
  if (!init || !start) return;
  background(black);
  for (Cell[] arrays : array) {
    for (Cell c : arrays) {
      c.display();
    }
  }
  for (Button b : buttons) {
    b.display();
  }
  for (KeyCell kc : keycells) {
    kc.display();
  }
  EnterKey.display();
  DelKey.display();
  if (winSplash && !animate) winSplash();
  else if (loseSplash && !animate) loseSplash();
  if (animate) {
    animate(400);
  }
}

void mousePressed() {
  if (!start) {
    start = true;
    return;
  }
  winSplash = false;
  loseSplash = false;
  if (animate) return;
  for (KeyCell kc : keycells) {
    if (kc.overlaps()) kc.activate();
  }
  for (Button b : buttons) if (b.overlaps()) b.activate();
  if (EnterKey.overlaps()) EnterKey.activate();
  else if (DelKey.overlaps()) DelKey.activate();
}

void keyPressed() {
  if (animate || gameOver) return;
  winSplash = false;
  loseSplash = false;
  if (!isJava) {
    if (key == CODED && keyCode == 67) {
      backSpace();
    } else if (key == CODED && keyCode == 66) {
      enter();
    } else {
      addLetter();
    }
  } else {
    if (key == BACKSPACE) backSpace();
    else if (key == ENTER) enter();
    else if (key == '-')
      gameOver();
    else addLetter();
  }
}

void reset(boolean resetKeys) {
  for (Cell[] arrays : array) {
    for (Cell c : arrays) {
      c.reset();
    }
  }
  if (resetKeys) {
    for (KeyCell kc : keycells) {
      kc.type = LIGHTGREY;
    }
  }
  currentLine = 0;
  currentLetter = 0;
}

boolean isLegal(Cell[] word) {
  char[] letters = new char[5];
  for (int i = 0; i < word.length; i++) {
    letters[i] = word[i].letter;
  }
  String thisWord = new String(letters);
  boolean isLegal = false;
  for (int i = 0; i < allowedWords.length; i++) {
    if (thisWord.equals(allowedWords[i])) {
      isLegal = true;
      break;
    }
  }
  return isLegal;
}

void addLetter() {
  char pressedKey = Character.toUpperCase(key);
  if (pressedKey >= 65 && pressedKey <= 90) {
    if (currentLine < 6 && currentLetter < 5) {
      Cell currentCell = array[currentLine][currentLetter];
      currentCell.letter = pressedKey;
      currentLetter++;
    }
  } else {
    return;
  }
}

void backSpace() {
  if (gameOver) return;
  if (currentLine < 6) {
    if (currentLetter > 0) {
      currentLetter--;
    }
    array[currentLine][currentLetter].letter = ' ';
  }
}

void enter() {
  if (currentLine == 5)
    if (gameOver) return;
  if (currentLetter == 5) {
    if (checkValue(array[currentLine])) {
      winSplash = true;
      gameOver = true;
    } else if (currentLine >= 6) {
      checkValue(array[currentLine-1]);
      loseSplash = true;
      gameOver = true;
    }
  }
}

void gameOver() {
  Cell[] thisWord = array[5];
  for (int i = 0; i < thisWord.length; i++) {
    Cell thisCell = thisWord[i];
    thisCell.letter = answer[i];
    thisCell.type = BLUE;
    for (KeyCell kc : keycells) {
      if (kc.character == thisCell.letter) kc.type = BLUE;
    }
  }
  gameOver = true;
  loseSplash = true;
}



void winSplash() {
  rectMode(CENTER);
  noStroke();
  fill(0, 127);
  rect(width/2, height/2, width, height/5);
  fill(255);
  String s = (
    "Game Over\n"
    +"You Win\n"
    +"The Correct Word was " + answerString
    );
  text(s, width/2, height/2);
}

void loseSplash() {
  for (KeyCell kc : keycells) {
    for (char c : answer) {
      if (kc.character == c) kc.type =  BLUE;
    }
  }
  rectMode(CENTER);
  noStroke();
  fill(0, 127);
  rect(width/2, height/2, width, height/5);
  fill(255);
  String s = (
    "Game Over\n"
    +"You Lose\n"
    +"The Correct Word was " + answerString
    );
  text(s, width/2, height/2);
}

void loadingScreen() {
  textAlign(CENTER, CENTER);
  textSize(200*displayDensity);
  background(green);
  text("W", width/2, height/2);
  textSize(30*displayDensity);
  text("Click to Start", width/2, height*.625);
}
