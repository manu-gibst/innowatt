from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import firebase_admin

from dotenv import load_dotenv
import pathlib

from innowatt.config import get_settings
from innowatt.router import router

basedir = pathlib.Path(__file__).parents[0]
load_dotenv(basedir / ".env")

app = FastAPI()
app.include_router(router)
settings = get_settings()
origins = [settings.frontend_url]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
