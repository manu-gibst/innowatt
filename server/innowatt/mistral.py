from mistralai import Mistral as MistralAI
from mistralai.models import UserMessage, SystemMessage

import os
from dotenv import load_dotenv
import pathlib

from innowatt.prompts import system_instruction

basedir = pathlib.Path(__file__).parents[1]
load_dotenv()
api_key = os.getenv("MISTRAL_API_KEY")

light_model = "ministral-3b-latest"
pro_model = "mistral-small-latest"


class Mistral():
    def __init__(self):
        self.client = MistralAI(api_key)

    def generate_response(self, prompt:str, model_is_pro:bool = True):
        model = light_model
        if model_is_pro:
            model = pro_model

        return self.client.chat.complete(
            model=model,
            messages=[
                SystemMessage(content=system_instruction),
                UserMessage(content=prompt)
            ]
        ).choices[0].message.content
    
    async def generate_stream_response(self, prompt:str):
        # Model is always pro
        model = pro_model
        response = await self.client.chat.stream_async(
            model=model,
            messages=[
                SystemMessage(content=system_instruction),
                UserMessage(content=prompt)
            ]
        )
        async for chunk in response:
            if chunk.data.choices[0].delta.content is not None:
                yield chunk.data.choices[0].delta.content.encode('utf-8')