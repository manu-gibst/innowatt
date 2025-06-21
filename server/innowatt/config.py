from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin.auth import verify_id_token

import asyncio
from functools import lru_cache
import os
from pydantic_settings import BaseSettings
from typing import Annotated, Optional, List

from innowatt.models import Message
from innowatt.mistral import Mistral
from innowatt.prompts import compression_prompt_template
from innowatt.knowledge_base import retrieve_context
from innowatt.firestore import Firestore
# from innowatt.func_tokens import estimate_tokens

bearer_scheme = HTTPBearer(auto_error=False)

class Settings(BaseSettings):
    """Main Settings"""
    app_name: str = "innowatt-app"
    env: str = os.getenv("ENV", "development")
    frontend_url: str = os.getenv("FRONTEND_URL", "NA")

@lru_cache
def get_settings() -> Settings:
    """Retrives the fastapi settings"""
    return Settings()

def get_firebase_user_from_token(
        token: Annotated[Optional[HTTPAuthorizationCredentials], Depends(bearer_scheme)],
) -> Optional[dict]:
    """Uses firebase token to identify user id
    Args: 
        token: the bearer token. Can be None as we set auto_error to False
    Returns:
        dict: the firebase user on success
    Raises:
        HTTPException 401 if user does not exist or token is invalid
    """
    try:
        if not token:
            raise ValueError("No token")
        user = verify_id_token(token.credentials)
        return user
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not logged in or Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
def _parse_messages(messages:list[Message]) -> List[str]:
    result = []
    for message in messages:
        # TODO: make "author_name: message" instead of author_id
        result.append(f"{message.author_id}: {message.text}")
    return result

class Chat():
    def __init__(self, chat_id:str, last_messages:List[Message]):
        self.firestore = Firestore(chat_id)
        self.last_messages = _parse_messages(last_messages)

    def _get_summary(self) -> str:
        return self.firestore.get_summary()

    def _update_summary(self, new_summary:str):
        self.firestore.update_summary(new_summary)

    def _distill_prompt(self, query:str) -> str:
        prompt = compression_prompt_template.format(
            query=query,
            summary=self._get_summary(),
            last_messages=self.last_messages,
            context=retrieve_context(query),
        )
        
        return Mistral().generate_response(prompt, model_is_pro=False)
    
    def get_response(self, query:str) -> str:
        """Generate a response in sync"""
        prompt = self._distill_prompt(query)
        result = Mistral().generate_response(prompt)
        self.firestore.send_message(result)
        return result
    
    async def generate_stream_response(self, query:str):
        """Generate a streaming response in async"""
        prompt = self._distill_prompt(query)
        async for chunk in Mistral().generate_stream_response(prompt):
            yield chunk
