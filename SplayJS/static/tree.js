const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

function drawTree() {
    fetch('/get_tree')
        .then(response => response.json())
        .then(data => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            if (data) {
                drawNode(data, canvas.width / 2, 30, canvas.width / 4);
            }
        });
}

function drawNode(node, x, y, offset) {
    if (!node) return;

    if (node.left) {
        ctx.strokeStyle = 'white';
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x - offset, y + 60);
        ctx.stroke();
        drawNode(node.left, x - offset, y + 60, offset / 2);
    }

    if (node.right) {
        ctx.strokeStyle = 'white';
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x + offset, y + 60);
        ctx.stroke();
        drawNode(node.right, x + offset, y + 60, offset / 2);
    }

    ctx.fillStyle = 'white';
    ctx.beginPath();
    ctx.arc(x, y, 20, 0, 2 * Math.PI);
    ctx.fill();

    ctx.fillStyle = 'black';
    ctx.font = '14px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(node.key, x, y);
}

drawTree();
setInterval(drawTree, 1000);