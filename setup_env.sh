#!/bin/bash
# =====================================================
# Chatbot Test Harness — Environment Setup Script
# =====================================================

echo "🛠️  Setting up Chatbot Test Harness environment..."

# 1️⃣ Navigate to the project root (the script's directory)
cd "$(dirname "$0")" || exit 1

# 2️⃣ Check for uv installation
if ! command -v uv &> /dev/null; then
  echo "⚠️  'uv' not found. Installing with pip..."
  pip install uv || { echo "❌ Failed to install uv"; exit 1; }
fi

# 3️⃣ Create virtual environment if missing
if [ ! -d ".venv" ]; then
  echo "📦 Creating new virtual environment..."
  uv venv
else
  echo "✅ Virtual environment already exists."
fi

# 4️⃣ Activate the environment
echo "⚙️  Activating virtual environment..."
source .venv/bin/activate

# 5️⃣ Install dependencies
if [ -f "pyproject.toml" ]; then
  echo "📜 Installing dependencies from pyproject.toml..."
  uv sync
elif [ -f "requirements.txt" ]; then
  echo "📜 Installing dependencies from requirements.txt..."
  uv pip install -r requirements.txt
else
  echo "⚙️  Installing base dependencies manually..."
  uv pip install fastapi uvicorn python-dotenv openai
fi

# 6️⃣ Verify installation
echo "🔍 Checking key packages..."
python - <<'PYCODE'
import sys, pkg_resources
for pkg in ["fastapi", "uvicorn", "python-dotenv", "openai"]:
    try:
        __import__(pkg)
        print(f"✅ {pkg} installed")
    except ImportError:
        print(f"❌ {pkg} missing")
        sys.exit(1)
PYCODE

# 7️⃣ Final message
echo ""
echo "🎯 Environment ready!"
echo "Next step: run your app with:"
echo ""
echo "   ./run.sh"
echo ""
