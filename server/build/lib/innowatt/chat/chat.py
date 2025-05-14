from firestore import Firestore
from innowatt.constants import *
from innowatt.models import Message


class Chat():
    def __init__(self, chat_id, author_id) -> None:
        self.firestore = Firestore()
        self.author_id = author_id
        self.chat_id = chat_id

    def send_message(self, text:str):
        '''Sends message to the chat'''
        self.firestore.send_message(chat_id=self.chat_id, author_id=self.author_id, text=text)

    def last_n_messages(self, n:int) -> list:
        '''Fetches last [n] messages from the chat'''
        list_of_dict = self.firestore.last_n_messages(chat_id=self.chat_id, n=n)

        return [Message.from_dict(dict) for dict in list_of_dict]

    def __messages_count(self) -> int:
        '''Getting the total number of messages in the chat'''
        return self.firestore.messages_count(chat_id=self.chat_id)
    
    def should_summarize(self) -> bool:
        '''
        Returns boolean wheather to create a summary of messages.
        Default value is every 20 messages
        '''
        return self.__messages_count() % 20 == 0

    # def summarize(self):
        
    def get_summary(self):
        chat = self.firestore.get_chat(self.chat_id)
        return chat.summary