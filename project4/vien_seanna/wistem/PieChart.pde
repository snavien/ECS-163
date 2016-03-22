public class PieChart
{
  float [] data = {8787308/15157730.0, 8992599/15464197, 92429814/16210103.0,
                  10094332/17404882.0, 10379172/17915,952.0, 10382782/17878363.0,
                  10151705/17514160.0};
  Integer [] years = {2006,2007,2008,2008,2009,2010,2011,2012};
  void drawPieChart(float diameter, float[] data) 
  {
    float lastAngle = 0;
    for (int i = 0; i < data.length; i++) 
    {
      fill(255);
      textSize(20);

      float gray = map(i, 0, log(data[i]), 0, 200);
      fill(gray);
      
    
      arc(width - diameter + 60, height - (diameter * 2), diameter, diameter, lastAngle, lastAngle+radians(angles[i]));
      lastAngle += radians(angles[i]);
    }
  }
}