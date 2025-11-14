# 🔧 Troubleshooting Guide

## Quick Diagnostics

Visit `http://127.0.0.1:8000/test` for automated localStorage testing.

## Common Issues

### 1. Conversation Not Persisting

**Symptoms:** Conversations don't reload after closing browser

**Causes:**
- Browser in Incognito/Private mode
- Browser privacy settings clearing data on exit
- Different browser profile each time

**Solutions:**
1. Check browser mode (not private/incognito)
2. Adjust browser privacy settings
3. Visit `/test` page to diagnose localStorage

### 2. Server Won't Start

**Check:**
```bash
# Port already in use?
lsof -ti :8000

# Dependencies installed?
source .venv/bin/activate
pip list | grep -E "fastapi|uvicorn|openai"
```

### 3. API Key Issues

**Check `.env` file:**
```bash
cat .env | grep OPENAI_API_KEY
```

Should see valid key starting with `sk-proj-` or `sk-`

### 4. Context Not Working

**Check `.env` setting:**
```ini
ENABLE_CONTEXT=true
```

Server startup should show:
```
🔄 Context/History: ENABLED
```

## Debug Tools

### Check Saved Conversations
```bash
ls -la memory_store/
cat memory_store/session_*.json | python3 -m json.tool
```

### Check Browser Console
Press F12 → Console tab
Look for: `💾 Conversation saved!`

### Server Logs
Watch terminal for:
```
💾 Saved conversation to session [id] (X messages)
```

## Need Help?

1. Check logs in terminal
2. Check browser console (F12)
3. Visit `/test` page for diagnostics
4. Review `README.md` for configuration

