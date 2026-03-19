# python_char_server.py
from io import BytesIO
from PIL import Image, ImageDraw, ImageFont

HOST = "0.0.0.0"
PORT = 18896

# SimSun 字体路径
FONT_PATH = "方正像素12.ttf"

def generate_char_image(char: str, width: int, height: int, font_color: str, bg_color: str) -> list[list[str]]:
    img = Image.new("1", (width, height), 0)
    draw = ImageDraw.Draw(img)
    font_size = min(width / len(char), height)
    font_size = 12
    font = ImageFont.truetype(FONT_PATH, font_size)
    
    # 居中绘制
    bbox = draw.textbbox((0,0), char, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # 计算居中坐标
    x = (width - text_width) / 2 - bbox[0]  # bbox[0]是左侧偏移
    y = (height - text_height) / 2 - bbox[1]  # bbox[1]是顶部偏移
    
    draw.text((0, y), char, font=font, fill=1)  # 使用1表示字体颜色，0表示背景颜色

    pixels = [[font_color if img.getpixel((x, y)) == 1 else bg_color for x in range(width)] for y in range(height)]
    
    lines = []
    for row in pixels:
        lines.append("".join(row))
    

    return "\n".join(lines).encode("utf-8")
