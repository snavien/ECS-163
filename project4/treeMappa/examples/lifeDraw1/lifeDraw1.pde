import org.gicentre.treemappa.*;      // For treemappa classes
import org.gicentre.utils.colour.*;   // Colours needed by treemappa.

// Minimal example to draw a simple treemap directly in a sketch.
// Jo Wood, giCentre
// V1.3, 3rd April, 2014.

PTreeMappa pTreeMappa;                // Stores the treemap.

void setup()
{
  size(500,300);
  
  pTreeMappa = new PTreeMappa(this);  // Create an empty treemap.    
  pTreeMappa.readData("life.csv");    // Load the data and build the treemap. 
}

void draw()
{
  background(255);
  pTreeMappa.draw(); // Get treemappa to draw itself.

  noLoop();          // Draw once only.
}
