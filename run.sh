#!/bin/bash
# =====================================================
# Chatbot Test Harness FastAPI Launcher (Clean Version)
# =====================================================

set -e  # Exit immediately on error

echo "🚀 Launching Chatbot Test Harness..."

# 1️⃣ Ensure we're in the project root
cd "$(dirname "$0")" || exit 1

# 2️⃣ Validate virtual environment
if [ ! -d ".venv" ]; then
  echo "❌ Virtual environment not found!"
  echo "Run: ./setup_env.sh"
  exit 1
fi

# 3️⃣ Validate .env
if [ ! -f ".env" ]; then
  echo "❌ .env file missing!"
  echo "Create one using: cp env.example .env"
  exit 1
fi

# 4️⃣ Activate virtual environment
source .venv/bin/activate

# 5️⃣ Check uvicorn availability
if ! command -v uvicorn >/dev/null 2>&1; then
  echo "❌ uvicorn is not installed in the virtual environment!"
  exit 1
fi

# 6️⃣ Ensure module entrypoint exists
if [ ! -f "src/backend/main.py" ]; then
  echo "❌ src/backend/main.py not found!"
  echo "Expected FastAPI app at: src/backend/main.py"
  exit 1
fi

# 7️⃣ Ensure Python package structure
mkdir -p src backend src/backend memory_store
touch src/__init__.py src/backend/__init__.py

# 8️⃣ Find free port
BASE_PORT=8000
PORT=$BASE_PORT

for p in $(seq $BASE_PORT 8010); do
    if ! lsof -i :$p >/dev/null 2>&1; then
        PORT=$p
        break
    fi
done

if [ "$PORT" != "$BASE_PORT" ]; then
    echo "⚠️  Port 8000 unavailable — using port $PORT"
fi

# 9️⃣ Export Python path
export PYTHONPATH=src

# 🔟 Start FastAPI server
echo "🌐 Starting FastAPI server on http://127.0.0.1:$PORT"
uvicorn backend.main:app --reload --port "$PORT" &
UVICORN_PID=$!

# 1️⃣1️⃣ Wait a moment for the server to start
sleep 2

# 1️⃣2️⃣ Auto-open browser (macOS / Linux)
URL="http://127.0.0.1:$PORT"

if command -v open >/dev/null 2>&1; then
  open "$URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL"
fi

# 1️⃣3️⃣ Forward logs and keep process in foreground
trap "echo ''; echo '🛑 Shutting down...'; kill $UVICORN_PID" SIGINT SIGTERM
wait $UVICORN_PID
