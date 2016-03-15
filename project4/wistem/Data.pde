static final int KEYWORD = 0;
static final int SCREEN_NAME = 1;
static final int TEXT_CONTENT = 2; 
static final int YEAR = 3;
static final int MONTH = 4; 
static final int RETWEET = 5; 
static final int RETWEET_COUNT = 6; 
static final int FAVORITE = 7; 
static final int FAVORITE_COUNT = 8;

static final int NUM_CSV = 10;
static final int YEARS   = 11; 
static final int MONTHS  = 12; 
static final int STYLE   = 3;
static final int S_COUNT    = 0; 
static final int S_RETWEET  = 1; 
static final int S_FAVORITE = 2; 

int[][][][] popularityByDate = new int[YEARS][MONTHS][NUM_CSV][STYLE];
String[] hashtag = {"#AddWomen", "#BeAGirlWhoCodes", "#DistractinglySexy", "#GirlsWhoCode", 
                    "#GirlsWithToys", "#ILookLikeAnEngineer", "#LikeAGirl", "#StemGirls", 
                    "#StemWomen", "#WomenInTech"};  
                   
Table[] data = new Table[NUM_CSV];
Word[] wordArray = new Word[NUM_CSV];
Table aggregate;  


void readData()
{
  for(int i = 0; i < NUM_CSV; i++)
  {
    data[i] = loadTable(dataPath("") + "/" + hashtag[i] + ".csv", "header"); 
  }
  
  aggregate = loadTable(dataPath("") + "/aggregate.csv", "header");
  
  createWordArray();
  processDataPopularity();
}

void createWordArray()
{
  // Each Word object has its word, and its weight.  You can use whatever
  // numbers you like for their weights, and they can be in any order.

  int count = 0;
  float total_weight = 0;
  for (TableRow row : aggregate.rows())
  {
    total_weight += row.getInt("Total_Num_Tweets") + row.getInt("Total_Num_Retweets") + row.getInt("Total_Num_Favorites");

  }

  for (TableRow row : aggregate.rows())
  {
    int weight = row.getInt("Total_Num_Tweets") + row.getInt("Total_Num_Retweets") + row.getInt("Total_Num_Favorites");
    println(row.getString("#Label"));
    wordArray[count] = new Word(row.getString("#Label"), weight/total_weight);  
    count++;
  }
  
}

void processDataPopularity()
{
  zeroPopularityByDate();
    
  int year; 
  String s_month; 
  int i_month; 
  
  for(int currCSV = 0; currCSV < NUM_CSV; currCSV++)
  {
    for(TableRow row : data[currCSV].rows())
    {
      try { 
        year = row.getInt(YEAR); 
        s_month = row.getString(MONTH);
        
        if(s_month.equals("Jan")) i_month = 0; 
        else if(s_month.equals("Feb")) i_month = 1;
        else if(s_month.equals("Mar")) i_month = 2;
        else if(s_month.equals("Apr")) i_month = 3;
        else if(s_month.equals("May")) i_month = 4;
        else if(s_month.equals("Jun")) i_month = 5;
        else if(s_month.equals("Jul")) i_month = 6;
        else if(s_month.equals("Aug")) i_month = 7;
        else if(s_month.equals("Sep")) i_month = 8;
        else if(s_month.equals("Oct")) i_month = 9;
        else if(s_month.equals("Nov")) i_month = 10;
        else                      i_month = 11; //(s_month == "Dec")
        
        popularityByDate[year - 2006][i_month][currCSV][S_COUNT] = 
          popularityByDate[year - 2006][i_month][currCSV][S_COUNT] + 1;
        popularityByDate[year - 2006][i_month][currCSV][S_RETWEET] =
          popularityByDate[year - 2006][i_month][currCSV][S_RETWEET] + row.getInt(RETWEET_COUNT);
        popularityByDate[year - 2006][i_month][currCSV][S_FAVORITE] =
          popularityByDate[year - 2006][i_month][currCSV][S_FAVORITE] + row.getInt(FAVORITE_COUNT);
      }  catch (Exception e) {
        // do nothing, this tweet doesn't have an assocated date
      }
    
    }
  }
}

void zeroPopularityByDate()
{
  for(int i = 0; i < YEAR; i++)
  {
    for(int j = 0; j < MONTH; j++)
    {
      for(int k = 0; k < NUM_CSV; k++)
      {
        for(int m = 0; m < STYLE; m++)
        {
          popularityByDate[i][j][k][m] = 0;
        }
      }
    }
  }
}