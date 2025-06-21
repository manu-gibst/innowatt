from pydantic import BaseModel

from innowatt.constants import *

class Message(BaseModel):
    author_id: str
    text: str
