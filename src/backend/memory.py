"""Conversation persistence and memory management."""
import json
import os
from pathlib import Path
from typing import List, Dict, Optional


# Directory where conversations are stored
MEMORY_DIR = Path("memory_store")
MEMORY_DIR.mkdir(exist_ok=True)


def get_conversation_path(session_id: str) -> Path:
    """
    Get the file path for a given session ID.
    
    Args:
        session_id: Unique identifier for the conversation session
    
    Returns:
        Path object for the conversation file
    """
    # Sanitize session_id to prevent directory traversal
    safe_session_id = "".join(c for c in session_id if c.isalnum() or c in ('-', '_'))
    return MEMORY_DIR / f"{safe_session_id}.json"


def save_conversation(session_id: str, conversation_history: List[Dict[str, str]]) -> None:
    """
    Save a conversation to disk.
    
    Args:
        session_id: Unique identifier for the conversation session
        conversation_history: List of messages in format:
            [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}]
    """
    try:
        file_path = get_conversation_path(session_id)
        
        # Save as JSON
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(conversation_history, f, indent=2, ensure_ascii=False)
        
        print(f"💾 Saved conversation: {file_path}")
        
    except Exception as e:
        print(f"❌ Failed to save conversation {session_id}: {e}")
        raise


def load_conversation(session_id: str) -> Optional[List[Dict[str, str]]]:
    """
    Load a conversation from disk.
    
    Args:
        session_id: Unique identifier for the conversation session
    
    Returns:
        List of messages if found, None if not found
    """
    try:
        file_path = get_conversation_path(session_id)
        
        if not file_path.exists():
            print(f"ℹ️ No saved conversation found for session: {session_id}")
            return None
        
        # Load from JSON
        with open(file_path, 'r', encoding='utf-8') as f:
            conversation_history = json.load(f)
        
        print(f"📂 Loaded conversation: {file_path} ({len(conversation_history)} messages)")
        return conversation_history
        
    except Exception as e:
        print(f"❌ Failed to load conversation {session_id}: {e}")
        return None


def delete_conversation(session_id: str) -> bool:
    """
    Delete a conversation from disk.
    
    Args:
        session_id: Unique identifier for the conversation session
    
    Returns:
        True if deleted successfully, False if not found
    """
    try:
        file_path = get_conversation_path(session_id)
        
        if not file_path.exists():
            print(f"ℹ️ No conversation found to delete: {session_id}")
            return False
        
        # Delete the file
        file_path.unlink()
        print(f"🗑️ Deleted conversation: {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Failed to delete conversation {session_id}: {e}")
        raise


def list_conversations() -> List[str]:
    """
    List all saved conversation session IDs.
    
    Returns:
        List of session IDs
    """
    try:
        json_files = MEMORY_DIR.glob("*.json")
        session_ids = [f.stem for f in json_files]
        return sorted(session_ids)
    except Exception as e:
        print(f"❌ Failed to list conversations: {e}")
        return []

