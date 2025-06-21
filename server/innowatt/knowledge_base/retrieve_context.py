from langchain_chroma import Chroma
from langchain_mistralai.embeddings import MistralAIEmbeddings

from dotenv import load_dotenv
import pathlib

curr_dir = pathlib.Path(__file__).parents[0]

CHROMA_PATH = curr_dir.as_posix() + "/chroma"

basedir = pathlib.Path(__file__).parents[2]
load_dotenv(basedir / ".env")

embedding_function = MistralAIEmbeddings()
db = Chroma(persist_directory=CHROMA_PATH, embedding_function=embedding_function)

def retrieve_context(query:str) -> str:
    """
    Retrieves context from knowledge base
    Args:
        query (str): A text to find the relevant information about
    Returns:
        str: A relevant information or message about no context
    """

    docs = db.similarity_search_with_relevance_scores(query, k = 3)
    
    if len(docs) == 0 or docs[0][1] < 0.7:
        # relevant information wasn't found
        return "Don't use any context, the user asked question not directly" \
        " related to innovation and business. Don't answer the question if it" \
        " is inappropriate for the conversation"
    
    return "\n\n---\n\n".join([doc.page_content for doc, _score in docs])