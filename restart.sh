#!/bin/bash

MINECRAFT_DIR="/home/proc0x41/github/owlsgold/"
MINECRAFT_JAR="paper.jar"
JAVA_ARGS="-Xmx4096M -Xms4096M"
MINECRAFT_LOG="minecraft.log"
SCREEN_NAME="minecraft"

if [ ! -d "$MINECRAFT_DIR" ]; then
    echo "Erro: Diretório $MINECRAFT_JAR não existe."
    exit 1
fi

echo "Encerrando servidor Minecraft..."
screen -X -S "$SCREEN_NAME" quit
sleep 5

if screen -list | grep -q "$SCREEN_NAME"; then
    echo "Erro: A sessão $SCREEN_NAME ainda está ativa. Abortando."
    exit 1
fi

echo "Iniciando o servidor Minecraft novamente..."
screen -dmS "$SCREEN_NAME" -L -Logfile "$MINECRAFT_LOG" java $JAVA_ARGS -jar "$MINECRAFT_JAR" -nogui

sleep 3

if screen -list | grep -q "$SCREEN_NAME"; then
    echo "Servidor Minecraft reiniciado com sucesso. Use: screen -r $SCREEN_NAME"
else
    echo "Erro ao reiniciar o servidor. Verifique o log: $MINECRAFT_LOG"
    exit 1
fi
