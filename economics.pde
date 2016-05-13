Settlement[] settlements;
Resource[] resources;

int NUM_RESOURCES = 50;
int NUM_SETTLEMENTS = 3;

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
  
  //Intialise the vector of resources
  resources = new Resource[NUM_RESOURCES];
  
  //Initialise all resources in the array with a random resource
  for(int i = 0; i < NUM_RESOURCES; i++)
  {
    int select = int(random(0, 20));

    if(select < 3)
    {
      resources[i] = new Gold(int(random(100,900)), int(random(100,900)));
    }
    else if(select < 14)
    {
      resources[i] = new Cow(int(random(100,900)), int(random(100,900)));
    }
    else
    {
      resources[i] = new Tree(int(random(100,900)), int(random(100,900)));
    }
  }
  
  //Initialise settlements
  settlements = new Settlement[NUM_SETTLEMENTS];
  for(int i = 0; i < NUM_SETTLEMENTS; i++)
  {
    settlements[i] = new Settlement(int(random(100,900)), int(random(100,900)));
  }
  
  globalTimer = millis();
}

void update()
{
  if(millis() - globalTimer > 60000)
  {
    for(int i = 0; i < NUM_SETTLEMENTS; i++)
    {
      settlements[i].eat();
      globalTimer = millis();
    }
  }
  //Update all the settlements
  for(int i = 0; i < NUM_SETTLEMENTS; i++)
  {
    settlements[i].update();
  }
}

void draw() 
{
  //Call the update function
  update();
  
  //Set background to white
  background(255, 255, 255);
  
  //Draw all the resources
  for(int i = 0; i < NUM_RESOURCES; i++)
  {
    resources[i].draw();
  }
  
  //Draw all the settlements
  for(int i = 0; i < NUM_SETTLEMENTS; i++)
  {
    settlements[i].draw();
  }
  
  textSize(24);
  fill(0,0,0);
  text(60 - ((millis() - globalTimer)/1000), (20), (20));
}