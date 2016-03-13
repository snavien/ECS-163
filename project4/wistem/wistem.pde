import org.gicentre.treemappa.*;
import org.gicentre.handy.*;
import org.gicentre.utils.colour.*;


HandyRenderer h;

void setup()
{
  size(300, 200);
  h = new HandyRenderer(this);
}

void draw()
{

  background(235,215,182);
  fill(206, 76, 52);
  strokeWeight(2);
  h.rect(75,50,150,100);
  h.setIsHandy(false);
  //h.setSeed();

}

void mouseClicked()
{
}