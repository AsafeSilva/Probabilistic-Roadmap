import java.util.*;

PImage map;
PRM prm;
Node start, goal;

void setup() {

  size(938, 516);
  background(255);

  // ==== Load map
  map = loadImage("OccupancyGrid.bmp");

  // ==== Probabilistic Roadmap
  prm = new PRM(map);

  // PRM Parameters
  prm.MAX_NODES = 140;
  prm.MIN_DIST_NEIGHBORS = 50;
  prm.MAX_DIST_NEIGHBORS = 200;
  prm.SAFE_ZONE = 5;
  prm.OPTIMIZE = true;

  prm.plan();   

  start = new Node(color(0, 255, 0), -1);
  goal = new Node(color(255, 0, 0), -2);
}

void draw() {
  image(map, 0, 0);

  prm.drawEdges();
  prm.drawNodes();
  if (!click) prm.drawPath();

  stroke(255, 0, 0);
  line(0, mouseY, width, mouseY);
  line(mouseX, 0, mouseX, height);
}

boolean click = false;
void mousePressed() {

  if (!click) {
    if (!prm.occGrid[mouseX][mouseY]) {
      start.setPosition(mouseX, mouseY);
      click = true;
    }
  } else {
    if (!prm.occGrid[mouseX][mouseY]) {
      goal.setPosition(mouseX, mouseY);
      prm.path(start, goal);
      click = false;
    }
  }
}
