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
static final int YEARS   = 10; 
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

void readData()
{
  for(int i = 0; i < NUM_CSV; i++)
  {
    data[i] = loadTable(dataPath("") + hashtag[i] + ".csv"); 
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
      year = row.getInt(YEAR); 
      s_month = row.getString(MONTH);
      
      if(s_month == "Jan") i_month = 0; 
      else if(s_month == "Feb") i_month = 1;
      else if(s_month == "Mar") i_month = 2;
      else if(s_month == "Apr") i_month = 3;
      else if(s_month == "May") i_month = 4;
      else if(s_month == "Jun") i_month = 5;
      else if(s_month == "Jul") i_month = 6;
      else if(s_month == "Aug") i_month = 7;
      else if(s_month == "Sep") i_month = 8;
      else if(s_month == "Oct") i_month = 9;
      else if(s_month == "Nov") i_month = 10;
      else                      i_month = 11; //(s_month == "Dec")
      
      popularityByDate[year - 2006][i_month][currCSV][S_COUNT] = 
        popularityByDate[year - 2006][i_month][currCSV][S_COUNT] + 1;
      popularityByDate[year - 2006][i_month][currCSV][S_RETWEET] =
        popularityByDate[year - 2006][i_month][currCSV][S_RETWEET] + row.getInt(RETWEET_COUNT);
      popularityByDate[year - 2006][i_month][currCSV][S_FAVORITE] =
        popularityByDate[year - 2006][i_month][currCSV][S_FAVORITE] + row.getInt(FAVORITE_COUNT);
       
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