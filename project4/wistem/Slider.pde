public class Slider 
{
  private int m_xpos;
  private int m_ypos; 
  private int m_width; 
  private int m_height; 
  
  private int m_swidth; 
  private int m_sheight;
  private float m_spos; // between 0 and 1 
  
  public Slider(int x, int y, int w, int h)
  {
    m_xpos = x; 
    m_ypos = y; 
    m_width = w; 
    m_height = h; 
    
    m_swidth = 10; 
    m_sheight = h; 
    m_spos = 0; 
  }
  
  public void draw()
  {
    int curFill = g.fillColor;
    int curStroke = g.strokeColor;
    
    
    noStroke();
    fill(204);
    rect(m_xpos, m_ypos, m_width, m_height);
    
    fill(102, 102, 102);
    
    rect(m_spos * (m_width - m_swidth), m_ypos, m_swidth, m_sheight);
    fill(curFill); 
    stroke(curStroke);
  }
  
  public boolean overEvent()
  {
    return (mouseY > m_ypos && mouseY < m_ypos + m_height); 
  }
  
  public void press()
  {
    if(mouseX > m_width - (m_swidth/2)) { setPos(1); }
    else if(mouseX < m_swidth/2) { setPos(0); }
    else { setPos((mouseX-((float)m_swidth/2)) / (float)(m_width - m_swidth)); }
  }
  
  public void setPos(float pos)
  {
    m_spos = pos; 
  }

  public float getPos()
  {
    return m_spos;
  }
}