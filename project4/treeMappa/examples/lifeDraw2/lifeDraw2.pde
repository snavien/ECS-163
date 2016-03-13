import org.gicentre.treemappa.*;     // For treemappa classes
import org.gicentre.utils.colour.*;  // Colours needed by treemappa.
import org.gicentre.utils.move.*;    // For the ZoomPan class.

// Simple example to draw a simple treemap with some appearance 
// customisation and a zoomable dispaly.
// Jo Wood, giCentre, 3rd April, 2014.

PTreeMappa pTreeMappa;
ZoomPan zoomer;

void setup()
{
  size(500,300);
  zoomer = new ZoomPan(this);  
  
  // Display labels in a serif font
  textFont(createFont("serif",40));

  // Create an empty treemap.    
  pTreeMappa = new PTreeMappa(this);
  
  // Load the data and build the treemap.
  pTreeMappa.readData("life.csv"); 
  
  // Customise the appearance of the treemap
   
  TreeMapPanel tmPanel = pTreeMappa.getTreeMapPanel();
  tmPanel.setBorders(12);
  tmPanel.setShowLeafBorders(true);
  tmPanel.setBorder(0,0);      // No border around entire treemap.
  tmPanel.setBorder(2,6);      // Make leaf-level borders 6 pixels wide.
  tmPanel.setCurvature(10);    // Rounded rectangles.
   
  tmPanel.setShowBranchLabels(true);
  tmPanel.setLeafTextAlignment(RIGHT,BOTTOM);
  tmPanel.setBranchMaxTextSize(0,80);
  tmPanel.setBranchMaxTextSize(1,30);
  tmPanel.setLeafMaxTextSize(12);
  tmPanel.setAllowVerticalLabels(true);
  tmPanel.setBranchTextColours(color(0,50));
  tmPanel.setLeafTextColour(color(0,0,80));
  
  tmPanel.setColourTable(ColourTable.readFile(createInput("life.ctb")));
  tmPanel.setLayouts("strip");
  
  // Layout needs updating because we have changed border size and treemap layout.
  tmPanel.updateLayout();
}

void draw()
{
  background(255);
  
  zoomer.transform();    // Allow zooming and panning.
  pTreeMappa.draw();     // Get treemappa to draw itself.
}
