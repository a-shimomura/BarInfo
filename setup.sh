#!/bin/bash

# コンテナ名
CONTAINER_NAME="app"

# Laravel Installerのインストール
if ! docker exec $CONTAINER_NAME bash -c "composer global require laravel/installer"; then
  echo "Error: Failed to install Laravel Installer." >&2
  exit 1
fi

# Laravel InstallerのPATHを設定
LARAVEL_PATH="/root/.composer/vendor/bin/laravel"
if ! docker exec $CONTAINER_NAME bash -c "export PATH=$PATH:~/.composer/vendor/bin >> ~/.bashrc"; then
  echo "Error: Failed to update PATH for Laravel Installer." >&2
  exit 1
fi
docker exec $CONTAINER_NAME bash -c "source ~/.bashrc"

# Laravelプロジェクトを作成
if ! docker exec $CONTAINER_NAME bash -c "$LARAVEL_PATH new tmp"; then
  echo "Error: Failed to create Laravel project." >&2
  exit 1
fi

# 作成したプロジェクトをカレントディレクトリに移動
if ! docker exec $CONTAINER_NAME bash -c "mv tmp/* ./"; then
  echo "Error: Failed to move project files." >&2
  exit 1
fi

if ! docker exec $CONTAINER_NAME bash -c "mv tmp/.* ./ 2>/dev/null"; then
  echo "Error: Failed to move hidden project files." >&2
  exit 1
fi

# 一時ディレクトリを削除
if ! docker exec $CONTAINER_NAME bash -c "rm -rf tmp"; then
  echo "Error: Failed to remove temporary directory." >&2
  exit 1
fi

echo "Laravel project setup completed successfully in Docker container: $CONTAINER_NAME"

