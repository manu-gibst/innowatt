from google import genai

import os
from dotenv import load_dotenv
import pathlib


basedir = pathlib.Path(__file__).parents[1]
load_dotenv()
api_key = os.getenv("GEMINI_API")

light_model = "gemini-1.5-flash-8b"
pro_model = "gemini-1.5-flash"
system_instruction="You are a Chatbot. You are designed to help patient with gut related desieses."

class Gemini():
    def __init__(self):
        self.client = genai.Client(api_key=api_key)

    def generate_response(self, prompt, model_is_pro = True):
        model = light_model
        if model_is_pro:
            model = pro_model
        
        return self.client.models.generate_content(
            model=model,
            contents=[prompt]
        )
