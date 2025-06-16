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

@router.post("/{chatid}/generate-response")
async def get_response(chatid: str, last_messages: List[Message], summary: str, user: Annotated[dict, Depends(get_firebase_user_from_token)]):
    """generates AI response based on [last_messages] and [summary]"""
    chat = Chat(chat_id=chatid, last_messages=last_messages)
    return StreamingResponse(
        chat.generate_stream_response(),
        media_type="text/plain",
    )

def test():
    for i in range(5):
        yield f"Chunk {i+1}\n"
        time.sleep(1)

@router.post("/test_stream")
async def test_stream():
    return StreamingResponse(test(), media_type="text/plain")