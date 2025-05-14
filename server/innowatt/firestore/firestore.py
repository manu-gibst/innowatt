import firebase_admin
from firebase_admin import firestore as firestore_admin
from google.cloud import firestore

from dotenv import load_dotenv
import pathlib

from innowatt.constants import *
from innowatt.models import Message, Chat
import innowatt.constants as constants

basedir = pathlib.Path(__file__).parents[1]
load_dotenv(basedir / ".env")

app = firebase_admin.initialize_app()

class Firestore():
    def __init__(self, chat_id:str) -> None:
        self.db = firestore_admin.client()
        self.chat = self.db.collection(chats_collection).document(chat_id)
        self.messages = self.chat.collection(messages_collection)

    def send_message(self, text:str) -> None:
        '''Creates a message document in Firestore'''
        message = Message(
                author_id='bot_id', 
                text=text,
                created_at=firestore.SERVER_TIMESTAMP
            )
        self.messages.document().set(message.to_dict())

        self.update_messages_count(1 + self.messages_count())

    def update_messages_count(self, messages_count:int):
        '''Updated number messages field in Firestore'''
        self.chat.update({"message_count": messages_count})

    def last_n_messages(self, n:int) -> list:
        '''Fetches last [n] messages from the chat'''
        docs = self.messages.order_by(created_at_field, direction=firestore.Query.DESCENDING).limit(n).stream()

        return [doc.to_dict() for doc in docs]
    
    def messages_count(self):
        '''Getting the total count of documents of messages collection'''
        try:
            chat = self.chat.get().to_dict
            if chat is dict:
                return int(chat.to_dict()[constants.messages_count])
            return 0
        except:
            return 0
        
    def get_summary(self) -> str:
        '''Returns summary from the Firestore'''
        try:
            chat = self.chat.get().to_dict()
            if chat is dict:
                return chat.to_dict().get(constants.summary_field)
            return "No summary"
        except:
            return "No summary"
        
    def update_summary(self, new_summary:str):
        '''Updates summary field'''
        self.chat.update({"summary": new_summary})
        