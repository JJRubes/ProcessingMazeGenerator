class Cell {
  int x, y;
  boolean tWall = true;
  boolean lWall = true;
  
  boolean visited = false;
  
  Cell(int i, int j) {
    this.x = i;
    this.y = j;
  }
  
  void show() {
    if (visited) {
      fill(255, 255, 255);
      noStroke();
      rect(w * x, w * y, w, w);
    }
    stroke(51);
    if (tWall) {
      line(w * this.x, w * this.y, w * this.x + w, w * this.y);
    }
    if (lWall) {
      line(w * this.x, w * this.y, w * this.x, w * this.y + w);
    }
  }
  
  Cell checkNeighbours() {
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    
    if (this.y > 0) {
      Cell top = grid.get(this.x + (this.y - 1) * wamount);
      if (!top.visited) {
        neighbours.add(top);
      }
    } 
    if (this.x < wamount - 1) {
      Cell right = grid.get(this.x + 1 + this.y * wamount);
      if (!right.visited) {
        neighbours.add(right);
      }
    } 
    if (this.y < hamount - 1) {
      Cell bottom = grid.get(this.x + (this.y + 1) * wamount);
      if (!bottom.visited) {
        neighbours.add(bottom);
      }
    } 
    if (this.x > 0) {
      Cell left = grid.get(this.x - 1 + this.y * wamount);
      if (!left.visited) {
        neighbours.add(left);
      }
    }    
    
    if (neighbours.size() > 0) {
      int r = floor(random(0, neighbours.size()));
      return neighbours.get(r);
    } else {
      return null;
    }
  }
  
  void highlight() {
    noStroke();
    fill(255, 0, 0);
    rect(this.x * w + 1, this.y * w + 1, w - 1, w - 1);
  }
  
  void removeWalls(JSONArray array, Cell two) {
    JSONArray iArray = array.getJSONArray(this.y);
    JSONObject jCell = iArray.getJSONObject(this.x);
    JSONArray twoIArray = array.getJSONArray(two.y);
    JSONObject twoJCell = twoIArray.getJSONObject(two.x);
    int y = this.y - two.y;
    if (y <= -1) {
      two.tWall = false;
      /*
      this
      ----
      two
      */
      jCell.setBoolean("South", true);
      twoJCell.setBoolean("North", true);
    } 
    if (y >= 1) {
      this.tWall = false;
      /*
      two
      ----
      this
      */
      jCell.setBoolean("North", true);
      twoJCell.setBoolean("South", true);
    }
    int x = this.x - two.x;
    if (x >= 1) {
      this.lWall = false;
      // two | this
      jCell.setBoolean("West", true);
      twoJCell.setBoolean("East", true);
    } 
    if (x <= -1) {
      two.lWall = false;
      // this | two
      jCell.setBoolean("East", true); 
      twoJCell.setBoolean("West", true);
    }
  }
}
