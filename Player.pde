class Player {
  int x;
  int y;
  int w;
  int index;
  
  Player(int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
  }
  
  void show() {
    fill(255, 0, 0);
    noStroke();
    ellipse(this.x * this.w + this.w / 2, this.y * this.w + this.w / 2, w - 4, w - 4);
  }
  
  void randShow() {
    fill(0, 0, 255);
    noStroke();
    ellipse(this.x * this.w + this.w / 2, this.y * this.w + this.w / 2, w - 4, w - 4);
  }
  
  void move() {
    if (keyCode == LEFT && this.x != 0) {
      if (!grid.get(this.index).lWall) {
        this.x --;
        this.index = x + y * wamount;
      }
    }
    if (keyCode == RIGHT && this.x != wamount - 1) {
      if (!grid.get(this.index + 1).lWall) {
        this.x ++;
        this.index = x + y * wamount;
      }
    }
    if (keyCode == UP && this.y != 0) {
      if (!grid.get(this.index).tWall) {
        this.y --;
        this.index = x + y * wamount;
      }
    }
    if (keyCode == DOWN && this.y != hamount - 1) {
      if (!grid.get(this.index + wamount).tWall) {
        this.y ++;
        this.index = x + y * wamount;
      }
    }
  }
  
  void randMove() {
    ArrayList<Cell> open = new ArrayList<Cell>();
    if (!grid.get(this.index).lWall && this.x != 0) {
      open.add(grid.get(this.index - 1));
    }
    if (this.x != wamount - 1 && !grid.get(this.index + 1).lWall) {
      open.add(grid.get(this.index + 1));
    }
    if (!grid.get(this.index).tWall && this.y != 0) {
      open.add(grid.get(this.index - wamount));
    }
    if (this.y != hamount - 1 && !grid.get(this.index + wamount).tWall) {
      open.add(grid.get(this.index + wamount));
    }
    
    if (open.size() > 0) {
      int r = floor(random(0, open.size()));
      this.x = open.get(r).x;
      this.y = open.get(r).y;
      this.index = x + y * wamount;
    }
  }
  
  void followSol() {
    
  }
}
