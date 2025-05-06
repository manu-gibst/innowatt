from innowatt.constants import *

class Chat():
    def __init__(self, name:str, uids:list, updated_time, summary=None) -> None:
        self.name = name
        self.uids = uids
        self.updated_time = updated_time
        self.summary = summary

    @staticmethod
    def from_dict(source) -> "Chat":
        chat = Chat(name=source[name_field], uids=source[uids_field], updated_time=source[updated_time_field])
        
        if summary_field in source:
            chat.summary = source[summary_field]

        return chat
    
    def to_dict(self):
        dest = {name_field: self.name, uids_field: self.uids, updated_time_field: self.updated_time}

        if self.summary:
            dest[summary_field] = self.summary

        return dest
    
    def __repr__(self) -> str:
        return f"Chat(name: {self.name}, uids: {self.uids}, updated_time: {self.updated_time}, summary: {self.summary})"