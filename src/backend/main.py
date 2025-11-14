
"""
FastAPI application for chatbot test harness.
Provides API endpoints for chat, session management, and configuration.
"""
import os
from pathlib import Path
from typing import List, Optional

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel
from dotenv import load_dotenv

from .query_agent import chat_with_openai
from .memory import save_conversation, load_conversation, delete_conversation
from .config import get_config, print_startup_info

load_dotenv()

app = FastAPI(
    title="Chatbot Test Harness",
    version="1.0.0",
    description="ChatGPT-like chatbot with conversation persistence"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic models
class ChatMessage(BaseModel):
    """Single chat message with role and content."""
    role: str
    content: str


class ChatRequest(BaseModel):
    """Request model for chat endpoint."""
    message: str
    history: Optional[List[ChatMessage]] = None
    session_id: Optional[str] = None


class ChatResponse(BaseModel):
    """Response model for chat endpoint."""
    reply: str


class SessionLoadResponse(BaseModel):
    """Response model for session load endpoint."""
    session_id: str
    history: List[ChatMessage]
    loaded: bool


class SessionSaveRequest(BaseModel):
    """Request model for session save endpoint."""
    session_id: str
    history: List[ChatMessage]

# API Endpoints
@app.post("/api/chat", response_model=ChatResponse)
def chat_endpoint(payload: ChatRequest) -> ChatResponse:
    """
    Process a chat message and return AI response.
    Optionally saves conversation based on ENABLE_CONTEXT setting.
    """
    try:
        _, _, _, enable_context = get_config()
        
        # Convert history to dict format if provided AND if context is enabled
        history = []
        if enable_context and payload.history:
            history = [{"role": msg.role, "content": msg.content} for msg in payload.history]
        
        # Send to OpenAI with or without context
        reply = chat_with_openai(payload.message, conversation_history=history if history else None)
        
        # Auto-save conversation if session_id provided AND context enabled
        if enable_context and payload.session_id:
            updated_history = history + [
                {"role": "user", "content": payload.message},
                {"role": "assistant", "content": reply}
            ]
            save_conversation(payload.session_id, updated_history)
            print(f"💾 Saved conversation to session {payload.session_id} ({len(updated_history)} messages)")
        elif not enable_context:
            print("ℹ️ Context disabled via .env - message not saved")
        
        return ChatResponse(reply=reply)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/session/load")
def load_session(session_id: str) -> SessionLoadResponse:
    """Load a saved conversation session."""
    try:
        history = load_conversation(session_id)
        if history:
            chat_messages = [
                ChatMessage(role=msg["role"], content=msg["content"]) 
                for msg in history
            ]
            return SessionLoadResponse(session_id=session_id, history=chat_messages, loaded=True)
        return SessionLoadResponse(session_id=session_id, history=[], loaded=False)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/session/save")
def save_session(payload: SessionSaveRequest) -> dict:
    """Manually save a conversation session."""
    try:
        history = [{"role": msg.role, "content": msg.content} for msg in payload.history]
        save_conversation(payload.session_id, history)
        return {"status": "ok", "message": f"Session {payload.session_id} saved successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/session/delete")
def delete_session(session_id: str) -> dict:
    """Delete a conversation session."""
    try:
        deleted = delete_conversation(session_id)
        if deleted:
            return {"status": "ok", "message": f"Session {session_id} deleted"}
        raise HTTPException(status_code=404, detail="Session not found")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/health")
def health_check() -> dict:
    """Simple health check endpoint that doesn't call OpenAI."""
    return {"status": "ok", "message": "Server is running"}


@app.post("/api/reload_config")
def reload_config() -> dict:
    """Reload environment variables from .env file."""
    try:
        load_dotenv(override=True)
        return {"status": "ok", "message": "Environment variables reloaded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to reload: {e}")


# Frontend serving
FRONTEND_DIR = Path(__file__).resolve().parents[1] / "frontend"
FRONTEND_DIR.mkdir(parents=True, exist_ok=True)

app.mount("/static", StaticFiles(directory=FRONTEND_DIR), name="static")


@app.get("/", include_in_schema=False)
def serve_index() -> FileResponse:
    """Serve the main chat interface."""
    index_file = FRONTEND_DIR / "index.html"
    if index_file.exists():
        return FileResponse(index_file)
    return JSONResponse({"status": "error", "message": "Frontend not found"})


@app.get("/debug", include_in_schema=False)
def serve_debug_page() -> FileResponse:
    """Serve the diagnostic page for testing localStorage persistence."""
    debug_file = FRONTEND_DIR / "debug.html"
    if debug_file.exists():
        return FileResponse(debug_file)
    return JSONResponse({"status": "error", "message": "Debug page not found"})


# Startup event
@app.on_event("startup")
def startup_event() -> None:
    """Print configuration information on startup."""
    print_startup_info()
