/*
This is as basic as it gets.  If you can't get this running, 
 something is not quite right.
 */

import wordcram.*;
import wordcram.text.*;
import org.gicentre.utils.stat.*; 

Word lastClickedWord; // The word that was under the user's last click
WordCram wordcram;
WordPlacer placer;

int state = 3; 
// 0 = word cloud
// 1 = transition
// 2 = frequency hashtag
// 3 = frequency chart

XYChart[] lineChart = new XYChart[NUM_CSV];
color[] m_color = {color(220,20,60), color(255,127,80), color(255,140,0), color(255,215,0), 
                   color(0,100,0), color(144,238,144),color(32,178,170), color(100,149,237),
                   color(25,25,112), color(75,0,130), color(128,0,128)};

PImage cachedImage; // Cache the rendered wordcram, so drawing is fast

void setup()
{
  size(1000, 800);
  background(255);
  
  readData();
  
  // Pass in the sketch (the variable "this"), so WordCram can draw to it.
  wordcram = new WordCram(this)

    // Pass in the words to draw.
    .fromWords(wordArray)
    .withFont(createFont("data/SketchMatch.ttf", 1))
    .sizedByWeight(12, 55)
    .maxAttemptsToPlaceWord(1000)
    .withPlacer(placer)
     .withColors(color(30), color(110),
              color(random(255), 240, 200))
    ;
   
   
    // Now we've created our WordCram, we can draw it:
    
  wordcram.drawAll();
  cachedImage = get();
  


  float[] x_data = new float[YEARS];
  for(int i = 0; i < YEARS; i++)
  {
    x_data[i] = i + 2006; 
  }
                    
  float[][] y_data = new float[NUM_CSV][YEARS];
  for(int csv = 0; csv < NUM_CSV; csv++)
  {
    for(int i = 0; i < YEARS; i++)
    {
      for(int j = 0; j < MONTHS; j++)
      {
        y_data[csv][i] = y_data[csv][i] + popularityByDate[i][j][csv][S_COUNT] + popularityByDate[i][j][csv][S_RETWEET] +
                        popularityByDate[i][j][csv][S_FAVORITE];
      }
    }
  }
  
  for(int csv = 0; csv < NUM_CSV; csv++)
  {
    for(int i = 0; i < YEARS; i++)
    {
      y_data[csv][i] = log(y_data[csv][i]);
    }
  }
  
                     
  for(int index = 0; index < NUM_CSV; index++)
  {
    lineChart[index] = new XYChart(this);
    lineChart[index].setData(x_data, y_data[index]);
    lineChart[index].showYAxis(false); 
    lineChart[index].showXAxis(false);
    lineChart[index].setMinY(0);
    lineChart[index].setMaxY(17);
    lineChart[index].setXFormat("0000"); // year
    //l.setPointColor(color(180,50,50,100));
    lineChart[index].setPointColour(m_color[index]);
    lineChart[index].setLineColour(m_color[index]);
    lineChart[index].setPointSize(5);
    lineChart[index].setLineWidth(2);
    lineChart[index].showXAxis(true); 
    lineChart[index].showYAxis(true);
  }
  
  //lineChart[0].showXAxis(true);
  //lineChart[0].showYAxis(true); 
   
  // Symbol colours
  //lineChart[0].setPointColour(color(180,50,50,100));


}

void draw() {
  if(state == 0) {
    println(wordcram.getSkippedWords());
    // Set up styles for when we draw stuff to the screen (later)
    textFont(createFont("data/PaleBlueEyes.ttf", 50));
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
  else if(state == 1)
  {
  }
  else if(state == 2)
  {
  }
  else if(state == 3)
  {
    background(255,255,255);
    for(int i = 0; i < NUM_CSV; i++)
    {
      lineChart[i].draw(30,height/2 - 30,width-30,height/2);
    }
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