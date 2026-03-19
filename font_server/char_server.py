from log import get_logger
import socket
import threading
import sched
import time
import re
from io import BytesIO
from PIL import Image
import base64
import flask
from urllib.parse import unquote_to_bytes

from font_util import generate_char_image


app = flask.Flask(__name__)
logger = get_logger("CharServer")

@app.route("/convert", methods=["get"])
def convert():
    data = flask.request.args.get("data")
    data = bytes(data, "latin1").decode("unicode_escape").encode("latin1")
    data = unquote_to_bytes(data).decode("utf-8")
    logger.info(f"收到请求数据: {data}")
    match = re.match(r"(.*?),(\d+),(\d+),(\w),(\w)", data)
    if not match:
        logger.error("请求数据格式错误")
        return "ERROR: Invalid format", 400 
    char, width, height, front, bg = match.groups()
    width, height = int(width), int(height)
    logger.info(f"生成字符图像: char={char}, width={width}, height={height}, font_color={front}, bg_color={bg}")
    nfp_data = generate_char_image(char, width, height, front, bg)
    logger.info(f"生成的NFP数据长度: {len(nfp_data)} bytes")
    return nfp_data, 200, {"Content-Type": "application/octet-stream"}  

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)