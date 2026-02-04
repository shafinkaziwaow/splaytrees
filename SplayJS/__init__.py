from flask import Flask, render_template, request, session, redirect, url_for, flash

app = Flask(__name__)


@app.route("/")
def disp_site():
    return render_template("index.html")

@app.route("/add_value", methods=["GET"])
def add_value():
    value = request.args["value"]
    return render_template("index.html")
