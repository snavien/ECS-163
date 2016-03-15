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
PieChart pieChart = new PieChart();
float []angles  = {51,51,51,51,51,51,54};
int state = 3; 
int extra_state = 0; 
// 0 = word cloud
// 1 = transition
// 2 = frequency hashtag
// 3 = frequency chart

XYChart[] lineChart = new XYChart[NUM_CSV];
XYChart[] lineChart1 = new XYChart[NUM_CSV];
Rainbow c = new Rainbow();
float[][] y_data; // csv, year
float[][] y_month;
float[] x_month; 

PImage cachedImage; // Cache the rendered wordcram, so drawing is fast

Slider s;

void setup()
{
  size(1000, 800);
  background(200);
  
  readData();
  
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // WORD CLOUD
  ///////////////////////////////////////////////////////////////////////////////////////////////
  wordcram = new WordCram(this)

    // Pass in the words to draw.
    .fromWords(wordArray)
    .withFont(createFont("data/SketchMatch.ttf", 1))
    .sizedByWeight(20, 70)
    .maxAttemptsToPlaceWord(1000)
    .withPlacer(placer)
     .withColors(color(80, 80), color(110, 80),
              color(random(255), 240, 200, 30));
  wordcram.drawAll();
  cachedImage = get();
  
  ///////////////////////////////////////////////////////////////////////////////////////////////
  // LINE CHART
  ///////////////////////////////////////////////////////////////////////////////////////////////
  float[] x_data = new float[YEARS];
  float[] x_month = new float[YEARS * MONTHS]; 
  for(int i = 0; i < YEARS; i++)
  {
    x_data[i] = i + 2006; 
  }
  
  for(int i = 0; i < YEARS * MONTHS; i++)
  {
    x_month[i] = i;
  }
                    
  y_data = new float[NUM_CSV][YEARS];
  y_month = new float[NUM_CSV][YEARS *MONTHS];
  for(int csv = 0; csv < NUM_CSV; csv++)
  {
    for(int i = 0; i < YEARS; i++)
    {
      for(int j = 0; j < MONTHS; j++)
      {
        y_data[csv][i] = y_data[csv][i] + popularityByDate[i][j][csv][S_COUNT] + popularityByDate[i][j][csv][S_RETWEET] +
                        popularityByDate[i][j][csv][S_FAVORITE];
        y_month[csv][i*j] = popularityByDate[i][j][csv][S_COUNT] + popularityByDate[i][j][csv][S_RETWEET] +
                        popularityByDate[i][j][csv][S_FAVORITE];
      }
    }
  }
  
  for(int csv = 0; csv < NUM_CSV; csv++)
  {
    for(int i = 0; i < YEARS; i++)
    {
      y_data[csv][i] = log(y_data[csv][i]);
      for(int j = 0; j < MONTHS; j++)
      {
        y_month[csv][i*j] = log(y_month[csv][i*j]);
      }
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
    
    lineChart1[index] = new XYChart(this);
    lineChart1[index].setData(x_month, y_month[index]);
    lineChart1[index].showYAxis(false); 
    lineChart1[index].showXAxis(false);
    lineChart1[index].setMinY(0);
    lineChart1[index].setMaxY(17);
    lineChart1[index].setXFormat("0000"); // year
    //l.setPointColor(color(180,50,50,100));
    lineChart1[index].setPointColour(m_color[index]);
    lineChart1[index].setLineColour(m_color[index]);
    lineChart1[index].setPointSize(5);
    lineChart1[index].setLineWidth(2);
    lineChart1[index].showXAxis(true); 
    lineChart1[index].showYAxis(true);
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
    image(cachedImage, 0, 0);
    
    
  float [] data = {8787308/15157730.0, 8992599/15464197, 92429814/16210103.0,
                  10094332/17404882.0, 10379172/17915,952.0, 10382782/17878363.0,
                  10151705/17514160.0},
                  
           data1 ={0.621334146,0.622170603, 0.623552471, 0.621487522, 0.619928513, 0.616829287, 0.614900154
           };
    pieChart.drawPieChart(300, angles);

   
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
    
    if(extra_state == 0) {
      textFont(createFont("data/Default.tff", 12));
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
    else {
      textFont(createFont("data/Default.tff", 12));
      for(int i = 0; i < NUM_CSV; i++)
      {
        lineChart1[i].draw(30,height/2 - 60,width-30,height/2);
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

void keyPressed()
{
  if(keyCode == LEFT) {
    extra_state = 0;
  }
  else if(keyCode == RIGHT) {
    extra_state = 1;
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
}