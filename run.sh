#!/bin/bash
# =====================================================
# Chatbot Test Harness FastAPI Launcher
# =====================================================

# 1️⃣ Ensure we're in the correct project directory
cd "$(dirname "$0")" || exit 1

# 2️⃣ Check if virtual environment exists
if [ ! -d ".venv" ]; then
  echo "⚠️  Virtual environment not found!"
  echo "Please run: ./setup_env.sh first"
  exit 1
fi

# 3️⃣ Check if .env file exists
if [ ! -f ".env" ]; then
  echo "⚠️  .env file not found!"
  echo ""
  echo "Please create a .env file with your configuration:"
  echo ""
  echo "cat > .env << EOF"
  echo "OPENAI_API_KEY=sk-your-api-key-here"
  echo "SYSTEM_PROMPT=You are a helpful assistant."
  echo "OPENAI_MODEL=gpt-4o-mini"
  echo "ENABLE_CONTEXT=true"
  echo "EOF"
  echo ""
  exit 1
fi

# 4️⃣ Create memory_store directory if needed
if [ ! -d "memory_store" ]; then
  echo "📁 Creating memory_store directory..."
  mkdir -p memory_store
fi

# 5️⃣ Make sure src/backend is a proper Python package
if [ ! -f "src/__init__.py" ]; then
  echo "Creating missing __init__.py in src/..."
  touch src/__init__.py
fi

if [ ! -f "src/backend/__init__.py" ]; then
  echo "Creating missing __init__.py in src/backend/..."
  touch src/backend/__init__.py
fi

# 6️⃣ Kill any old Uvicorn process using port 8000
PID=$(lsof -ti :8000)
if [ -n "$PID" ]; then
  echo "Killing old process on port 8000 (PID: $PID)..."
  kill "$PID"
  sleep 1
  kill -9 "$PID" 2>/dev/null
fi

# 7️⃣ Find a free port if 8000 is still taken
PORT=8000
if lsof -i :$PORT > /dev/null 2>&1; then
  for p in $(seq 8001 8010); do
    if ! lsof -i :$p > /dev/null 2>&1; then
      PORT=$p
      break
    fi
  done
  echo "⚠️  Port 8000 in use, switching to $PORT"
fi

# 8️⃣ Activate virtual environment and start the FastAPI app
echo "🚀 Starting FastAPI server on http://127.0.0.1:$PORT ..."
source .venv/bin/activate
PYTHONPATH=src uvicorn backend.main:app --reload --port $PORT &

# Save the background process ID
UVICORN_PID=$!

# 9️⃣ Wait a moment for the server to start
sleep 3

# 🔟 Automatically open browser (macOS and Linux)
if command -v open >/dev/null 2>&1; then
  open "http://127.0.0.1:$PORT"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://127.0.0.1:$PORT"
fi

# 1️⃣1️⃣ Bring Uvicorn logs to the foreground
wait $UVICORN_PID
