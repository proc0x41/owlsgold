#!/bin/bash
set -e

# Caminhos e configurações
MINECRAFT_DIR="/home/proc0x41/github/owlsgold/"
MINECRAFT_JAR="paper.jar"
JAVA_ARGS="-Xmx4096M -Xms4096M"
PLAYIT_BINARY="/usr/local/bin/playit"
MINECRAFT_LOG="minecraft.log"
PLAYIT_LOG="playit.log"

# Verificações
if [ ! -d "$MINECRAFT_DIR" ]; then
    echo "Error: Minecraft dir $MINECRAFT_DIR doesn't exist."
    exit 1
fi
cd "$MINECRAFT_DIR" || exit 1

if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed. Please install Java."
    exit 1
fi

if ! command -v screen &> /dev/null; then
    echo "Error: screen is not installed. Install it."
    exit 1
fi

if [ ! -x "$PLAYIT_BINARY" ]; then
    echo "Error: Playit binary $PLAYIT_BINARY not found or not executable."
    echo "Download from https://playit.gg or update the PLAYIT_BINARY path."
    exit 1
fi

if [ ! -f "$MINECRAFT_JAR" ]; then
    echo "Error: Minecraft server JAR $MINECRAFT_JAR not found in $MINECRAFT_DIR."
    exit 1
fi

# Tenta fechar sessões anteriores, se existirem
screen -X -S minecraft quit || true
screen -X -S playit quit || true

# Inicia o servidor Minecraft
echo "Starting Minecraft Server..."
screen -dmS minecraft bash -c "java $JAVA_ARGS -jar $MINECRAFT_JAR nogui | tee $MINECRAFT_LOG"
sleep 5
if ! screen -list | grep -q "minecraft"; then
    echo "Error: Minecraft server failed to start. Check $MINECRAFT_LOG"
    exit 1
fi
echo "Minecraft server started in screen session 'minecraft'. Reattach with: screen -r minecraft"

# Inicia o Playit
echo "Starting Playit..."
screen -dmS playit bash -c "$PLAYIT_BINARY | tee $PLAYIT_LOG"
sleep 5
if ! screen -list | grep -q "playit"; then
    echo "Error: Playit failed to start. Check $PLAYIT_LOG for details."
    exit 1
fi

# Mostra informações
PLAYIT_PID=$(pgrep -f "$PLAYIT_BINARY" || echo "N/A")
echo "Playit started with PID $PLAYIT_PID. Logs: $PLAYIT_LOG"

# Exibe possível URL do túnel
echo "Checking Playit tunnel URL..."
grep -i "tunnel.*playit.gg" "$PLAYIT_LOG" || echo "Tunnel URL not found yet. Check $PLAYIT_LOG."

# Instruções finais
echo ""
echo "✅ Ambos os serviços estão rodando em background com screen."
echo ""
echo "▶ Para acessar o console do Minecraft:     screen -r minecraft"
echo "▶ Para acessar o console do Playit:        screen -r playit"
echo "📄 Para ver logs em tempo real (tail):     tail -f $MINECRAFT_LOG"
echo "📄 Para ver logs do Playit:                tail -f $PLAYIT_LOG"
echo "⛔ Para parar o servidor Minecraft:        screen -X -S minecraft quit"
echo "⛔ Para parar o Playit:                    screen -X -S playit quit"

