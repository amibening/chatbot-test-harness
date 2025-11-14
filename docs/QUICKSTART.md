# 🚀 Quick Start Guide

## 30-Second Setup

```bash
# 1. Setup environment
chmod +x setup_env.sh && ./setup_env.sh

# 2. Create .env file
cat > .env << EOF
OPENAI_API_KEY=sk-your-api-key-here
SYSTEM_PROMPT=You are a helpful assistant.
OPENAI_MODEL=gpt-4o-mini
ENABLE_CONTEXT=true
EOF

# 3. Run
./run.sh
```

✅ **Done!** Browser opens at `http://127.0.0.1:8000`

---

## What You Get

- 💬 ChatGPT-like chat interface
- 🧠 Full conversation memory
- 💾 Auto-save/load across browser restarts
- 🐛 Debug tools at `/debug`

---

## First Steps

1. **Send a message** - Type and hit Enter
2. **See memory in action** - AI remembers your conversation
3. **Test persistence** - Close browser, reopen → conversation restored!
4. **Start fresh** - Click "Clear Chat" to begin new conversation

---

## Common Tasks

### Change AI Model
Edit `.env`:
```ini
OPENAI_MODEL=gpt-4o-mini  # or gpt-4, gpt-3.5-turbo, etc.
```

Click "Reload Config" button in UI.

### Disable Memory/Context
Edit `.env`:
```ini
ENABLE_CONTEXT=false
```

Click "Reload Config" button in UI.

### View Saved Conversations
```bash
ls -la memory_store/
cat memory_store/session_*.json
```

---

## Troubleshooting

### Issue: Chat not saving
- Visit `/debug` page
- Check browser console (F12)
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Issue: API errors
- Verify `OPENAI_API_KEY` in `.env`
- Check terminal for error messages
- Ensure you have API credits

### Issue: Server won't start
```bash
# Kill any process on port 8000
lsof -ti :8000 | xargs kill -9

# Try again
./run.sh
```

---

## Next Steps

📖 **Learn More:**
- [CHATGPT_BEHAVIOR.md](CHATGPT_BEHAVIOR.md) - How memory works
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues
- [../PROJECT_STRUCTURE.md](../PROJECT_STRUCTURE.md) - Project details
- [../README.md](../README.md) - Full documentation
- [../CHANGELOG.md](../CHANGELOG.md) - Version history

---

**Happy chatting! 🎉**

