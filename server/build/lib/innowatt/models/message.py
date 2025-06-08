from pydantic import BaseModel

from innowatt.constants import *

class Message(BaseModel):
    id: str
    author_id: str
    text: str
    created_at: int
