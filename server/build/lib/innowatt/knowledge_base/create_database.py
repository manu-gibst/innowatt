from langchain_community.document_loaders import DirectoryLoader
from langchain_community.document_loaders.csv_loader import CSVLoader
from langchain_community.document_loaders import PyPDFLoader, UnstructuredMarkdownLoader
from langchain_community.document_loaders.merge import MergedDataLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter, MarkdownHeaderTextSplitter
from langchain.schema import Document
from langchain_openai.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
import openai

from dotenv import load_dotenv
import os
import shutil
import pathlib

basedir = pathlib.Path(__file__).parents[2]
# Load environment variables. Assumes that project contains .env file with API keys
load_dotenv(basedir / ".env")
#---- Set OpenAI API key 
# Change environment variable name from "OPENAI_API_KEY" to the name given in 
# your .env file.
openai.api_key = os.environ['OPENAI_API_KEY']

def get_list_of_suffix_files(data_path, suffix) -> list[str]:
    '''Fetches all files from the path with the given suffix'''
    filenames = os.listdir(data_path)
    files = [ filename for filename in filenames if filename.endswith( suffix ) ]
    return [data_path + i for i in files]

CHROMA_PATH = "chroma-vector-store"
DATA_PATH = "data/startup_knowledge/"
MD_PATHS = get_list_of_suffix_files(DATA_PATH, ".md")
CSV_PATHS = get_list_of_suffix_files(DATA_PATH, ".csv")
PDF_PATHS = get_list_of_suffix_files(DATA_PATH, ".pdf")

def markdown_splitter(path) -> list[Document]:
    '''Proccesses a Markdown file by:\n
    * Splitting by headers\n
    * Splitting by characters\n
    Returns a document'''
    headers_to_split_on = [
        ("#", "Header 1"),
        ("##", "Header 2"),
        ("###", "Header 3"),
    ]
    # Load markdown file
    markdown_loader = UnstructuredMarkdownLoader(path)
    markdown_document = markdown_loader.load()[0].page_content
    # Split by headers
    markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on, strip_headers=False)
    md_header_splits = markdown_splitter.split_text(markdown_document)
    # Split by characters
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=800, chunk_overlap=300)
    splits = text_splitter.split_documents(md_header_splits)
    return splits

def loader_all_csv_documents():
    '''Load all CSV files\n
    Returns list of Loaders'''
    loaders = []
    for path in CSV_PATHS:
        loaders.append(CSVLoader(path))
    return loaders

def loader_all_pdf_documents():
    '''Load all PDF files\n
    Returns list of Loaders'''
    loaders = []
    for path in PDF_PATHS:
        loaders.append(PyPDFLoader(path))
    return loaders

def all_md_documents() -> list[Document]:
    '''Load all Markdown files\n
    Returns list of documents'''
    splits = []
    for path in MD_PATHS:
        splits += markdown_splitter(path)
    return splits

def load_all() -> list[Document]:
    all_loader = MergedDataLoader(loaders=loader_all_csv_documents() + loader_all_pdf_documents())
    documents = all_loader.load() + all_md_documents()
    return documents


def generate_data_store():
    documents = load_all()
    save_to_chroma(documents)

def save_to_chroma(chunks: list[Document]):
    # Clear out the database first.
    if os.path.exists(CHROMA_PATH):
        shutil.rmtree(CHROMA_PATH)

    # Create a new DB from the documents.
    db = Chroma.from_documents(
        chunks, OpenAIEmbeddings(), persist_directory=CHROMA_PATH
    )
    db.persist()
    print(f"Saved {len(chunks)} chunks to {CHROMA_PATH}.")
    for i in range(3):
        print(chunks[i].page_content)
        print(chunks[i].metadata)
        print("\n")

def main():
    generate_data_store()

if __name__ == "__main__":
    main()
