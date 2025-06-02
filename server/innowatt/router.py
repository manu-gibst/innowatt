from fastapi import APIRouter, Depends

from typing import Annotated, List

from innowatt.config import get_firebase_user_from_token, parse_messages
from innowatt.chat_engine import ChatEngine

router = APIRouter()

@router.get("/")
def hello():
    return {"msg": "Hello World!"}

# TODO: remove later
@router.get("/userid")
async def get_userid(user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """gets the firebase connected user"""
    return {"id": user["uid"]}

@router.get("/{chatid}/generate-response")
async def get_response(chatid: str, last_messages: List[str], summary: str, user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """generates AI response based on [last_messages] and [summary]"""
    chat_engine = ChatEngine()
    parsed_messages = parse_messages(last_messages)
    print(parse_messages)
    return {"details": "success"}
    # chat_engine.generate_response(query=last_messages[0], last_messages=last_messages)