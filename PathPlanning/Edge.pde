/**
 *
 * Descrição:
 *    Classe que representa uma Aresta (Ligação entre dois 'Nodes')
 *
 * @author Asafe Silva
 * @data 19/04/2018
 *
 * github.com/AsafeSilva
 */

class Edge {

  /**
   * Nodes vizinhos
   */  
  private Node node1, node2;

  /**
   * Cria um novo {@link Edge} a partir de dois 'Nodes'
   * 
   * @param node1 Node principal
   * @param node2 Node vizinho
   */  
  public Edge(Node node1, Node node2) {
    this.node1 = node1;
    this.node2 = node2;
  }

  /**
   * Retorna o node principal
   * 
   * @return Node principal
   */  
  public Node getNode1() {
    return node1;
  }

  /**
   * Retorna o node vizinho
   * 
   * @return Node vizinho
   */  
  public Node getNode2() {
    return node2;
  }

  /**
   * Desenha uma linha entre os dois Nodes
   */ 
  public void draw() {
    stroke(0);
    line(node1.getX(), node1.getY(), node2.getX(), node2.getY());
  }
}
