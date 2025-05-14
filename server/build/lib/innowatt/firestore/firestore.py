import firebase_admin
from firebase_admin import firestore as firestore_admin
from google.cloud import firestore
from google.cloud.firestore_v1 import aggregation

from dotenv import load_dotenv
import pathlib

from innowatt.constants import *
from innowatt.models import Message, Chat

basedir = pathlib.Path(__file__).parents[1]
load_dotenv(basedir / ".env")

app = firebase_admin.initialize_app()

class Firestore():
    def __init__(self) -> None:
        self.db = firestore_admin.client()
        self.chats = self.db.collection(chats_collection)

    def send_message(self, chat_id:str, author_id:str, text:str) -> None:
        '''Creates a message document in Firestore'''
        messages = self.chats.document(chat_id).collection(messages_collection)

        message = Message(
                author_id=author_id, 
                text=text,
                created_at=firestore.SERVER_TIMESTAMP
            )
        messages.document().set(message.to_dict())

    def last_n_messages(self, chat_id:str, n:int) -> list:
        '''Fetches last [n] messages from the chat'''
        messages = self.chats.document(chat_id).collection(messages_collection)
        docs = messages.order_by(created_at_field, direction=firestore.Query.DESCENDING).limit(n).stream()

        return [doc.to_dict() for doc in docs]
    
    def messages_count(self, chat_id:str):
        # Not working yet
        '''Getting the total count of documents of messages collection'''
        messages = self.chats.document(chat_id).collection(messages_collection)
        aggregate_query = aggregation.AggregationQuery(messages)
        aggregate_query.count(alias="all")

        results = aggregate_query.get()
        for result in results:
            print(f"Alias of results from query: {result.alias}")
            print(f"Number of results from query: {result.value}")
        
        return int(results[0].value)

    def get_chat(self, chat_id:str) -> Chat:
        '''Returns a Chat'''
        chat_ref = self.chats.document(chat_id)
        chat = chat_ref.get()
        if not chat.exists:
            raise Exception('chat_id is incorrect')
        
        chat = Chat.from_dict(chat.to_dict())
        return chat
        