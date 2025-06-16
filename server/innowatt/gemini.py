from google import genai
from google.genai import types

import os
from dotenv import load_dotenv
import pathlib

from innowatt.prompts import system_instruction

basedir = pathlib.Path(__file__).parents[1]
load_dotenv()
api_key = os.getenv("GEMINI_API")

light_model = "gemini-1.5-flash-8b"
pro_model = "gemini-1.5-flash"

class Gemini():
    def __init__(self):
        self.client = genai.Client(api_key=api_key)

    def generate_response(self, prompt:str, model_is_pro:bool = True):
        model = light_model
        if model_is_pro:
            model = pro_model
        
        return self.client.models.generate_content(
            model=model,
            contents=[prompt],
            config=types.GenerateContentConfig(
                system_instruction=system_instruction,
            )
        ).text
    
    async def generate_stream_response(self, prompt:str):
        response = self.client.models.generate_content_stream(
            model=pro_model,
            contents=[prompt],
        )
        for chunk in response:
            yield chunk.text
