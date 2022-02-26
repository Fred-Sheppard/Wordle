class KeyCell {

  float x, y;
  char character;
  CellType type = LIGHTGREY;
  CellType newType = LIGHTGREY;
  float radius = 10;
  float w = width/12;
  float h = height*.07; 
  float localFont = fontSize-10*displayDensity;

  KeyCell(float x, float y, char ch) {
    this.x = x;
    this.y = y;
    character = ch;
  }

  void display() {
    switch(type) {
    case GREEN:
      fill(green);
      stroke(green);
      break;
    case YELLOW:
      fill(yellow);
      stroke(yellow);
      break;
    case GREY:
      fill(grey);
      stroke(grey);
      break;
    case BLUE:
      fill(blue);
      stroke(blue);
      break;
    default:
      fill(light_grey);
      stroke(light_grey);
      break;
    }
    rect(x, y, w, h, radius);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(localFont);
    text(character, x, y);
  }

  boolean overlaps() {
    if ((x-w/2 < mouseX && mouseX < x+w/2) && (y-h/2 < mouseY && mouseY < y+h/2)) {
      return true;
    } else {
      return false;
    }
  }

  void activate() {
    key = character;
    keyPressed();
  }

  void setType() {
    if (type == GREEN) return;
    if (newType == GREY && (type == YELLOW || type == GREEN)) return;
    type = newType;
  }
}

class BigKey extends KeyCell {

  String character;
  //float localFont = fontSize-10;
  float localFont = fontSize-15*displayDensity;

  BigKey(float x, float y, String s) {
    super(x, y, ' ');
    this.character = s;
    w = width*7/60;
  }

  void display() {
    switch(type) {
    case GREEN:
      fill(green);
      stroke(green);
      break;
    case YELLOW:
      fill(yellow);
      stroke(yellow);
      break;
    case GREY:
      fill(grey);
      stroke(grey);
      break;
    default:
      fill(light_grey);
      stroke(light_grey);
      break;
    }
    rect(x, y, w, h, radius);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(localFont);
    text(character, x, y-textAscent()/10);
  }

  void activate() {
    if (character.equals("ENT")) {
      enter();
    } else if (character.equals("DEL")) backSpace();
  }
}
