#!/bin/bash
# =====================================================
# Chatbot Test Harness — Environment Setup Script
# Clean, modern, safe version
# =====================================================

set -e  # Exit immediately on error

echo "🛠️  Setting up Chatbot Test Harness environment..."

# 1️⃣ Navigate to project root
cd "$(dirname "$0")" || exit 1

# 2️⃣ Ensure Python version is valid
python3 - <<'EOF'
import sys
if sys.version_info < (3,10):
    print("❌ Python 3.10+ is required for FastAPI + uv")
    sys.exit(1)
EOF

# 3️⃣ Ensure uv is installed
if ! command -v uv &> /dev/null; then
  echo "⚠️  'uv' not found — installing..."
  pip install uv || { echo "❌ Failed to install uv"; exit 1; }
fi

# 4️⃣ Create virtual environment (force .venv)
if [ ! -d ".venv" ]; then
  echo "📦 Creating virtual environment at .venv..."
  uv venv .venv
else
  echo "✅ Virtual environment already exists."
fi

# 5️⃣ Activate venv
echo "⚙️  Activating virtual environment..."
source .venv/bin/activate

# 6️⃣ Install dependencies
if [ -f "pyproject.toml" ]; then
  echo "📜 Installing dependencies from pyproject.toml..."
  uv sync
elif [ -f "requirements.txt" ]; then
  echo "📜 Installing dependencies from requirements.txt..."
  uv pip install -r requirements.txt
else
  echo "📦 Installing minimal dependencies..."
  uv pip install fastapi uvicorn python-dotenv openai
fi

# 7️⃣ Validate imports
echo "🔍 Validating installed packages..."
python - <<'PYCODE'
import sys

packages = {
    "fastapi": "fastapi",
    "uvicorn": "uvicorn",
    "python-dotenv": "dotenv",
    "openai": "openai",
}

missing = False
for label, import_name in packages.items():
    try:
        __import__(import_name)
        print(f"✅ {label} installed")
    except ImportError:
        print(f"❌ {label} missing (import failed for: {import_name})")
        missing = True

if missing:
    sys.exit(1)
PYCODE

# 8️⃣ Check for .env file
echo ""
echo "🔍 Checking for .env..."

if [ ! -f ".env" ]; then
cat <<EOF

❌ .env file not found!

Create one using:

   cp env.example .env
   nano .env

Required keys:

   OPENAI_API_KEY=sk-xxxx...
   SYSTEM_PROMPT=You are a helpful assistant.
   OPENAI_MODEL=gpt-4o-mini
   ENABLE_CONTEXT=true

EOF
else
  echo "✅ .env found"

  # Validate OPENAI_API_KEY (must start with sk- but not be placeholder)
  KEY=$(grep -E '^OPENAI_API_KEY=' .env | cut -d'=' -f2)

  if [[ -z "$KEY" || "$KEY" == "sk-your-api-key-here" ]]; then
    echo "⚠️  OPENAI_API_KEY appears to be missing or placeholder"
  else
    echo "🔑 OPENAI_API_KEY is configured"
  fi
fi

# 9️⃣ Final message
echo ""
echo "🎯 Environment setup complete!"
echo ""

if [[ -n "$KEY" && "$KEY" != "sk-your-api-key-here" ]]; then
  echo "✅ Ready to run: ./run.sh"
else
  echo "⏳ Fix your .env file, then run: ./run.sh"
fi

echo ""
