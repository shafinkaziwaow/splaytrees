from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

class Node:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None

class SplayTree:
    def __init__(self):
        self.root = None
    
    def right_rotate(self, x):
        y = x.left
        x.left = y.right
        y.right = x
        return y
    
    def left_rotate(self, x):
        y = x.right
        x.right = y.left
        y.left = x
        return y
    
    def splay(self, root, key):
        if (root is None or root.key == key):
            return root
        
        if (key < root.key):
            if (root.left is None):
                return root
            if (key < root.left.key):
                root.left.left = self.splay(root.left.left, key)
                root = self.right_rotate(root)
            elif (key > root.left.key):
                root.left.right = self.splay(root.left.right, key)
                if (root.left.right):
                    root.left = self.left_rotate(root.left)
            if (root.left):
                return self.right_rotate(root)
            else:
                return root
        
        else:
            if (root.right is None):
                return root
            if (key < root.right.key):
                root.right.left = self.splay(root.right.left, key)
                if (root.right.left):
                    root.right = self.right_rotate(root.right)
            elif (key > root.right.key):
                root.right.right = self.splay(root.right.right, key)
                root = self.left_rotate(root)
            if (root.right):
                return self.left_rotate(root)
            else:
                return root

    
    def insert(self, key):
        if (self.root is None):
            self.root = Node(key)
            return
        
        self.root = self.splay(self.root, key)
        
        if (self.root.key == key):
            return  
        
        new_node = Node(key)
        
        if (key < self.root.key):
            new_node.right = self.root
            new_node.left = self.root.left
            self.root.left = None
        else:
            new_node.left = self.root
            new_node.right = self.root.right
            self.root.right = None
        
        self.root = new_node
    
    def search(self, key):
        self.root = self.splay(self.root, key)
        return self.root and self.root.key == key
    
    def delete(self, key):
        if (self.root is None):
            return
        
        self.root = self.splay(self.root, key)
        
        if (self.root.key != key):
            return  
        
        if (self.root.left is None):
            self.root = self.root.right
        else:
            temp = self.root.right
            self.root = self.root.left
            self.root = self.splay(self.root, key)
            self.root.right = temp
    
    def to_dict(self, node):
        if node is None:
            return None
        return {
            'key': node.key,
            'left': self.to_dict(node.left),
            'right': self.to_dict(node.right)
        }
    
    def get_tree_data(self):
        return self.to_dict(self.root)




tree = SplayTree()

@app.route("/")
def disp_site():
    return render_template("index.html")

@app.route("/add_value", methods=["POST"])
def add_value():
    value = request.form.get("value")
    return redirect(url_for("disp_site"))

if __name__ == "__main__":
    app.run(debug=True)