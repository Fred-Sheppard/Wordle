class Counter { //<>//

  char character;
  int amount;

  Counter(char character, int amount) {
    this.character = character;
    this.amount = amount;
  }

  Counter copy() {
    return new Counter(character, amount);
  }
}


boolean checkValue(Cell[] word) {
  {
    //Comment out this line to remove verification
    if (!isLegal(word)) return false;
    Counter[] countersCopy = new Counter[26];
    for (int z = 0; z < countersCopy.length; z++) {
      countersCopy[z] = counters[z].copy();
    }
  Letter:
    //GREEN
    for (int i = 0; i < word.length; i++) {
      Cell currentCell = word[i];
      Counter thisCounter = countersCopy[currentCell.letter-65];
      if (currentCell.letter == answer[i] && thisCounter.amount > 0) {
        currentCell.newType = GREEN;
        thisCounter.amount--;
        for (KeyCell kc : keycells) {
          if (kc.character == currentCell.letter) 
          kc.newType = GREEN;
        }
        continue Letter;
      }
    }
  Letter:
    //YELLOW
    for (int i = 0; i < word.length; i++) {
      Cell currentCell = word[i];
      Counter thisCounter = countersCopy[currentCell.letter-65];
      if (thisCounter.amount > 0) {
        for (int j = 0; j < answer.length; j++) {
          if ((currentCell.letter == answer[j]) && thisCounter.amount > 0 && currentCell.newType != GREEN) {
            currentCell.newType = YELLOW;
            thisCounter.amount--;
            for (KeyCell kc : keycells) {
              if (kc.character == currentCell.letter
                && kc.newType != GREEN)
                kc.newType = YELLOW;
            }
            continue Letter;
          }
        }
      }
    }
    //GREY
    for (int i = 0; i < word.length; i++) {
      Cell currentCell = word[i];
      if (currentCell.newType != GREEN && currentCell.newType != YELLOW) {
        currentCell.newType = GREY;
        for (KeyCell kc : keycells) {
          if (kc.character == currentCell.letter
            && kc.newType != GREEN
            && kc.newType != YELLOW)
            kc.newType = GREY;
        }
      }
    }
    currentLetter = 0;
    if (currentLine <= 5) currentLine++;

    //WIN
    boolean isCorrect = true;
    for (int i = 0; i < word.length; i++) {
      if (word[i].letter != answer[i]) {
        isCorrect = false;
        break;
      } else {
        word[i].newType = GREEN;
      }
    }
    animate = true;
    timerIterate = 0;
    if (isCorrect) {
      return true;
    } else {
      return false;
    }
  }
}

void animate(int interval) {
  Cell[] word = array[currentLine-1];
  if (millis() > timer) {
    timer = millis() +interval;
    Cell cell = word[timerIterate];
    cell.setType();
    if (timerIterate++ > 3) {
      animate = false; 
      for (Cell c : word) {
       for (KeyCell kc : keycells) {
         if (c.letter == kc.character) {
           kc.setType();
         }
       }
      }
      for (KeyCell kc : keycells) {
       kc.newType = LIGHTGREY; 
      }
    }
  }
}
