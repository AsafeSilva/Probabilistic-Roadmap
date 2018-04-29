/**
 *
 * Descrição:
 *    Uma implementação em Java do algoritmo PRM (Probabilistic RoadMap)
 *
 * @author Asafe Silva
 * @data 19/04/2018
 *
 * github.com/AsafeSilva
 */

class PRM {

  /**
   * Quantidade máxima de nodes
   */
  public int MAX_NODES = 145;

  /**
   * Distância mínima entre cada node
   */
  public int MIN_DIST_NEIGHBORS = 50;

  /**
   * Distância máxima para realizar a "conexão"
   */
  public int MAX_DIST_NEIGHBORS = 200;

  /**
   * Parâmetro que corresponde ao quanto (em pixes) o mapa será inflado
   */
  public int SAFE_ZONE = 5;

  /**
   * Se 'true', o caminho gerado será otimizado
   */
  public boolean OPTIMIZE = true;

  /**
   * Matriz que contém o mapa (1 -> obstáculo, 0 -> espaço livre)
   */
  protected boolean[][] occGrid;

  /**
   * Matriz que contém as distâncias de manhattan para inflar o mapa
   */
  private int[][] manhattanGrid;

  /**
   * Um {@link List} de {@link Node} que armazena todos os nodes gerados
   */
  private List<Node> nodes;

  /**
   * Um {@link List} de {@link Edge} que armazena todas as arestas entre os nodes
   */
  private List<Edge> edges;

  /**
   * Um {@link List} de {@link Node} que armazena os nodes que forma o caminho gerado
   */
  private List<Node> path;

  /**
   * Um {@link PImage} que encapsula um {@link BufferedImage} do mapa
   */
  private PImage map;

  /**
   * Cria um novo {@link PRM} a partir de uma imagem
   *
   * @param map Um {@link PImage} para carregar o mapa de nodes
   */
  public PRM(PImage map) { 

    this.map = map;
    this.map.loadPixels();

    occGrid = new boolean[map.width][map.height];
    for (int x = 0; x < map.width; x++) {
      for (int y = 0; y < map.height; y++) {
        occGrid[x][y] = (map.pixels[x + y * map.width] & 0xFF) == 0;
      }
    }

    nodes = new ArrayList<Node>();
    edges = new ArrayList<Edge>();
    path = new ArrayList<Node>();

    // Criar array (2D) com as distâncias de Manhattan
    manhattanGrid = manhattan(occGrid);
  }

  /**
   * Gera os nodes aleatoriamente e seleciona os vizinhos de cada um de acordo
   * com os paramêtros especificados para o posterior planejamento do caminho
   */
  public void plan() {

    // Infla o mapa
    if (SAFE_ZONE > 0) {
      this.map.loadPixels();
      for (int x = 0; x < this.map.width; x++) {
        for (int y = 0; y < this.map.height; y++) {
          occGrid[x][y] = (manhattanGrid[x][y] <= SAFE_ZONE);
          this.map.pixels[x + this.map.width * y] = occGrid[x][y] ? color(0, 0, 0) : color(255, 255, 255);
        }
      }
      this.map.updatePixels();
    }

    // Gera os 'Nodes'
    int id = 0;
    while (id < MAX_NODES) {

      // Gera posição aleatória
      int x = (int)random(this.map.width);
      int y = (int)random(this.map.height);

      // Procura vizinho próximo
      boolean closeNeighbor = false;
      for (Node node : nodes) {
        if (dist(x, y, node.getX(), node.getY()) < MIN_DIST_NEIGHBORS) {
          closeNeighbor = true;
          break;
        }
      }

      // Livre de obstáculo e longe de vizinhos ?
      if (!occGrid[x][y] && !closeNeighbor) {

        // Cria novo Node
        Node newNode = new Node(x, y, id);

        // Adiciona à lista de Nodes
        nodes.add(newNode);

        id++;
      }
    }

    // Seleciona vizinhos
    for (Node node : nodes) {
      for (Node neighbor : nodes) {
        if (node.getID() == neighbor.getID()) continue;

        if (dist(node.getX(), node.getY(), neighbor.getX(), neighbor.getY()) < MAX_DIST_NEIGHBORS) {
          if (testPath(node, neighbor)) {
            node.addNeighbor(neighbor);
            edges.add(new Edge(node, neighbor));
          }
        }
      }
    }
  }

  /**
   * Realiza o planejamento propriamente dito.
   *
   * @brief 
   *    > Adiciona os Nodes 'start' e 'goal' ao path
   *    > Busca os nodes mais próximos aos mesmos ('newStart' e 'newGoal')
   *    > Aplica o algoritmo A* buscando os pontos com menor custo para alcançar o 'goal'
   *    > Otimiza rota gerada pelo A*
   */
  public void path(Node start, Node goal) {

    List<Node> tempPath = new ArrayList<Node>();

    this.path.clear();
    for (Node node : nodes) {
      node.setGCost(0);
      node.setHCost(0);
      node.setColor(color(0, 0, 255));
    }

    // Busca Node mais próximo ao 'start'
    float shorterDistance = 9999;
    int idCloser = 0;
    for (Node node : nodes) {
      float distance = dist(start.getX(), start.getY(), node.getX(), node.getY());
      if (distance < shorterDistance) {
        if (testPath(node, start)) {
          shorterDistance = distance;
          idCloser = node.getID();
        }
      }
    }

    Node newStart = nodes.get(idCloser);
    newStart.setParentNode(start);

    // Busca Node mais próximo ao 'goal'
    shorterDistance = 9999;
    idCloser = 0;
    for (Node node : nodes) {
      float distance = dist(goal.getX(), goal.getY(), node.getX(), node.getY());
      if (testPath(node, goal)) {
        shorterDistance = distance;
        idCloser = node.getID();
      }
    }

    Node newGoal = nodes.get(idCloser);
    goal.setParentNode(newGoal);


    // *******   A* Algorithm   *******
    List<Node> openList = new ArrayList<Node>();
    List<Node> closedList = new ArrayList<Node>();

    // Adiciona ponto inicial à lista aberta
    openList.add(newStart);

    Node current;
    while (true) {
      // Procura o Node de menor custo na lista aberta
      current = openList.get(0);
      for (Node node : openList) {
        if (node.getCost() < current.getCost())
          current = node;
      }

      // Remove da lista aberta e adiciona na lista fechada
      closedList.add(current);
      openList.remove(current);

      // Se chegou no objetivo, slava o 'path'
      if (current.getID() == newGoal.getID()) {  

        tempPath.add(goal);

        while (true) {
          current.setColor(color(255, 255, 0));
          tempPath.add(current);
          current = current.getParentNode();

          if (current.getID() == start.getID())
            break;
        }

        tempPath.add(start);
        break;
      }

      // Busca os vizinhos e calcula os custos de cada um
      for (Node neighbor : current.getNeighbors()) {
        if (!openList.contains(neighbor) && !closedList.contains(neighbor)) {
          neighbor.setParentNode(current);                                                                                // Seta o pai deste Node
          neighbor.setHCost(dist(neighbor.getX(), neighbor.getY(), newGoal.getX(), newGoal.getY()));                      // Custo até o 'goal'
          neighbor.setGCost(dist(neighbor.getX(), neighbor.getY(), current.getX(), current.getY()) + current.getGCost()); // Custo de 'start' até este Node  
          openList.add(neighbor);                                                                                         // Adiciona à lista aberta
        }
      }

      // Se não existe 'path'
      if (openList.isEmpty()) {
        println("Path not available!");
        path.clear();
        break;
      }
    }
    // ******* end A* Algorithm  ******

    // Otimiza o 'path' gerado
    if (OPTIMIZE)
      optimizePath(tempPath, start, goal);

    path = tempPath;
  }

  /**
   * Realiza a otimização do 'path' gerado
   * 
   * @param path O 'path' para ser otimizado
   * @param start O ponto inicial da rota
   * @param goal O ponto final da rota
   */
  private void optimizePath(List<Node> path, Node start, Node goal) {

    List<Node> pathGoing = new ArrayList<Node>(path);
    pathGoing.remove(goal);
    Collections.reverse(pathGoing);

    List<Node> pathComming = new ArrayList<Node>(path);
    pathComming.remove(start);

    for (int i = 0; i < pathGoing.size(); i++) {
      Node nGoing = (Node) pathGoing.get(i);

      for (int j = 0; j < pathComming.size(); j++) {
        Node nComming = (Node) pathComming.get(j);

        if (nComming.equals(nGoing)) break;

        if (testPath(nGoing, nComming)) {

          int n = 0;
          Node current = nComming.getParentNode();
          while (true) {
            if (current.getID() == nGoing.getID()) break;
            path.remove(current);
            n++;

            current = current.getParentNode();
          }

          i += n; 
          nComming.setParentNode(nGoing);
          break;
        }
      }
    }
  }

  /**
   * Discretiza o segmento de reta entre dois pontos para checar se intercepta obstáculos 
   * 
   * @param node Um 'node' qualquer
   * @param neighbor Um 'node' vizinho
   * @return Retorna 'true' caso o caminho estaja livre. Caso contrário, 'false' 
   */
  private boolean testPath(Node node, Node neighbor) {

    float alpha = 0.01; 
    float t = 0; 
    int x = node.getX(), y = node.getY(); 

    while (t < 1) {
      if (occGrid[x][y])
        return false; 

      t += alpha; 
      x = (int)((1 - t) * node.getX() + t * neighbor.getX()); 
      y = (int)((1 - t) * node.getY() + t * neighbor.getY());
    }

    return true;
  }

  /**
   * Calcula a distância de Manhattan de cada pixel para até um obstáculo
   * 
   * Adaptado de 'https://blog.ostermiller.org/dilate-and-erode'
   *
   * @param occGrid A matriz que representa o mapa
   * @return Retorna uma matriz (int[][]) com as distâncias de manhattan 
   */
  private int[][] manhattan(boolean[][] occGrid) {

    int[][] manhattanDistance = new int[occGrid.length][occGrid[1].length];

    // traverse from top left to bottom right
    for (int i=0; i<occGrid.length; i++) {
      for (int j=0; j<occGrid[i].length; j++) {
        if (occGrid[i][j] == true) {
          // first pass and pixel was on, it gets a zero
          manhattanDistance[i][j] = 0;
        } else {
          // pixel was off
          // It is at most the sum of the lengths of the array
          // away from a pixel that is on
          manhattanDistance[i][j] = occGrid.length + occGrid[i].length;
          // or one more than the pixel to the north
          if (i>0) manhattanDistance[i][j] = Math.min(manhattanDistance[i][j], manhattanDistance[i-1][j]+1);
          // or one more than the pixel to the west
          if (j>0) manhattanDistance[i][j] = Math.min(manhattanDistance[i][j], manhattanDistance[i][j-1]+1);
        }
      }
    }
    // traverse from bottom right to top left
    for (int i=occGrid.length-1; i>=0; i--) {
      for (int j=occGrid[i].length-1; j>=0; j--) {
        // either what we had on the first pass
        // or one more than the pixel to the south
        if (i+1<occGrid.length) manhattanDistance[i][j] = Math.min(manhattanDistance[i][j], manhattanDistance[i+1][j]+1);
        // or one more than the pixel to the east
        if (j+1<occGrid[i].length) manhattanDistance[i][j] = Math.min(manhattanDistance[i][j], manhattanDistance[i][j+1]+1);
      }
    }
    return manhattanDistance;
  }

  /**
   * Retorna a lista de 'nodes'
   * 
   * @return Retorna um {@link List<Node>}
   */
  public List<Node> getNodes() {
    return this.nodes;
  }

  /**
   * Retorna a lista de 'edges'
   * 
   * @return Retorna um {@link List<Edge>}
   */
  public List<Edge> getEdges() {
    return this.edges;
  }

  /**
   * Retorna o 'path' calculado
   * 
   * @return Retorna um {@link List<Node>}
   */
  public List<Node> getPath() {
    return this.path;
  }

  /**
   * Desenha os nodes na tela
   */
  public void drawNodes() {
    for (Node node : nodes) {
      node.draw();
    }
  }

  /**
   * Desenha as arestas na tela
   */
  public void drawEdges() {
    for (Edge edge : edges) {
      edge.draw();
    }
  }

  /**
   * Desenha o 'path' calculado
   */
  public void drawPath() {
    for (Node node : path) {
      node.draw(); 

      try {
        strokeWeight(4); 
        stroke(255, 100, 0); 
        line(node.getX(), node.getY(), node.getParentNode().getX(), node.getParentNode().getY());
      }
      catch(NullPointerException e) {
      }
    }
    strokeWeight(1);
  }
}
