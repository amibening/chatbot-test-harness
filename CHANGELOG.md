# Changelog

All notable changes to the Chatbot Test Harness project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-14

### 🎉 Initial Release

A production-ready ChatGPT-like chatbot with full conversation memory and persistence.

### Added

#### Core Features
- **FastAPI Backend** with RESTful API endpoints
- **OpenAI Integration** for GPT-4, GPT-4o, and GPT-3.5-turbo models
- **ChatGPT-like Behavior** with full conversation context and memory
- **Conversation Persistence** - auto-save/load across browser and server restarts
- **Clean Web Interface** - Modern chat UI with message bubbles
- **Session Management** - Unique sessions per browser with localStorage
- **Debug Tools** - Built-in diagnostics page at `/debug`

#### Configuration
- `.env` file support for API keys and settings
- Configurable system prompts and model selection
- Toggle-able context/memory via `ENABLE_CONTEXT` setting
- Runtime config reload without server restart

#### API Endpoints
- `POST /api/chat` - Send messages and receive AI responses
- `GET /api/session/load` - Load saved conversations
- `POST /api/session/save` - Save conversations manually
- `DELETE /api/session/delete` - Delete conversations
- `GET /api/health` - Health check endpoint
- `POST /api/reload_config` - Reload environment configuration

#### Development Tools
- `setup_env.sh` - Automated environment setup script
- `run.sh` - One-command application launcher
- `pyproject.toml` - Modern Python project configuration (uv support)
- `requirements.txt` - Traditional pip dependency file

#### Documentation
- Complete README with quick start guide
- ChatGPT behavior documentation
- Troubleshooting guide
- Project structure documentation
- Quick start guide
- Environment template (`env.example`)

#### Backend Modules
- `main.py` - FastAPI application and endpoints
- `config.py` - Configuration management
- `query_agent.py` - OpenAI API integration
- `memory.py` - Conversation persistence system

#### Frontend
- `index.html` - Main chat interface
- `debug.html` - Diagnostic and troubleshooting tools

### Technical Details

#### Dependencies
- FastAPI >= 0.115.0
- Uvicorn >= 0.32.0 (with standard extras)
- OpenAI >= 1.54.0
- python-dotenv >= 1.0.0
- Pydantic >= 2.0.0

#### Features
- ✅ Full conversation context (ChatGPT-like behavior)
- ✅ Automatic conversation persistence to JSON files
- ✅ Browser localStorage for session continuity
- ✅ CORS support for cross-origin requests
- ✅ Type hints throughout the codebase
- ✅ Error handling and validation
- ✅ Clean architecture with separation of concerns

### Security
- API keys stored in `.env` (excluded from git)
- User conversations stored locally in `memory_store/` (excluded from git)
- Sanitized session IDs to prevent directory traversal
- Environment template provided (`env.example`)

---

## Release Notes

### v1.0.0 Summary

This is the first stable release of the Chatbot Test Harness. The application is production-ready and provides a complete ChatGPT-like experience with full conversation memory, automatic persistence, and an intuitive web interface.

**Perfect for:**
- Building custom chatbot applications
- Testing different OpenAI models
- Creating conversational AI interfaces
- Learning FastAPI and OpenAI integration
- Prototyping AI-powered applications

**Key Highlights:**
- 🚀 One-command setup and launch
- 💬 ChatGPT-like conversation experience
- 💾 Automatic save/load functionality
- 🔧 Configurable via simple `.env` file
- 📚 Comprehensive documentation
- 🐛 Built-in debugging tools

---

[1.0.0]: https://github.com/yourusername/chatbot-test-harness/releases/tag/v1.0.0

