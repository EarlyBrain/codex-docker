# Docker 版 Codex CLI 実行環境

Docker コンテナ内で [Codex CLI](https://github.com/openai/codex) を実行するための環境です。ホスト側の作業ディレクトリと Codex の設定ディレクトリをコンテナへマウントして使用します。

## 主な内容

- Node.js 26.5.0
- Codex CLI（`@openai/codex`）
- Git、curl、sudo
- Python 3、pip、venv
- bubblewrap

コンテナ内では一般ユーザー `appuser` を使用し、作業ディレクトリは `/var/code` です。

## 前提条件

- Docker がインストールされ、利用できること

## イメージのビルド

リポジトリのルートディレクトリで、次のコマンドを実行します。

```sh
docker build . -t earlybrain/codex:latest
```

## Codex CLI の起動

```sh
docker run -it --rm \
  --security-opt seccomp=unconfined \
  -v "$(pwd):/var/code" \
  -v "$(pwd)/.codex:/home/appuser/.codex" \
  earlybrain/codex:latest
```

このコマンドでは、次のディレクトリをマウントします。

- カレントディレクトリを `/var/code` にマウントし、作業内容をホストと共有します。
- `.codex` を `/home/appuser/.codex` にマウントし、Codex の設定や認証情報を保持します。

初回起動時は、Codex CLI の案内に従って認証してください。

> [!CAUTION]
> `.codex` には認証情報などの機密情報が含まれる可能性があります。リポジトリへコミットしないでください。このリポジトリの `.gitignore` では、`.codex` 配下の通常ファイルを除外しています。

## イメージの削除

不要になったイメージは次のコマンドで削除できます。

```sh
docker rmi earlybrain/codex:latest
```
