# 📁 Project Structure

## Directory Layout

```
chatbot-test-harness/
├── docs/                          # Documentation
│   ├── CHATGPT_BEHAVIOR.md       # How ChatGPT-like behavior works
│   └── TROUBLESHOOTING.md        # Debug guide
│
├── src/
│   ├── backend/                   # FastAPI application
│   │   ├── __init__.py
│   │   ├── main.py               # FastAPI app & endpoints
│   │   ├── config.py             # Configuration management
│   │   ├── query_agent.py        # OpenAI integration
│   │   └── memory.py             # Conversation persistence
│   │
│   └── frontend/                  # Web interface
│       ├── index.html            # Main chat UI
│       └── debug.html            # Diagnostic tools
│
├── memory_store/                  # Saved conversations (auto-created)
│   └── session_*.json            # Individual conversation files
│
├── .env                          # Configuration (not in git)
├── .gitignore                    # Git ignore rules
├── CHANGELOG.md                  # Version history
├── README.md                     # Main documentation
├── run.sh                        # Application launcher
└── setup_env.sh                  # Environment setup
```

## File Purposes

### Backend (`src/backend/`)

**`main.py`** - FastAPI application
- API endpoints for chat, sessions, config
- Frontend serving
- CORS configuration
- Startup events

**`config.py`** - Configuration management
- Load settings from `.env`
- Validate configuration
- Print startup information

**`query_agent.py`** - OpenAI integration
- Send messages to OpenAI
- Handle conversation history
- Error handling

**`memory.py`** - Conversation persistence
- Save conversations to JSON
- Load conversations from disk
- Delete conversations
- Session management

### Frontend (`src/frontend/`)

**`index.html`** - Main chat interface
- Chat UI with bubbles
- Message sending
- Session management
- localStorage integration
- Auto-save/load functionality

**`debug.html`** - Diagnostic tools
- localStorage testing
- Server connection checks
- Session verification
- Troubleshooting utilities

### Scripts

**`run.sh`** - Application launcher
- Port management
- Start uvicorn server
- Auto-open browser

**`setup_env.sh`** - Environment setup
- Create virtual environment
- Install dependencies
- Validate installation

### Documentation (`docs/`)

**`CHATGPT_BEHAVIOR.md`**
- How the ChatGPT-like behavior works
- Configuration options
- Testing guides

**`TROUBLESHOOTING.md`**
- Common issues & solutions
- Debug procedures
- FAQ

## API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `POST` | `/api/chat` | Send message & get response |
| `GET` | `/api/session/load` | Load saved conversation |
| `POST` | `/api/session/save` | Manually save conversation |
| `DELETE` | `/api/session/delete` | Delete conversation |
| `GET` | `/api/health` | Health check |
| `POST` | `/api/reload_config` | Reload .env settings |
| `GET` | `/` | Main chat interface |
| `GET` | `/debug` | Debug tools |

## Data Flow

```
User Message
    ↓
Frontend (index.html)
    ↓
POST /api/chat
    ↓
Backend (main.py)
    ↓
query_agent.py → OpenAI API
    ↓
Response
    ↓
memory.py → Save to disk
    ↓
Return to Frontend
    ↓
Display in UI
```

## Configuration Flow

```
.env file
    ↓
config.py → get_config()
    ↓
main.py → Uses settings
    ↓
query_agent.py → Uses API key
    ↓
OpenAI API
```

## Session Management

```
Browser Opens
    ↓
Check localStorage
    ↓
Has session_id? 
    ├─ Yes → Load from memory_store/
    └─ No → Create new session_id
    ↓
Send Messages
    ↓
Auto-save to memory_store/
    ↓
Browser Closes (session_id stays in localStorage)
    ↓
Browser Reopens → Load from memory_store/
```

## Development Workflow

1. **Setup**
   ```bash
   ./setup_env.sh
   ```

2. **Configure**
   - Edit `.env` file
   - Set API key & preferences

3. **Run**
   ```bash
   ./run.sh
   ```

4. **Test**
   - Use main interface at `/`
   - Use debug tools at `/debug`
   - Check logs in terminal

5. **Debug**
   - Browser console (F12)
   - Server terminal output
   - Check `memory_store/` files

## Clean Architecture

- **Separation of concerns**: Config, API, persistence separate
- **Type hints**: Full typing throughout backend
- **Documentation**: Docstrings on all functions
- **Error handling**: Try/except with proper HTTPExceptions
- **Modularity**: Easy to extend or modify

## Version Control

Files tracked in git:
- ✅ Source code (`src/`)
- ✅ Documentation (`docs/`, `*.md`)
- ✅ Scripts (`*.sh`)
- ✅ `.gitignore`

Files NOT tracked:
- ❌ `.env` (secrets)
- ❌ `memory_store/` (user data)
- ❌ `.venv/` (dependencies)
- ❌ `__pycache__/` (Python cache)

## Production Checklist

- [ ] Set strong `OPENAI_API_KEY`
- [ ] Configure `SYSTEM_PROMPT` for your use case
- [ ] Choose appropriate `OPENAI_MODEL`
- [ ] Set `ENABLE_CONTEXT=true` for normal use
- [ ] Review CORS settings in `main.py`
- [ ] Add authentication if needed
- [ ] Set up HTTPS if deploying
- [ ] Monitor `memory_store/` size
- [ ] Regular backups of conversations

---

**Clean, organized, production-ready! 🚀**

