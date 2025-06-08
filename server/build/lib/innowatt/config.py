from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin.auth import verify_id_token

from dotenv import load_dotenv
from functools import lru_cache
import os
import pathlib
from pydantic_settings import BaseSettings
from typing import Annotated, Optional

from innowatt.models import Message

basedir = pathlib.Path(__file__).parents[1]
load_dotenv(basedir / ".env")

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
    
def parse_messages(messages:list[Message]):
    result = []
    for message in messages:
        # TODO: make "author_name: message" instead of author_id
        result.append(f"{message.author_id}: {message.text}")
    return result