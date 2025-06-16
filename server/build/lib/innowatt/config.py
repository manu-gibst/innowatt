from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin.auth import verify_id_token
from llmlingua import PromptCompressor
from openai import OpenAI

from dotenv import load_dotenv
from functools import lru_cache
import os
import pathlib
from pydantic_settings import BaseSettings
from typing import Annotated, Optional, List
import getpass

from innowatt.models import Message
from prompts import system_instruction

basedir = pathlib.Path(__file__).parents[1]
load_dotenv(basedir / ".env")

def _set_env(var: str):
    if not os.environ.get(var):
        os.environ[var] = getpass.getpass(f'{var}: ')

_set_env("OPENAI_API_KEY")

openAi = OpenAI()


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
    
def _parse_messages(messages:list[Message]):
    result = []
    for message in messages:
        # TODO: make "author_name: message" instead of author_id
        result.append(f"{message.author_id}: {message.text}")
    return result

def compress_prompt(query:str, last_messages:List[Message], summary:str):
    llm_lingua = PromptCompressor()

    last_messages = _parse_messages(last_messages)

    # TODO: assess if this max token limit is enough and how much it will cost on average
    compressed_prompt = llm_lingua.compress_prompt(
        f"Chat Summary: {summary}\n\nLast Messages:\n{"\n".join(last_messages)}",
        instruction=system_instruction,
        question=query,
        target_token=500,
        condition_compare=True,
        condition_in_question="after",
        use_sentence_level_filter=False,
        context_budget="+100",
        dynamic_context_compression_ratio=0.4,
        reorder_context="sort",
    )

    print(f"{compressed_prompt=:}")
    response = openAi.responses.create(
        model="gpt-4o",
        instructions=system_instruction,
        input=compressed_prompt["compressed_prompt"],
        max_output_tokens=500,
        temperature=0,
        top_p=1,
        stream=False,
    )
    print(f"{response=:}")
    return response.output_text