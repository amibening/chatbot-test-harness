#!/bin/bash
# =====================================================
# Chatbot Test Harness — Environment Setup Script
# =====================================================

echo "🛠️  Setting up Chatbot Test Harness environment..."

# FastAPI + uv rely on Python 3.10+
python3 - <<'EOF'
import sys
if sys.version_info < (3,10):
    print("❌ Python 3.10+ is required")
    sys.exit(1)
EOF

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
  uv venv .venv
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

# 7️⃣ Check for .env file
echo ""
echo "🔍 Checking for .env configuration file..."
if [ ! -f ".env" ]; then
  echo ""
  echo "⚠️  =========================================="
  echo "⚠️  IMPORTANT: .env file not found!"
  echo "⚠️  =========================================="
  echo ""
  echo "📋 You need to create a .env file before running the app."
  echo ""
  echo "Quick Setup:"
  echo "------------"
  echo "1. Copy the example file:"
  echo "   cp env.example .env"
  echo ""
  echo "2. Edit .env and add your OpenAI API key:"
  echo "   nano .env"
  echo "   (or use your preferred editor)"
  echo ""
  echo "3. Required configuration:"
  echo "   OPENAI_API_KEY=sk-your-actual-api-key-here"
  echo "   SYSTEM_PROMPT=You are a helpful assistant."
  echo "   OPENAI_MODEL=gpt-4o-mini"
  echo "   ENABLE_CONTEXT=true"
  echo ""
  echo "📚 For detailed instructions, see:"
  echo "   • README.md (Quick Start section)"
  echo "   • docs/QUICKSTART.md"
  echo ""
  echo "🔑 Get your OpenAI API key from:"
  echo "   https://platform.openai.com/api-keys"
  echo ""
  echo "⚠️  The app will NOT work without a valid .env file!"
  echo ""
else
  echo "✅ .env file found"
  
  # Check if API key is set (not the example value)
  if grep -q "sk-your-api-key-here" .env 2>/dev/null || ! grep -q "OPENAI_API_KEY=sk-" .env 2>/dev/null; then
    echo ""
    echo "⚠️  WARNING: OPENAI_API_KEY may not be configured correctly"
    echo "   Please edit .env and add your actual OpenAI API key"
    echo "   Get your key from: https://platform.openai.com/api-keys"
    echo ""
  else
    echo "✅ OPENAI_API_KEY appears to be configured"
  fi
fi

# 8️⃣ Final message
echo ""
echo "🎯 Environment setup complete!"
echo ""
if [ -f ".env" ] && grep -q "OPENAI_API_KEY=sk-" .env 2>/dev/null && ! grep -q "sk-your-api-key-here" .env 2>/dev/null; then
  echo "✅ Ready to run! Start the app with:"
  echo ""
  echo "   ./run.sh"
else
  echo "⏳ Next steps:"
  echo "   1. Create and configure your .env file (see above)"
  echo "   2. Then run: ./run.sh"
fi
echo ""
