/*
This is as basic as it gets.  If you can't get this running, 
something is not quite right.
*/

import wordcram.*;
Table hashtags;
hashtags = loadTable("aggregate.csv", "header");

size(1000, 600);
background(255);

// Each Word object has its word, and its weight.  You can use whatever
// numbers you like for their weights, and they can be in any order.
Word[] wordArray = new Word[10];
int count = 0;
for(TableRow row: hashtags.rows())
{
  int weight = row.getInt("Total_Num_Tweets") + row.getInt("Total_Num_Retweets") + row.getInt("Total_Num_Favorites");
  wordArray[count] = new Word(row.getString("#Label"), weight);  
  count++;
}

// Pass in the sketch (the variable "this"), so WordCram can draw to it.
WordCram wordcram = new WordCram(this)

// Pass in the words to draw.
  .fromWords(wordArray);

// Now we've created our WordCram, we can draw it:
wordcram.drawAll();