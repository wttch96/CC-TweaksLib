import logging

from colorlog import ColoredFormatter


def get_logger(name:str) -> logging.Logger:
    """
    获取一个彩色日志记录器
    Args:
        name (str): 记录器名称
    Returns:
        logging.Logger: 配置好的日志记录器
    """
    # 创建 logger
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)

    # 创建彩色 formatter
    formatter = ColoredFormatter(
        "%(asctime)s%(log_color)s[%(levelname)-8s]%(reset)s %(name)s %(message)s",
        log_colors={
            'DEBUG': 'cyan',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'bold_red',
        }
    )

    # 创建控制台 handler
    ch = logging.StreamHandler()
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    logger.info("日志系统已初始化")
    return logger
