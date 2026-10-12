# Docker版 Codex CLI実行環境
# - 構築
# docker build --no-cache --progress=plain . -t earlybrain/codex:latest
# - 実行
# docker run -it --rm --privileged -v .:/var/code -v .codex:/home/appuser/.codex earlybrain/codex:latest
# - 削除
# docker rmi earlybrain/codex:latest
# docker builder prune --force

# FROMはベースとなるコンテナのOSイメージを指定
FROM node:26.5.0-slim
LABEL version="1.0"
LABEL description="Codex CLI実行環境"

# 必要最低限のパッケージインストール
RUN apt update && \
    apt install -y sudo curl git

# グループとユーザーアカウントの作成
RUN groupadd -g 1100 appgroup && \
    useradd -u 1100 -g 1100 -m -s /bin/bash appuser

# ユーザーにsudo権限を付与（パスワードなし）
RUN echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Codex CLIのインストール
RUN npm install -g @openai/codex && \
    apt install -y bubblewrap

# ImageMagickのインストール
RUN apt-get install -y imagemagick

# Pythonのインストール
RUN apt install -y python3 python3-pip python3-venv
RUN python3 -m venv /opt/venv

# Python画像ライブラリのインストール
RUN /opt/venv/bin/pip install --no-cache-dir pillow

# OCRのインストール
RUN apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-jpn poppler-utils

# マウントボリューム
RUN mkdir /var/code
RUN mkdir /home/appuser/.codex

# デフォルトユーザーの切り替え
USER appuser

# WORKDIRの設定
WORKDIR /var/code

# コンテナ起動時に実行されるコマンド
CMD ["node", "/usr/local/bin/codex"]
