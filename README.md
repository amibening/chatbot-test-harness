
# 🤖 Chatbot Test Harness v1.0

**ChatGPT-like conversational AI with full persistence**

A clean, production-ready FastAPI + OpenAI chatbot with conversation memory that works exactly like ChatGPT. Conversations automatically save and restore across browser sessions.

## ✨ Features

- 💬 **ChatGPT-like interface** - Clean, intuitive chat UI
- 🧠 **Full conversation memory** - AI remembers entire conversation
- 💾 **Auto-save/load** - Conversations persist across browser restarts
- ⚙️ **Configurable** - Control behavior via `.env` file
- 🔄 **Live reload** - Update config without restarting
- 🐛 **Debug tools** - Built-in diagnostics at `/debug`
- 🚀 **Production-ready** - Clean code, type hints, error handling

---

## 🚀 Quick Start

### 1. Setup Environment

```bash
# Install dependencies
chmod +x setup_env.sh
./setup_env.sh
```

### 2. Configure API Key

Create `.env` file:

```ini
OPENAI_API_KEY=sk-your-api-key-here
SYSTEM_PROMPT=You are a helpful assistant.
OPENAI_MODEL=gpt-4o-mini
ENABLE_CONTEXT=true
```

### 3. Run

```bash
chmod +x run.sh
./run.sh
```

Browser opens automatically at `http://127.0.0.1:8000` 🎉

---

## ⚙️ Configuration (.env)

Create a `.env` file in the project root:

```ini
OPENAI_API_KEY=sk-your-key
SYSTEM_PROMPT=You are a helpful assistant.
OPENAI_MODEL=gpt-4o-mini
ENABLE_CONTEXT=true
```

### Configuration Options:

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENAI_API_KEY` | *(required)* | Your OpenAI API key |
| `SYSTEM_PROMPT` | *"You are a helpful assistant."* | System prompt for the AI |
| `OPENAI_MODEL` | `gpt-4o-mini` | OpenAI model to use |
| `ENABLE_CONTEXT` | `true` | Enable conversation history/context (ChatGPT-like behavior) |

### Context Control:

- **`ENABLE_CONTEXT=true`** (Default) - **ChatGPT Behavior**
  - ✅ AI remembers entire conversation
  - ✅ Messages saved to disk
  - ✅ Full conversation history sent to OpenAI
  - ✅ Conversations persist across browser restarts
  
- **`ENABLE_CONTEXT=false`** - **Stateless Mode**
  - ❌ AI treats each message as new (no memory)
  - ❌ Messages NOT saved to disk
  - ❌ No conversation history sent to OpenAI
  - Use for: Privacy, testing, or one-off questions

You can reload config during runtime using the **Reload Config** button in the UI.

---

## 💻 Manual Installation (Alternative)

Instead of using scripts:

```bash
uv venv
source .venv/bin/activate
uv pip install fastapi uvicorn python-dotenv openai
PYTHONPATH=src uv run uvicorn backend.main:app --reload
```

Visit: http://127.0.0.1:8000

---

## 🧩 Project Structure

```
chatbot-test-harness/
├── docs/                      # Documentation
│   ├── CHATGPT_BEHAVIOR.md   # How ChatGPT-like behavior works
│   └── TROUBLESHOOTING.md    # Debug & troubleshooting guide
├── src/
│   ├── backend/
│   │   ├── main.py           # FastAPI app & API endpoints
│   │   ├── config.py         # Configuration management
│   │   ├── query_agent.py    # OpenAI integration
│   │   ├── memory.py         # Conversation persistence
│   │   └── __init__.py
│   └── frontend/
│       ├── index.html        # Main chat UI
│       └── debug.html        # Debug tools
├── memory_store/             # Saved conversations (auto-created)
├── .env                      # Your configuration (not in git)
├── .gitignore
├── CHANGELOG.md              # Version history
├── PROJECT_STRUCTURE.md      # Detailed project documentation
├── README.md                 # This file
├── run.sh                    # Application launcher
└── setup_env.sh              # Environment setup script
```

---

## 🧪 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/chat` | Sends a message to the LLM (with conversation history) |
| GET | `/api/health` | Health check endpoint |
| POST | `/api/reload_config` | Reloads `.env` without restart |
| GET | `/api/session/load` | Loads a saved conversation by session ID |
| POST | `/api/session/save` | Manually saves a conversation |
| DELETE | `/api/session/delete` | Deletes a saved conversation |
| GET | `/debug` | Debug tools for troubleshooting |

## 💾 Conversation Persistence (ChatGPT-like Behavior)

Your conversations are **automatically saved** to disk and will be restored when you reopen the browser!

### How It Works:
- ✅ **Auto-save**: Every message automatically saved to disk
- ✅ **Auto-load**: Previous conversations load on startup
- ✅ **Browser-persistent**: Close browser, reopen → conversation restored!
- ✅ **Server-persistent**: Restart server → conversations still there!
- ✅ **Session-based**: Each browser keeps its own conversation
- ✅ **Clear & Reset**: Use the "Clear Chat" button to start fresh (like ChatGPT's "New Chat")

This works **exactly like ChatGPT** - continuous conversation with full context and memory!

### Storage:
- **Browser**: Session ID stored in `localStorage` (persists across browser restarts)
- **Server**: Full conversations stored in `memory_store/` directory as JSON files
- **One session per browser** (unless you click Clear Chat)

### Testing Persistence:
1. Send some messages
2. **Close your browser completely**
3. Reopen and go to `http://127.0.0.1:8000`
4. ✅ Your conversation is back!

### Troubleshooting:
- 🐛 Visit `/debug` for diagnostic tools
- 📖 See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for detailed help
- 📚 See [docs/CHATGPT_BEHAVIOR.md](docs/CHATGPT_BEHAVIOR.md) for behavior details

---

## 🧰 Tech Stack

- FastAPI
- Uvicorn
- OpenAI Python SDK
- python-dotenv
- uv (venv + package manager)
- Vanilla HTML + JS

---

## 📚 Documentation

- **[docs/CHATGPT_BEHAVIOR.md](docs/CHATGPT_BEHAVIOR.md)** - How the ChatGPT-like behavior works
- **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Debug guide and common issues
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Quick start guide
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Detailed project architecture
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes

## 🛡 License

MIT © 2025
