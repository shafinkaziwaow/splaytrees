class Tree
{
  TreeNode root;
  int numLevels;


  /************************
   isBalanced(TreeNode current)
   
   A balanced tree is one in which:
   0. The heights of its left and right subtree
   differ by at most 1 level.
   1. All the nodes within the left and right
   subtrees are also balanced.
   
   Returns
   true if current is the root of a balanced tree.
   false otherwise.
   Note that the empty tree is balanced.
   ************************/
  boolean isBalanced(TreeNode current)
  {
    if (current == null) {
      return true; // empty
    }

    int leftHeight = getHeight(current.left);
    int rightHeight = getHeight(current.right);

    // check if height difference is at most 1
    if (Math.abs(leftHeight - rightHeight) <= 1 &&
      isBalanced(current.left) &&
      isBalanced(current.right)) {
      return true;
    }

    return false;
  }//isBalanced


  /************************
   void balanceColor()
   Traverse the tree and set the color of each node:
   0. Yellow if that node is the root of a balanced tree.
   1. Magenta if that note is not the root of a balanced tree.
   ************************/
  void balanceColor()
  {
    balanceColor(root);
  }//wrapper
  void balanceColor(TreeNode current) {
    if (current == null) {
      return;
    }

    if (isBalanced(current)) {
      current.c = color(255, 255, 0); // yellow - balanced
    } else {
      current.c = color(255, 0, 255); // magenta - unbalanced
    }

    // recursive -- set colors for left and right subtrees
    balanceColor(current.left);
    balanceColor(current.right);
  }//balanceColor


  /************************
   int getLevel(TreeNode target, TreeNode current)
   
   Return the number of levels from current to target.
   Assume that both target and current are in the tree.
   You cannot assume that numLevels is the actual
   number of levels in the tree.
   ************************/
  int getLevel(TreeNode target, TreeNode current)
  {
    if (current == null) {
      return -1;
    }

    if (current == target) {
      return 0; // found
    }

    // left subtree
    int leftLevel = getLevel(target, current.left);
    if (leftLevel >= 0) {
      return leftLevel + 1; // found left
    }

    // right subtree
    int rightLevel = getLevel(target, current.right);
    if (rightLevel >= 0) {
      return rightLevel + 1; // found right
    }

    return 0; // not found
  }//getLevel


  /************************
   getSelected(PVector P)
   
   Returns:
   null if p is not inside any node of this tree.
   or
   The TreeNode that p is inside.
   There has been a new method added to TreeNode
   called iseSelected(PVector p) that you should call
   in this method.
   ************************/
  TreeNode getSelected(PVector p) {
    return getSelected(p, root);
  }//wrapper
  TreeNode getSelected(PVector p, TreeNode current) {
    if (current == null) {
      return null; // empty
    }

    // check if current node is seleected
    if (current.isSelected(p)) {
      return current;
    }

    // left subtree
    TreeNode leftResult = getSelected(p, current.left);
    if (leftResult != null) {
      return leftResult;
    }

    // right subtree
    TreeNode rightResult = getSelected(p, current.right);
    if (rightResult != null) {
      return rightResult;
    }

    return null; // not found in this tree
  }//getSelected


  /************************
   void addNode(TreeNode current)
   
   Attempts to add a child node to current.
   Will not add a node if current is null or
   current already has left and right children.
   Will add a left node before adding a right node.
   ************************/
  void addNode(TreeNode current)
  {
    if (current == null) {
      return;
    }

    // add left child if missing
    if (current.left == null) {
      //new node with random letter
      char c = char(int(random(26)) + 'A');
      float xspacing = width / pow(2, getLevel(current, root) + 2);
      int xLeft = int(current.position.x - xspacing);
      int y = int(current.position.y + Y_SPACE);
      current.left = new TreeNode(c, xLeft, y);
      return;
    }

    // right child
    if (current.right == null) {
      char c = char(int(random(26)) + 'A');
      float xspacing = width / pow(2, getLevel(current, root) + 2);
      int xRight = int(current.position.x + xspacing);
      int y = int(current.position.y + Y_SPACE);
      current.right = new TreeNode(c, xRight, y);
      return;
    }

    // Both children exist, can't add more
  }//addNode






  Tree(int x, int y, int levels, boolean full)
  {
    numLevels = levels;
    root = makeTree(x, y, numLevels, full);
  }//constructor


  void reset(boolean full)
  {
    root = makeTree( int(root.position.x),
      int(root.position.y),
      numLevels, full);
  }//reset


  TreeNode makeTree(int x, int y, int levels, boolean full)
  {
    if (levels == 0) {
      return null;
    }//base case

    char c = char(int(random(26)) + 'A');
    TreeNode tn = new TreeNode(c, x, y);

    int nextLevel = numLevels - levels + 1;
    float xspacing = width / pow(2, (nextLevel + 1));
    int xLeft = int(x - xspacing);
    int xRight = int(x + xspacing);
    y+= Y_SPACE;

    if (full || random(1) < float(levels)/numLevels) {
      tn.left = makeTree(xLeft, y, levels-1, full);
    }
    if (full || random(1) < float(levels)/numLevels) {
      tn.right = makeTree(xRight, y, levels-1, full);
    }
    return tn;
  }//makeTree


  /*wrapper method to clean up getHeight call*/
  int getHeight()
  {
    return getHeight(root);
  }
  int getHeight(TreeNode current)
  {
    if (current == null) {
      return 0;
    }
    int leftHeight = getHeight(current.left);
    int rightHeight = getHeight(current.right);
    //if (leftHeight > rightHeight) {
    //  return leftHeight + 1;
    //} else {
    //  return rightHeight + 1;
    //}

    return max(leftHeight, rightHeight) + 1;
  }//getHeight

  void removeNode(TreeNode target) {
    if (target != root) {
      removeNode(target, root);
    }
  }

  void removeNode(TreeNode target, TreeNode current) {
    if (current == null) {
      return; // reach leaf without finding target
    }

    // check if target is left child of current
    if (current.left == target) {
      // if no children, remove
      if (target.left == null && target.right == null) {
        current.left = null;
      }
      // if target has only left child, connect it to current
      else if (target.right == null) {
        current.left = target.left;
      }
      // if target has only right child, connect it to current
      else if (target.left == null) {
        current.left = target.right;
      }
      // If target has both children, replace with rightmost node of left subtree
      else {
        TreeNode rightmost = findRightmost(target.left);
        // move data from rightmost to target location
        rightmost.right = target.right;
        current.left = target.left;
      }
      return;
    }

    if (current.right == target) {

      if (target.left == null && target.right == null) {
        current.right = null;
      }

      else if (target.right == null) {
        current.right = target.left;
      }

      else if (target.left == null) {
        current.right = target.right;
      }

      else {
        TreeNode rightmost = findRightmost(target.left);

        rightmost.right = target.right;
        current.right = target.left;
      }
      return;
    }

    // If we reach here, target wasn't a direct child
    // Continue searching in both subtrees
    removeNode(target, current.left);
    removeNode(target, current.right);
  }

  TreeNode findRightmost(TreeNode node) {
    if (node.right == null) {
      return node;
    }
    return findRightmost(node.right);
  }

  /************************
   Wrapper function for display
   ************************/
  void display()
  {
    display(root);
  }
  void display(TreeNode current)
  {
    if (current != null) {
      current.display();
      display(current.left);
      display(current.right);
    }
  }//display
}//Tree
