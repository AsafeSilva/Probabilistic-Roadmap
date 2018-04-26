/**
 *
 * Descrição:
 *    Classe que representa um 'Node'
 *
 * @author Asafe Silva
 * @data 19/04/2018
 *
 * github.com/AsafeSilva
 */

class Node {

  /**
   * ID para o node
   */
  private int id;

  /**
   * Posição do node no plano
   */  
  private int x, y;

  /**
   * Um {@link List} de {@link Node} que armazena os vizinhos do node
   */  
  private List<Node> neighbors;

  /**
   * Um node que representa o 'pai'
   */  
  private Node parentNode;

  /**
   * Custos do Node
   *  > hCost custo do node até o node final
   *  > gCost custo do node desde o node inicial
   */
  private float hCost, gCost;

  /**
   * A cor do node
   */  
  private color c;

  /**
   * Cria um novo {@link Node} com suas cordenadas e um ID
   * A cor padrão é RGB(0, 0, 255)
   * 
   * @param x A abcissa do node
   * @param y A ordenada do node
   * @param id O ID do node
   */  
  public Node(int x, int y, int id) {
    this.x = x;
    this.y = y;
    this.id = id;

    this.hCost = this.gCost = 0;

    this.c = color(0, 0, 255);

    neighbors = new ArrayList<Node>();
  }

  /**
   * Cria um novo {@link Node} com a cor e um ID
   * A posição padrão é (x, y) = (0, 0)
   * 
   * @param c A cor do node (por ex.: color(255, 0, 0) -> Vermelho)
   * @param id O ID do node
   */ 
  public Node(color c, int id) {
    this.x = 0;
    this.y = 0;
    this.id = id;

    this.hCost = this.gCost = 0;

    this.c = c;

    neighbors = new ArrayList<Node>();
  }

  /**
   * Cria um novo {@link Node}.
   * 
   * Posição padrão é (x, y) = (0, 0)
   * ID padrão é id = 0
   * A cor padrão é RGB(0, 0, 255)
   */ 
  public Node() {
    this.x = 0;
    this.y = 0;
    this.id = 0;

    this.hCost = this.gCost = 0;

    this.c = color(0, 0, 255);

    neighbors = new ArrayList<Node>();
  }

  /**
   * Retorna a abcissa do Node
   * 
   * @return A abcissa do Node
   */ 
  public int getX() {
    return this.x;
  }

  /**
   * Seta a abcissa do Node
   * 
   * @param x A abcissa do Node
   */ 
  public void setX(int x) {
    this.x = x;
  }

  /**
   * Retorna a ordenada do Node
   * 
   * @return A ordenada do Node
   */ 
  public int getY() {
    return this.y;
  }

  /**
   * Seta a ordenada do Node
   * 
   * @param y A ordenada do Node
   */ 
  public void setY(int y) {
    this.y = y;
  }

  /**
   * Seta a posição do Node no plano
   * 
   * @param x A abcissa do Node
   * @param y A ordenada do Node
   */ 
  public void setPosition(int x, int y) {
    this.setX(x);
    this.setY(y);
  }

  /**
   * Retorna ID do Node
   * 
   * @return O ID do Node
   */ 
  public int getID() {
    return this.id;
  }

  /**
   * Retorna os vizinhos do Node
   * 
   * @return Um {@link List<Node>} com os vizinhos do Node
   */ 
  public List<Node> getNeighbors() {
    return this.neighbors;
  }

  /**
   * Adiciona um Node à lista de vizinhos
   * 
   * @param neighbor Um {@link Node}
   */ 
  public void addNeighbor(Node neighbor) {
    this.neighbors.add(neighbor);
  }

  /**
   * Retorna o vizinhos 'pai'
   * 
   * @return Um {@link List<Node>}
   */ 
  public Node getParentNode() {
    return this.parentNode;
  }

  /**
   * Seta o vizinho 'pai' do Node
   * 
   * @param node Um {@link List<Node>}
   */ 
  public void setParentNode(Node node) {
    this.parentNode = node;
  }

  /**
   * Seta a cor do Node
   * por ex.: color(0, 0, 255) -> Azul
   * 
   * @param c Um {@link color}
   */ 
  public void setColor(color c) {
    this.c = c;
  }

  /**
   * Retorna o custo total do node (custo H + custo G)
   * 
   * @return O custo total do node
   */ 
  public float getCost() {
    return (this.hCost + this.gCost);
  }

  /**
   * Retorna o custo H do node
   * 
   * @return O custo H do node
   */ 
  public float getHCost() {
    return this.hCost;
  }

  /**
   * Seta o custo H do node
   * 
   * @param cost O custo H do node
   */ 
  public void setHCost(float cost) {
    this.hCost = cost;
  }

  /**
   * Retorna o custo G do node
   * 
   * @return O custo G do node
   */ 
  public float getGCost() {
    return this.gCost;
  }

  /**
   * Seta o custo G do node
   * 
   * @param cost O custo G do node
   */ 
  public void setGCost(float cost) {
    this.gCost = cost;
  }

  /**
   * Desenha o Node na tela como um círculo de raio 5
   */ 
  public void draw() {
    stroke(0);
    strokeWeight(1);
    fill(c);
    ellipse(this.x, this.y, 9, 9);
    //fill(255, 0, 0);
    //textSize(20);
    //text(this.id, this.x, this.y);
  }
}
