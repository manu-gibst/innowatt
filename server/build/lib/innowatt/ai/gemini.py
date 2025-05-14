import google.generativeai as genai

import os
from dotenv import load_dotenv
import pathlib

basedir = pathlib.Path(__file__).parents[1]
load_dotenv()
api_key = os.getenv("GEMINI_API")
genai.configure(api_key=api_key)

class GeminiLite():
    '''Gemini class for handling simple tasks'''
    
    def __init__(self):
        self.model = genai.GenerativeModel("gemini-1.5-flash-8b")
        
    def get_response(self, prompt):
        response = self.model.generate_content(prompt)
        return response.text

class GeminiPro():
    '''Gemini class for handling the main tasks that require intelligence'''

    def __init__(self):
        self.model = genai.GenerativeModel(
            model_name="gemini-1.5-flash",
            system_instruction="You are a Chatbot named Innowatt. You are designed to help people learn about business and innovation")
        
    def get_response(self, prompt):
        response = self.model.generate_content(prompt)
        return response.text
