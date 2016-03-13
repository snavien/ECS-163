import org.gicentre.treemappa.*;     // For treemappa classes
import org.gicentre.utils.colour.*;  // Colours needed by treemappa.
import org.gicentre.utils.move.*;    // For the ZoomPan class.

// Draws a complex treemap with appearance customisation and zoomable display.
// Jo Wood, giCentre, 3rd April, 2013

PTreeMappa pTreeMappa;
ZoomPan zoomer;

void setup()
{
  size(1000,700);
  zoomer = new ZoomPan(this);  
  
  // Display labels in a serif font
  textFont(createFont("serif",40));

  // Create an empty treemap.    
  pTreeMappa = new PTreeMappa(this);
  
  // Load the data and build the treemap.
  pTreeMappa.readData("ontology.xml","treeML"); 
  
  // Customise the appearance of the treemap 
  pTreeMappa.getTreeMapPanel().setShowBranchLabels(true);
  pTreeMappa.getTreeMapPanel().setLeafMaxTextSize(4);
  pTreeMappa.getTreeMapPanel().setAllowVerticalLabels(true);
  pTreeMappa.getTreeMapPanel().setBranchTextColours(color(0,50));
   
  pTreeMappa.getTreeMapPanel().setBorders(0);
  pTreeMappa.getTreeMapPanel().setBorderColour(color(255));
  
  pTreeMappa.getTreeMapPanel().setLayouts("sliceAndDice");
  
  // Layout needs updating because we have changed border size and the
  // treemap layout algorithm.
  pTreeMappa.getTreeMapPanel().updateLayout();
}

void draw()
{
  background(255);
  
  // Allow zooming and panning.
  zoomer.transform();
  
  // Get treemappa to draw itself.
  pTreeMappa.draw();
}
