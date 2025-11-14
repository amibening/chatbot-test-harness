"""OpenAI API integration for chatbot queries."""
import os
from typing import List, Dict, Optional
from openai import OpenAI

from .config import get_config


def chat_with_openai(
    user_message: str, 
    conversation_history: Optional[List[Dict[str, str]]] = None
) -> str:
    """
    Send a message to OpenAI and get a response.
    
    Args:
        user_message: The user's message
        conversation_history: Optional list of previous messages in format:
            [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}]
    
    Returns:
        The assistant's response as a string
    
    Raises:
        Exception: If API key is missing or API call fails
    """
    api_key, system_prompt, model_name, _ = get_config()
    
    if not api_key:
        raise ValueError(
            "OPENAI_API_KEY not found. Please set it in your .env file or environment variables."
        )
    
    # Initialize OpenAI client
    client = OpenAI(api_key=api_key)
    
    # Build message list
    messages = [{"role": "system", "content": system_prompt}]
    
    # Add conversation history if provided
    if conversation_history:
        messages.extend(conversation_history)
    
    # Add current user message
    messages.append({"role": "user", "content": user_message})
    
    try:
        # Call OpenAI API
        response = client.chat.completions.create(
            model=model_name,
            messages=messages,
            temperature=0.7,
            max_tokens=2000,
        )
        
        # Extract and return the assistant's reply
        reply = response.choices[0].message.content
        return reply if reply else "I apologize, but I couldn't generate a response."
        
    except Exception as e:
        error_msg = f"OpenAI API Error: {str(e)}"
        print(f"❌ {error_msg}")
        raise Exception(error_msg)

