from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse

from typing import Annotated, List
import time

from innowatt.config import Chat, get_firebase_user_from_token
from innowatt.models import Message

router = APIRouter()

@router.get("/")
def hello():
    return {"msg": "Hello World!"}

# TODO: remove later
@router.get("/userid")
async def get_userid(user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """gets the firebase connected user"""
    return {"id": user["uid"]}

@router.post("/test")
def test(message: Message):
    return {"details": message}

@router.post("/{chatid}/get-response")
def get_response(chatid: str, query:str, last_messages: List[Message], user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """Generates AI response based on [last_messages] and [summary]"""
    chat = Chat(chat_id=chatid, last_messages=last_messages)
    response = chat.get_response(query)
    return {
        "message": "success",
        "response": response
        }

@router.post("/{chatid}/stream-response")
async def get_response(chatid: str, query:str, last_messages: List[Message], user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """Generates stream AI response based on [last_messages] and [summary]"""
    chat = Chat(chat_id=chatid, last_messages=last_messages)
    return StreamingResponse(
        await chat.generate_stream_response(query), 
        media_type='text/plain',
    )