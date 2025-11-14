"""Configuration management for the chatbot application."""
import os
from typing import Tuple
from pathlib import Path


def get_config() -> Tuple[str, str, str, bool]:
    """
    Load configuration from environment variables.
    
    Returns:
        Tuple of (api_key, system_prompt, model_name, enable_context)
    """
    api_key = os.getenv("OPENAI_API_KEY", "")
    system_prompt = os.getenv("SYSTEM_PROMPT", "You are a helpful assistant.")
    model_name = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
    enable_context = os.getenv("ENABLE_CONTEXT", "true").lower() == "true"
    
    return api_key, system_prompt, model_name, enable_context


def print_startup_info() -> None:
    """Print configuration information at startup."""
    print("\n🔍 Environment Check — Chatbot Test Harness Startup")
    
    env_file = Path(".env")
    if env_file.exists():
        print(f"📄 Loaded environment from: {env_file.resolve()}")
    else:
        print("⚠️ No .env file found — using system environment variables only")
    
    api_key, system_prompt, model_name, enable_context = get_config()
    
    if api_key:
        print(f"✅ OPENAI_API_KEY found (length: {len(api_key)})")
    else:
        print("❌ Missing OPENAI_API_KEY")
    
    if system_prompt:
        print(f"✅ SYSTEM_PROMPT found (length: {len(system_prompt)})")
    else:
        print("⚠️ SYSTEM_PROMPT not set — using default")
    
    print(f"🤖 Using model: {model_name}")
    context_status = "ENABLED" if enable_context else "DISABLED"
    behavior = "ON" if enable_context else "OFF"
    print(f"🔄 Context/History: {context_status} (ChatGPT-like behavior: {behavior})")
    print("✅ FastAPI app initialized successfully!\n")

