import org.gicentre.treemappa.*;
import org.gicentre.handy.*;
import org.gicentre.utils.colour.*;
<<<<<<< HEAD
import org.gicentre.utils.move.*;    // For the ZoomPan class.

// Draws a complex treemap with appearance customisation and zoomable display.
// Jo Wood, giCentre
// V1.4, 23rd March, 2011.

PTreeMappa pTreeMappa;
ZoomPan zoomer;

HandyRenderer[] hashtags = new HandyRenderer[9];

void setup()
{
  size(1000, 800);
  smooth();
  noLoop();
  
  zoomer = new ZoomPan(this);  
  textFont(createFont("Helvetica",100));

 

  for (int i = 0; i < 9; i++)
  {
    hashtags[i] = HandyPresets.createColouredPencil(this);
  }

  pTreeMappa = new PTreeMappa(this);
  pTreeMappa.readData("aggregate.csv");
  pTreeMappa.setColourTable("red");
  
   // Customise the appearance of the treemap
//  pTreeMappa.getTreeMapPanel().setBorders(0);
//  
//  pTreeMappa.getTreeMapPanel().setShowBranchLabels(true);
//  pTreeMappa.getTreeMapPanel().setBranchMaxTextSize(0,80);
//  pTreeMappa.getTreeMapPanel().setBranchMaxTextSize(1,30);
//  pTreeMappa.getTreeMapPanel().setLeafMaxTextSize(20);
//  pTreeMappa.getTreeMapPanel().setAllowVerticalLabels(true);
//  pTreeMappa.getTreeMapPanel().setBranchTextColours(color(0,50));
//  pTreeMappa.getTreeMapPanel().setLeafTextColour(color(0,0,80));
//  pTreeMappa.getTreeMapPanel().updateLayout();

  
  // Load the data and build the treemap
=======


HandyRenderer h;

void setup()
{
  size(300, 200);
  h = new HandyRenderer(this);
>>>>>>> 8231c33b96c46eedff0da1b4d4ab059cc4a9de6b
}

void draw()
{
<<<<<<< HEAD
    background(255);
    zoomer.transform();

//  background(235, 215, 182);
//
//  for (int i = 0; i < 9; i++)
//  {
//    fill(206+random(-30, 30), 76+random(-30, 30), 52+random(-30, 30), 160);
//    hashtags[i].rect(random(10, 200), random(10, 50), 80, 50);
//  }
//  
  pTreeMappa.draw();
}
=======

  background(235,215,182);
  fill(206, 76, 52);
  strokeWeight(2);
  h.rect(75,50,150,100);
  h.setIsHandy(false);
  //h.setSeed();

}
>>>>>>> 8231c33b96c46eedff0da1b4d4ab059cc4a9de6b
