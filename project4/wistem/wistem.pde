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
Rainbow c = new Rainbow();
float[][] y_data; // csv, year

PImage cachedImage; // Cache the rendered wordcram, so drawing is fast

Slider s;

void setup()
{
  size(1000, 800);
  background(255);
  
  readData();
  
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // WORD CLOUD
  ///////////////////////////////////////////////////////////////////////////////////////////////
  wordcram = new WordCram(this)

    // Pass in the words to draw.
    .fromWords(wordArray)
    .withFont(createFont("data/SketchMatch.ttf", 1))
    .sizedByWeight(12, 55)
    .maxAttemptsToPlaceWord(1000)
    .withPlacer(placer)
     .withColors(color(30), color(110),
              color(random(255), 240, 200));
  wordcram.drawAll();
  cachedImage = get();
  
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // LINE CHART
  ///////////////////////////////////////////////////////////////////////////////////////////////
  float[] x_data = new float[YEARS];
  for(int i = 0; i < YEARS; i++)
  {
    x_data[i] = i + 2006; 
  }
                    
  y_data = new float[NUM_CSV][YEARS];
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
  
  color[] m_color = c.getArray();                   
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

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // MISC
  ///////////////////////////////////////////////////////////////////////////////////////////////
  s = new Slider(0, height - 20, width, 20);
}

void draw() {
  if(state == 0) {
    //println(wordcram.getSkippedWords());
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
    int year = getYearFromSlider();
    
    if(year != 0 && year <= 2016) {
      for(int i = 0; i < NUM_CSV; i++)
      {
        c.setAlpha(i, y_data[i][year - 2006] / 10.0 * 255);
      }
    }
    else {
      c.resetColor();
      println("HELP");
    }
    
    textFont(createFont("data/Default.tff", 12));
    background(255,255,255);
    for(int i = 0; i < NUM_CSV; i++)
    {
      lineChart[i].draw(30,height/2 - 60,width-30,height/2);
    }
    
    color[] m_color = c.getArray();
    textFont(createFont("data/SketchMatch.ttf", 30));
    int textIndex;
    for(textIndex = 0; textIndex < NUM_CSV; textIndex++)
    {
      fill(m_color[textIndex]);
      text(hashtag[textIndex], 30, 30 + 30*textIndex);
    }
    fill(0, 0, 0);
    text("Year Choosen: " + ((year == 0) ? "ALL" : year), 30, 30 + 30*textIndex);
    s.draw();
  }
  
}

int getYearFromSlider()
{
  /*
    < .03 = all time
    interval increases by .08818182 
  */
  float percentage = s.getPos() - .015;
  float year_area = percentage / (((1000 - (1000 * .015)) / 11)/1000); 
  int year = floor(year_area)  + 2006;
  
  
  return (percentage < .015) ? 0 : year;
}

void mousePressed()
{
  if(state == 3)
  {
    if(s.overEvent()) {s.press();}
  }
}

void mouseClicked() {
  lastClickedWord = wordcram.getWordAt(mouseX, mouseY);
}

void mouseDragged() 
{
  if(state == 3)
  {
    if(s.overEvent()) {s.press();}
  }
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