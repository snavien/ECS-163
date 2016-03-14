/*
This is as basic as it gets.  If you can't get this running, 
 something is not quite right.
 */

import wordcram.*;
Table hashtags;
import wordcram.text.*;



Word lastClickedWord; // The word that was under the user's last click
WordCram wordcram;

PImage cachedImage; // Cache the rendered wordcram, so drawing is fast

void setup()
{

  hashtags = loadTable("aggregate.csv", "header");

  size(1000, 1000);
  background(255);


  // Each Word object has its word, and its weight.  You can use whatever
  // numbers you like for their weights, and they can be in any order.
  Word[] wordArray = new Word[10];
  int count = 0;
  float total_weight = 0;
  for (TableRow row : hashtags.rows())
  {
    total_weight += row.getInt("Total_Num_Tweets") + row.getInt("Total_Num_Retweets") + row.getInt("Total_Num_Favorites");

  }

  for (TableRow row : hashtags.rows())
  {
    int weight = row.getInt("Total_Num_Tweets") + row.getInt("Total_Num_Retweets") + row.getInt("Total_Num_Favorites");
    println(row.getString("#Label"));
    wordArray[count] = new Word(row.getString("#Label"), weight/total_weight);  
    count++;
    print(count);
  }
  


  // Pass in the sketch (the variable "this"), so WordCram can draw to it.
  wordcram = new WordCram(this)

    // Pass in the words to draw.
    .fromWords(wordArray)
    .withFont("data/BookAntiqua-Bold-48.vlw")
    .sizedByWeight(12, 80)
    .maxAttemptsToPlaceWord(1000);
   
    // Now we've created our WordCram, we can draw it:
    
  wordcram.drawAll();
 
  cachedImage = get();


}

void draw() {
  println(wordcram.getSkippedWords());
  // Set up styles for when we draw stuff to the screen (later)
  textFont(createFont("data/BookAntiqua-Bold-48.vlw", 150));
  textAlign(CENTER, CENTER);
  // First, wipe out the last frame: re-draw the cached image
  image(cachedImage, 0, 0);
  // First, wipe out the last frame: re-draw the cached image  
  // If the user's last click was on a word, render it big and blue:
  if (lastClickedWord != null) {
    noStroke();
    fill(255, 190);
    rect(0, height/2 - textAscent()/2, width, textAscent() + textDescent());

    fill(30, 144, 13, 150);
    text(lastClickedWord.word, width/2, height/2);
  }
}

void mouseClicked() {
  lastClickedWord = wordcram.getWordAt(mouseX, mouseY);
}

void report() {
  Word[] words = wordcram.getWords();
  int tooMany = 0;
  int tooSmall = 0;
  int couldNotPlace = 0;
  int placed = 0;
  int left = 0;

  for (int i = 0; i < words.length; i++) {
    Word word = words[i];
    if (word.wasSkipped()) {

      WordSkipReason skipReason = word.wasSkippedBecause();

      switch(skipReason) {
      case WAS_OVER_MAX_NUMBER_OF_WORDS:
        tooMany++;
        break;
      case SHAPE_WAS_TOO_SMALL:
        tooSmall++; 
        break;
      case NO_SPACE:
        couldNotPlace++; 
        break;
      }
    } else if (word.wasPlaced()) {
      placed++;
    } else {
      left++;
    }
  }

  print("TooMany " + tooMany + "  ");
  print("TooSmall " + tooSmall + "  ");
  print("CouldNotPlace " + couldNotPlace + "  ");
  print("Placed " + placed + "  ");
  println("Left " + left);
}