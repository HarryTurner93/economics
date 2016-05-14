ArrayList<Settlement> settlements;
ArrayList<Resource> resources;

int NUM_RESOURCES = 50;

//Icons for general use throughout the program
PImage treeIcon;
PImage goldIcon;
PImage cowIcon;

int globalTimer;

void setup() 
{
  //Size of the canvas
  size(1000, 1000);
  
  //Load the images for the icons
  treeIcon = loadImage("tree.png");
  goldIcon = loadImage("gold.png");
  cowIcon = loadImage("cow.png");
  
  //Intialise the array of resources
  resources = new ArrayList<Resource>();
  
  //Initialise all resources in the array with a random resource
  for(int i = 0; i < NUM_RESOURCES; i++)
  {
    int select = int(random(0, 20));

    if(select < 3)
    {
      Resource resource = new Gold(int(random(100,900)), int(random(100,900)));
      resources.add(resource);
    }
    else if(select < 14)
    {
      Resource resource = new Cow(int(random(100,900)), int(random(100,900)));
      resources.add(resource);
    }
    else
    {
      Resource resource = new Tree(int(random(100,900)), int(random(100,900)));
      resources.add(resource);
    }
    
  }
  
  //Initialise settlements
  settlements = new ArrayList<Settlement>();
  
  //Get the initial timer value
  globalTimer = millis();
}

void update()
{
  //Runs once every minute
  if(millis() - globalTimer > 60000)
  {
    for(int i = 0; i < settlements.size(); i++)
    {
      settlements.get(i).eat();
      globalTimer = millis();
    }
  }
  //Runs every loop
  else
  {
    //Update all the settlements
    for(int i = 0; i < settlements.size(); i++)  {  settlements.get(i).update();  }
  }
}

void draw() 
{
  //Call the update function
  update();
  
  //Set background to white
  background(255, 255, 255);
  
  //Draw all the resources
  for(int i = 0; i < resources.size(); i++)  {  resources.get(i).draw();  }
  
  //Draw all the settlements
  for(int i = 0; i < settlements.size(); i++)  {  settlements.get(i).draw();  }
  
  // Draw the time in the top left corner
  textSize(24);  fill(0,0,0);
  text(60 - ((millis() - globalTimer)/1000), (20), (20));
}

//The mouse click places a settlement, the variable 
// currentSettlementPlaced keeps track of which settlement is being placed.
void mouseClicked()
{
   Settlement settlement = new Settlement(mouseX, mouseY);
   settlements.add(settlement);
}