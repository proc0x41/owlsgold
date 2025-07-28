#!/bin/bash

# Nomes das sessões screen
MC_SESSION="minecraft"
PLAYIT_SESSION="playit"

echo "Encerrando servidor Minecraft..."
if screen -list | grep -q "$MC_SESSION"; then
    screen -S "$MC_SESSION" -X stuff "stop$(printf \\r)"
    sleep 5  # dá tempo para salvar o mundo
    screen -X -S "$MC_SESSION" quit
    echo "Servidor Minecraft encerrado."
else
    echo "Sessão '$MC_SESSION' não está ativa."
fi

echo "Encerrando Playit..."
if screen -list | grep -q "$PLAYIT_SESSION"; then
    screen -X -S "$PLAYIT_SESSION" quit
    echo "Playit encerrado."
else
    echo "Sessão '$PLAYIT_SESSION' não está ativa."
fi

echo "✅ Todos os serviços foram encerrados."

