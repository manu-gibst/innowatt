from innowatt.constants import *

class Message():
    def __init__(self, author_id:str, text:str, created_at, replied_to=None) -> None:
        self.author_id = author_id
        self.text = text
        self.created_at = created_at
        self.replied_to = replied_to

    @staticmethod
    def from_dict(source) -> "Message":
        message = Message(author_id=source[author_id_field],text=source[text_field], created_at=source[created_at_field])

        if replied_to_field in source:
            message.replied_to = source[replied_to_field]
        return message
    
    def to_dict(self):
        dest = {author_id_field: self.author_id, created_at_field: self.created_at, text_field: self.text}

        if self.replied_to:
            dest[replied_to_field] = self.replied_to
        
        return dest
    
    def __repr__(self):
        return f"Message(author_id={self.author_id}, created_at={self.created_at}, text={self.text}, replied_to={self.replied_to})"