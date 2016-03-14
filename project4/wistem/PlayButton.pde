//public class PlayButton
//{
//  private boolean m_isPlaying;
//  private int m_xpos; 
//  private int m_ypos;
//  private int t_size = 15;
//  private int m_xmargin = 10;
//  private int m_fill   = 50; 
//  private int m_stroke = 50; 
  
//  PlayButton(int xpos, int ypos)
//  {
//    m_isPlaying = true; 
//    m_xpos = xpos; 
//    m_ypos = ypos;
    
//  }
//  public boolean isPlaying() { return m_isPlaying; }
//  public void Pause() { m_isPlaying = false; }
//  public void Play()  { m_isPlaying = true;  }
  
//  public void draw()
//  {
//    int curFill = g.fillColor;
//    int curStroke = g.strokeColor; 
    
//    fill(m_fill);
//    stroke(m_stroke);
    
//    if(m_isPlaying) { drawPause();  }
//    else            { drawPlay(); }
    
//    fill(curFill);
//    stroke(curStroke);
//  }
  
//  public void press() 
//  {
//     m_fill = 100; 
//     m_stroke = 100; 
//  }
  
//  public void unpress()
//  {
//    m_fill = 50;
//    m_stroke = 50;
//  }  
  
//  public void click()
//  {
//    m_fill = 50; 
//    m_stroke = 50;
//    m_isPlaying = !m_isPlaying; 
//  }
  
//  public boolean overEvent()
//  {
//    return (((mouseX > m_xpos) && (mouseX < m_xpos + 2*m_xmargin + t_size)) 
//         && ((mouseY > m_ypos) && (mouseY < m_ypos + t_size)));
//  }
  
//  private void drawPlay()
//  {
//    triangle(m_xpos+m_xmargin, m_ypos,
//             m_xpos+m_xmargin, m_ypos + t_size,
//             m_xpos+m_xmargin + t_size, m_ypos + (t_size * .5));
//  }
//  private void drawPause()
//  {
//    rect(m_xpos+m_xmargin, m_ypos, 5, t_size);
//    rect(m_xpos+m_xmargin + 9, m_ypos, 5, t_size);
//  }
//}