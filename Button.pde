class Button {

  float x, y;
  float w = width/5, h = height/20;
  color c = light_grey;
  String text;
  float localFont = fontSize-10*displayDensity;

  void display() {
    stroke(c);
    fill(c);
    rect(x, y, w, h);
    fill(255);
    textSize(localFont);
    text(text, x, y);
  }

  boolean overlaps() {
    if (x-w/2 < mouseX && mouseX < x+w/2 && y-h/2 < mouseY && mouseY < y+h/2) return true;
    else return false;
  }

  void activate() {
    println(text);
  }
}

class ClearButton extends Button {


  ClearButton(float x, float y) {
    this.x = x;
    this.y = y;
    //c = color(255, 0, 0);
    text = "Clear";
  }

  void display() {
    if (gameOver && !animate) {
      stroke(grey);
      fill(grey);
    } else {
      stroke(c);
      fill(c);
    }
    rect(x, y, w, h);
    fill(255);
    textSize(localFont);
    text(text, x, y);
  }


  void activate() {
    if (gameOver) return;
    reset(false);
  }
}

class NewGameButton extends Button {


  NewGameButton(float x, float y) {
    this.x = x;
    this.y = y;
    //c = color(0, 255, 0);
    text = "New";
  }

  void activate() {
    reset(true);
    setWord();
    gameOver = false;
  }
}

class EndButton extends Button {


  EndButton(float x, float y) {
    this.x = x;
    this.y = y;
    //c = color(0, 0, 255);
    text = "End";
  }

  void display() {
    if (gameOver && !animate) {
      stroke(grey);
      fill(grey);
    } else {
      stroke(c);
      fill(c);
    }
    rect(x, y, w, h);
    fill(255);
    textSize(localFont);
    text(text, x, y);
  }

  void activate() {
    if (gameOver) return;
    gameOver();
  }
}
