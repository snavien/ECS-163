class Rainbow 
{
  color[] m_color = {color(220,20,60), color(255,127,80), color(255,140,0), color(255,215,0), 
                   color(0,100,0), color(144,238,144),color(32,178,170), color(100,149,237),
                   color(25,25,112), color(75,0,130), color(128,0,128)};; 
  final color[] original = {color(220,20,60), color(255,127,80), color(255,140,0), color(255,215,0), 
                   color(0,100,0), color(144,238,144),color(32,178,170), color(100,149,237),
                   color(25,25,112), color(75,0,130), color(128,0,128)};;
  Rainbow() {}
  
  color[] getArray() { return m_color; }
  color   getColor(int i) { return m_color[i]; }
  void    setAlpha(int i, float a) { 
    m_color[i] = color((m_color[i]) >> 16 & 0xFF, (m_color[i]) >> 8 & 0xFF, (m_color[i]) & 0xFF, a);
  }
  

  void resetColor() {
    for(int i = 0; i < NUM_CSV; i++)
    {
      m_color[i] = original[i]; 
    }
  } 
}