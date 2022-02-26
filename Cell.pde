class Cell {

  float x, y;
  char letter = ' ';
  color c;
  float size = cellSize;
  CellType type = DEFAULT;
  CellType newType = DEFAULT;

  Cell(float x, float y) {
    this.x = x;
    this.y = y;
    c = black;
  }

  void display() {
    switch(type) {
    case GREY:
      stroke(grey);
      fill(grey);
      break;
    case YELLOW:
      stroke(yellow);
      fill(yellow);
      break;
    case GREEN:
      stroke(green);
      fill(green);
      break;
    case BLUE:
      stroke(blue);
      fill(blue);
      break;
    default:
      stroke(stroke);
      fill(black);
      break;
    }
    rectMode(CENTER);
    rect(x, y, size, size);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    text(letter, x, y);
  }

  void checkValue() {
    for (char car : answer) {
      if (letter == car) {
        type = YELLOW;
      }
    }
  }

  void reset() {
    letter = ' ';
    type = DEFAULT;
  }
  
  void setType() {
   type = newType;
   newType = DEFAULT;
  }
}
