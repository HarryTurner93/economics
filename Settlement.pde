class Settlement
{
  color colour_;
  
  PVector location_;
  
  int treeCount, goldCount, cowCount;
  int treeReq, goldReq, cowReq;
  int treeSell, goldSell, cowSell;
  int treeBuy, goldBuy, cowBuy;
  int treeValue, goldValue, cowValue;
  
  boolean wantCow, wantGold, wantTree, wantOutpost, wantVillager;
  
  int money;
  
  int NUM_VILLAGERS_START = 10;
  
  ArrayList<Villager> villagers_;
  ArrayList<Outpost> outposts_;
  
  //Constructor - Set position variables
  Settlement(int x, int y)
  {
    //Pick a random colour that is light
    float red = random(150, 255);
    float green = red + random(-50, 50);
    if(green > 255) green = 255;
    float blue = red + random(-50, 50);
    if(blue > 255) blue = 255;
    
    colour_ = color(int(red), int(green), int(blue));
    
    //Set the location and check it doesn't collide with any resources
    location_ = new PVector(x, y);
    
    //Initialise all villagers in the array
    villagers_ = new ArrayList<Villager>();
    for(int i = 0; i < NUM_VILLAGERS_START; i++)
    {
      Villager villager = new Villager(int(location_.x), int(location_.y), colour_, this);
      villagers_.add(villager);
    }
    
    //Initialise all outposts in the array
    outposts_ = new ArrayList<Outpost>();
    
    wantCow = wantTree = wantGold = true;
    wantOutpost = wantVillager = false;
    money = 100;
  }
  
  void eat()
  {
    cowCount -= (int(villagers_.size()/3)+1);
    if(cowCount < 0)  {  villagers_.remove(0 - cowCount);  cowCount = 0;  }
  }
  
  void update()
  {
    //Update all the villagers
    for(int i = 0; i < villagers_.size(); i++)
    {
      villagers_.get(i).update();
    }
    
    //Settlement Logic
     
    
    //Determine requirements
   
    //5 villagers per outpost, determine outpost needs
    if(((villagers_.size()-5)/5) > outposts_.size()){  wantOutpost = true;  }
    else {  wantOutpost = false;  }
    
    if(cowCount > villagers_.size())  {  wantVillager = true;  }
    else  { wantVillager = false;  }
    
    //Determine tree and gold requirements, based on outpost needs
    if(wantOutpost){ treeReq = 20; goldReq = 10;   }
    else {  treeReq = 10; goldReq = 5;  }
    
    //Determine cow requirements, based on villager needs.
    if(wantVillager){ cowReq = 20+(villagers_.size()/3);  }
    else {  cowReq = villagers_.size()/3;  }
    
    //Determine Values
    cowValue = cowReq - cowCount;
    if(cowValue < 1)cowValue = 1;
    
    goldValue = goldReq - goldCount;
    if(goldValue < 1)goldValue = 1;
    
    treeValue = treeReq - treeCount;
    if(treeValue < 1)treeValue = 1;
    
    
    
    // Create things
    //If 20 cow, create a villager
    if(cowCount >= 20+(villagers_.size()/3))
    {
      Villager villager = new Villager(int(location_.x), int(location_.y), colour_, this);
      villagers_.add(villager);
      cowCount -= 5;
    }
    
    //If 20 tree, 10 gold, create an outpost
    if((treeCount >= 20)&&(goldCount >= 10))
    {
      Outpost outpost = new Outpost(int(random(100, 900)), int(random(100, 900)), colour_, this);
      outposts_.add(outpost);
      treeCount -= 20; goldCount -= 10;
    }
  }
  
  int trade(Settlement settlement)
  {
    if((settlement.treeValue > treeValue)&&(treeCount > 0)){  treeCount--; money+= treeValue; settlement.money -= treeValue; return 1;  }
    if((settlement.goldValue > goldValue)&&(goldCount > 0)){  goldCount--; money+= goldValue; settlement.money -= goldValue; return 2;  }
    if((settlement.cowValue > cowValue)&&(cowCount > 0)){  cowCount--; money+= cowValue; settlement.money -= cowValue; return 3;  }
    return 0;
  }
  
  void draw()
  {
    //Draw the settlement
    fill(colour_);
    rect(location_.x-40, location_.y-40, 80, 80);
    
    String[] treeData = new String[3]; 
    treeData[0] = str(treeCount); 
    treeData[1] = str(treeReq); 
    treeData[2] = str(treeValue);  
    String treeText = join(treeData, ":"); 
    
    String[] goldData = new String[3]; 
    goldData[0] = str(goldCount); 
    goldData[1] = str(goldReq); 
    goldData[2] = str(goldValue);  
    String goldText = join(goldData, ":"); 
    
    String[] cowData = new String[3]; 
    cowData[0] = str(cowCount); 
    cowData[1] = str(cowReq); 
    cowData[2] = str(cowValue);  
    String cowText = join(cowData, ":"); 
    
    //Draw resource counts
    textSize(12); textAlign(LEFT);fill(0, 0, 0);
    image(treeIcon, location_.x-40, location_.y-40, 20, 20); text(treeText, (location_.x-20), (location_.y-30));
    image(goldIcon, location_.x-40, location_.y-20, 20, 20); text(goldText, (location_.x-20), (location_.y-10));
    image(cowIcon, location_.x-40, location_.y, 20, 20); text(cowText, (location_.x-20), (location_.y+10));
    text(money, (location_.x-40), (location_.y+30));
    text(villagers_.size(), (location_.x+20), (location_.y+30));
    //Draw all the villagers
    for(int i = 0; i < villagers_.size(); i++)
    {
      villagers_.get(i).draw();
    }
    
    //Draw all the outposts
    for(int i = 0; i < outposts_.size(); i++)
    {
      outposts_.get(i).draw();
    }
  }
}

class Outpost
{
  color colour_;
  Settlement homeSettlement_;
  PVector location_;
  
  //Constructor - Set position variables
  Outpost(int x, int y, color colour, Settlement homeSettlement)
  {
    homeSettlement_ = homeSettlement;
    colour_ = colour;
    
    //Set the location
    location_ = new PVector(x, y);
  }
  
  void draw()
  {
    //Draw the settlement
    fill(colour_);
    rect(location_.x-20, location_.y-20, 40, 40);
  }
}

class Villager
{
  color colour_;
  Settlement homeSettlement_;
  Settlement lastTrader;
  PVector home_;
  PVector location_;
  PVector velocity_;
  int resourceCode;
  int state;
  
  int delay;
  
  int treeSkill, goldSkill, cowSkill;
  
  //Constructor - Set position variables
  Villager(int x, int y, int colour, Settlement homeSettlement)
  {
    homeSettlement_ = homeSettlement;
    location_ = new PVector(x, y);
    home_ = location_.copy();
    velocity_ = new PVector(0, 0);
    colour_ = colour;
    resourceCode = 0;  state = 0;  delay = 0;
  }
  
  void draw()
  {
    if((state==2)||(state==3))
    {
      stroke(255, 0, 0);
      line(lastTrader.location_.x, lastTrader.location_.y, homeSettlement_.location_.x, homeSettlement_.location_.y);
    }
    
    fill(colour_);
    stroke(0,0,0);
    ellipse(location_.x, location_.y, 10, 10);
    
    switch(resourceCode)
    {
      case 0:break;
      case 1:image(treeIcon,location_.x, location_.y, 20, 20); break;
      case 2:image(goldIcon,location_.x, location_.y, 20, 20); break;
      case 3:image(cowIcon,location_.x, location_.y, 20, 20); break;
    }
  }
  
  void update()
  {
    if(delay==0)
    {
      PVector move = new PVector(0, 0);
      
      if(state==0)
      {
         move = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
      }
      else if((state==1)||(state==2))
      {
        //An efficiency gain could be made here by pre determining which is closer, rather than calculatig move every time.
         move = PVector.sub(home_, location_);
         for(int i = 0; i < homeSettlement_.outposts_.size(); i++)
         {
           if(PVector.sub(homeSettlement_.outposts_.get(i).location_, location_).mag() < move.mag())
           {
             move = PVector.sub(homeSettlement_.outposts_.get(i).location_, location_);
           }
         }
       
      }
      else if((state==3))
      {
        //An efficiency gain could be made here by pre determining which is closer, rather than calculatig move every time.
         move = PVector.sub(location_, home_);
      }
    
      velocity_.add(move);
      velocity_.limit(1);
    
      location_.add(velocity_);
    
      //Constrain the location to the map
      if(location_.x < 10) location_.x = 10;
      if(location_.x > 990) location_.x = 990;
      if(location_.y < 10) location_.y = 10;
      if(location_.y > 990) location_.y = 990;
    
      //If the code is not 0, aka, if the villager is not carrying anything yet, check to see if they hit a resource.
      if(resourceCode==0)  resourceCode = checkResourceCollision();
      if((resourceCode==-1)||(resourceCode==0)) resourceCode = checkSettlementCollision();
      
      //If villager is heading home, start checking for home collision
      if((state==1)||(state==2)) checkHomeCollision();
    }
    else
    {
      delay--;
    }
  }
  
  int checkResourceCollision()
  {
    //Check all the resources for collisions
    for(int i = 0; i < NUM_RESOURCES; i++)
    {
      if((location_.x > resources[i].location_.x)&&(location_.x < resources[i].location_.x+resources[i].width_)&&(location_.y > resources[i].location_.y)&&(location_.y < resources[i].location_.y+resources[i].height_))
      {
        //If a resource is hit, delay for a while and return the code of the resource for later, set state 1 to head for home
        int code = resources[i].getCode();
        
        switch(code)
        {
          case 0:break;
          case 1: if((treeSkill < goldSkill)||(treeSkill < cowSkill)){return 0;} delay = (1200-treeSkill); treeSkill+=50; if(treeSkill > 1200) treeSkill = 1200; resources[i].deduct(); break;
          case 2: if((goldSkill < cowSkill)||(goldSkill < treeSkill)){return 0;}delay = (2000-goldSkill); goldSkill+=50; if(goldSkill > 2000) goldSkill = 2000; resources[i].deduct();break;
          case 3: if((cowSkill < treeSkill)||(cowSkill < goldSkill)){return 0;}delay = (1000-cowSkill); cowSkill+=50; if(cowSkill > 1000) cowSkill = 1000; resources[i].deduct();break;
        }
        state = 1;
        return resources[i].getCode();
      }
    }
    
    //If no match is found, return 0, which means nothing.
    return 0;
  }
  
  int checkSettlementCollision()
  {
    //Check all the settlements for collisions
    for(int i = 0; i < NUM_SETTLEMENTS; i++)
    {
      if(settlements[i] != homeSettlement_)
      {
        if((location_.x > settlements[i].location_.x-40)&&(location_.x < settlements[i].location_.x+40)&&(location_.y > settlements[i].location_.y-40)&&(location_.y < settlements[i].location_.y+40))
        {
          //If a settlement is hit, delay for a while and return the code of the resource for later, set state 1 to head for home
          int tradeValue = settlements[i].trade(homeSettlement_);
          if (tradeValue != 0) 
          {
            state = 2;
            delay = 50;
          }
          else state = 0;
          
          lastTrader = settlements[i];
          
          return tradeValue;
        }
      }
    }
    return 0;
  }
  
  void checkHomeCollision()
  {
    if((location_.x > (home_.x-40))&&(location_.x < (home_.x+40))&&(location_.y > (home_.y-40))&&(location_.y < (home_.y+40)))
    {
      //If home is hit, delay for a while and return state to 0 to start looking for more resources
      if(resourceCode==1)homeSettlement_.treeCount++;
      if(resourceCode==2)homeSettlement_.goldCount++;
      if(resourceCode==3)homeSettlement_.cowCount++;
      delay = 50; 
      if(state==1){state = 0;resourceCode = 0; }
      if(state==2){state = 3;resourceCode = -1;}
    }
    
    //Check hits with any outposts
    for(int i = 0; i < homeSettlement_.outposts_.size(); i++)
    {
      if((location_.x > (homeSettlement_.outposts_.get(i).location_.x-20))&&(location_.x < (homeSettlement_.outposts_.get(i).location_.x+20))&&(location_.y > (homeSettlement_.outposts_.get(i).location_.y-20))&&(location_.y < (homeSettlement_.outposts_.get(i).location_.y+20)))
      {
        //If home is hit, delay for a while and return state to 0 to start looking for more resources
        if(resourceCode==1)homeSettlement_.treeCount++;
        if(resourceCode==2)homeSettlement_.goldCount++;
        if(resourceCode==3)homeSettlement_.cowCount++;
        delay = 50; 
        if(state==1){state = 0;resourceCode = 0; }
        if(state==2){state = 3;resourceCode = -1;}
      }
    }
  }
}