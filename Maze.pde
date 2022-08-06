int w = 10;

ArrayList<Cell> grid = new ArrayList<Cell>();
ArrayList<Cell> stack = new ArrayList<Cell>();
ArrayList<Cell> unstack = new ArrayList<Cell>();

byte[] a = new byte[3];

Cell current;

Player player;
Player randPlayer;
int randCount = 0;
int randIndex = 0;

int wamount;
int hamount;

int maxStack = -1;

int farCellIndex;

boolean capture = true;
boolean quickMake = true;
boolean solution = false;
boolean play = false;
boolean randPlay = false;

// Used to be able to save the maze as JSON
JSONArray outFile;

void setup() {
  size(10000, 10000);
  //randomSeed(100);
  
  wamount = floor(width/w);
  hamount = floor(height/w);
  
  // Initialise the JSONArray
  outFile = new JSONArray();
  JSONArray values;
  JSONObject outCell;
  
  // Initialise Cells and add them to JSON
  for (int i = 0; i < hamount; i++) {
    values = new JSONArray();
    for (int j = 0; j < wamount; j++) {
      Cell cell = new Cell(j, i);
      grid.add(cell);
      
      // Initialise each JSONObject
      outCell = new JSONObject();
      outCell.setInt("xIndex", j);
      outCell.setBoolean("North", false);
      outCell.setBoolean("East", false);
      outCell.setBoolean("South", false);
      outCell.setBoolean("West", false);
      outCell.setBoolean("Finish", false);
      values.setJSONObject(j, outCell);
    }
    outFile.setJSONArray(i, values);
  }
  current = grid.get(0);
  
  //
  player = new Player(current.x, current.y, w);
  randPlayer = new Player(current.x, current.y, w);
  //frameRate(5);
}

void draw() {
  background(100);
  
  
  if (!capture) {
    for (int i = 0; i < grid.size(); i++) {
        grid.get(i).show();
    }
  }
  
  
  int perFrame = 1;
  if (quickMake) {
    perFrame = 1500;
  }
  
  
  for (int i = 0; i < perFrame; i++) {
    //current.highlight();
    current.visited = true;
    
    Cell next = current.checkNeighbours();
    if (next != null) {
      next.visited = true;
      stack.add(current);
      //
      current.removeWalls(outFile, next);
      current = next;
    } else if (stack.size() > 0) {
      current = stack.remove(stack.size()-1);
    }
    if (stack.size() > maxStack && stack.size() > wamount + hamount) {
      maxStack = stack.size();
      farCellIndex = current.x + current.y * wamount;
      
      if (solution) {
        for (int j = 0; j < stack.size(); j++) {
          if (j < unstack.size()) {
            unstack.set(j, stack.get(j));
          } else {
            unstack.add(stack.get(j));
          }
        }
      }
    }
    if (stack.size() == 0 && grid.get(wamount * hamount - 1).visited) {
      end();
      break;
    }
  }
  
  if (play) {
    player.move();
    player.show();
  }
  
  //randPlayer.randShow();
  //randCount ++;
  //if (randCount >= 1) {
  //  for (int i = 0; i < 10; i++) {
  //    if (randIndex != unstack.size()) {
  //      randPlayer.x = unstack.get(randIndex).x;
  //      randPlayer.y = unstack.get(randIndex).y;
  //      randIndex ++;
  //    } else {
  //      break;
  //    }
  //  }
  //  randCount = 0;
  //}
}



void end() {
  // Save the JSON file
  JSONArray iArray = outFile.getJSONArray(farCellIndex / wamount);
  JSONObject jCell = iArray.getJSONObject(farCellIndex % wamount);
  jCell.setBoolean("Finish", true);
  saveJSONArray(outFile, "maze.json");
  
  for (int i = 0; i < grid.size(); i++) {
      grid.get(i).show();
  }
  grid.get(farCellIndex).highlight();
  
  if (solution) {
    stroke(200, 0, 100);
    for (int i = 0; i < unstack.size() - 1; i++) {
      line(w * unstack.get(i + 1).x + w /2 , w * unstack.get(i + 1).y + w / 2, w * unstack.get(i).x + w / 2, w * unstack.get(i).y + w / 2);
    }
  }
  
  if (capture) {
    stroke(0);
    strokeWeight(2);
    line(width, 0, width, height);
    line(0, height, width, height);
    stroke(255);
    line(1, 0, w - 1, 0);
    save("newMaze.png");
    exit();
  } else {
    noLoop();
    print("finished");
  }
}

void keyPressed() {
  player.move();
}
