int NODE_SIZE = 25;
int NUM_LEVELS = 6;
int Y_SPACE = 75;

Tree oak;


void setup()
{
  size(800, 500);
  oak = new Tree(width/2, NODE_SIZE + 10, NUM_LEVELS, false);
  oak.display();

}//setup


void draw()
{
  background(255);
  oak.balanceColor();
  oak.display();
  mouseOver();
}//draw


void mouseOver()
{
  PVector mouse = new PVector(mouseX, mouseY);
  TreeNode selected = oak.getSelected(mouse);
  if (selected != null) {
    fill(0, 255, 255);
    square(mouseX-5, mouseY-20, 20);
    textAlign(LEFT, BOTTOM);
    fill(0);
    textSize(20);
    text(oak.getHeight(selected), mouse.x, mouse.y);
  }
}//mousePressed

void mousePressed()
{
  PVector mouse = new PVector(mouseX, mouseY);
  TreeNode selected = oak.getSelected(mouse);
  
  if (selected != null) {
    if (mouseButton == LEFT) {
      oak.addNode(selected);
    } else if (mouseButton == RIGHT) {
      oak.removeNode(selected);
    }
  }
}


void keyPressed()
{
  if (key == 'r') {
    oak.reset(false);
  }
  if (key == 'f') {
    oak.reset(true);
  }
}//keyPressed
