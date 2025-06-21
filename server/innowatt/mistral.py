from mistralai import Mistral as MistralAI
from mistralai.models import UserMessage, SystemMessage

import os
from dotenv import load_dotenv
import pathlib

from innowatt.prompts import system_instruction, compression_system_instruction

basedir = pathlib.Path(__file__).parents[1]
load_dotenv()
api_key = os.getenv("MISTRAL_API_KEY")

light_model = "ministral-3b-latest"
pro_model = "mistral-small-latest"

show_usage = True

class Mistral():
    def __init__(self):
        self.client = MistralAI(api_key)

    def generate_response(self, prompt:str, compression:bool = False):
        model = pro_model
        instruction = system_instruction
        if compression:
            model = light_model
            instruction = compression_system_instruction


        response =  self.client.chat.complete(
            model=model,
            messages=[
                SystemMessage(content=instruction),
                UserMessage(content=prompt)
            ]
        )

        if show_usage:
            print(response.usage)

        return response.choices[0].message.content
    
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
                if show_usage and chunk.data.usage != None:
                    print(chunk.data.usage)
                
                yield chunk.data.choices[0].delta.content.encode('utf-8')