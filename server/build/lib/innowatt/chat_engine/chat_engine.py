from innowatt.constants import *
from innowatt.chat_engine.gemini import Gemini


class ChatEngine():
    def __init__(self):
        self.gemini = Gemini()
    
    def should_summarize(self, messages_count) -> bool:
        '''
        Returns boolean wheather to create a summary of messages.
        Default value is every 20 messages
        '''
        return messages_count % 20 == 0
    
    def generate_response(self, query, last_messages=[], summary=None, replied_to=None):
        prompt = f'''
You are a Chatbot named Innowatt. You are designed to help people learn about business and innovation 

Generate a response to the following message, using the chat summary, history and last message:
Summary: {summary}
Chat history:
{last_messages}
The last message that should be answered: {query}
'''
        return self.gemini.generate_response(prompt).text

    def summarize(self, new_messages:list[str], prev_summary=None):
        prompt = f'''
You are an AI assistant specializing in summarizing chat conversations while preserving key information and context.

Previous Summary:
{prev_summary}

New Messages:
{new_messages}

Instructions:
1. Carefully review the previous summary and the new messages, but don't overly emphasize that you were provided with a summary and new messages. 
2. Identify the key topics, decisions, and important information discussed in the new messages.
3. Integrate this new information into the previous summary to create an updated summary.
4. Ensure the updated summary is coherent, concise, and accurately reflects the entire conversation so far.
5. Focus on capturing the overall progression of the conversation.
6. If there are conflicting details, prioritize the information from the new messages.

Updated Summary:
'''
        return self.gemini.generate_response(prompt, model_is_pro=False)