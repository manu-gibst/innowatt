from langchain_community.document_loaders import DirectoryLoader
from langchain_community.document_loaders.csv_loader import CSVLoader
from langchain_community.document_loaders import PyPDFLoader, UnstructuredMarkdownLoader
from langchain_community.document_loaders.merge import MergedDataLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter, MarkdownHeaderTextSplitter
from langchain.schema import Document
from langchain_mistralai.embeddings import MistralAIEmbeddings
from langchain_community.vectorstores import Chroma
import openai
from mistralai import Mistral

import  base64
from dotenv import load_dotenv
import os
import shutil
import pathlib
import getpass


# ----------------------------------------------------------------------------
# Whenever the folder `data` changes, run this python file again to generate
# a vector store
# ----------------------------------------------------------------------------


basedir = pathlib.Path(__file__).parents[2]
# Load environment variables. Assumes that project contains .env file with API keys
load_dotenv(basedir / ".env")
#---- Set API keys
# openai.api_key = os.environ['OPENAI_API_KEY']

def get_api(api:str):
    if not os.getenv(api):
        os.environ[api] = getpass.getpass(f"Enter your {api}: ")

mistral_api = get_api("MISTRAL_API_KEY")

def get_list_of_suffix_files(data_path, suffix) -> list[str]:
    '''Fetches all files from the path with the given suffix'''
    filenames = os.listdir(data_path)
    files = [ filename for filename in filenames if filename.endswith( suffix ) ]
    return [data_path + i for i in files]

curr_dir = pathlib.Path(__file__).parents[0]

CHROMA_PATH = curr_dir.as_posix() + "/chroma"
DATA_PATH = curr_dir.as_posix() + "/data/startup_knowledge/"

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
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=300, chunk_overlap=50)
    splits = text_splitter.split_documents(md_header_splits)
    return splits

def loader_all_csv_documents():
    '''Load all CSV files\n
    Returns list of Loaders'''
    print(f'Loading {len(CSV_PATHS)} .csv files...')
    loaders = []
    for path in CSV_PATHS:
        loaders.append(CSVLoader(path))
    return loaders

def _encode_pdf(pdf_path):
    """Encode the pdf to base64."""
    try:
        with open(pdf_path, "rb") as pdf_file:
            return base64.b64encode(pdf_file.read()).decode('utf-8')
    except FileNotFoundError:
        print(f"Error: The file {pdf_path} was not found.")
        return None
    except Exception as e:  # Added general exception handling
        print(f"Error: {e}")
        return None

def _create_md(path, content:str):
    "Creates .md file or overrides if it already exists"
    with open(path, "w") as file:
        file.write(content)
    print(f"Markdown {path} created.")

def loader_all_pdf_documents(force_convert:bool=False):
    '''Convert all PDF files to .md
    Args:
        force_convert(bool): Force converting .pdf files to .md even if .md \
            version already exists
    Returns:
        Nothing'''
    loaders = []
    mistral = Mistral(api_key=mistral_api)
    print(f'Converting {len(PDF_PATHS)} .pdf files to .md...')
    for path in PDF_PATHS:
        md_path = path[:path.rfind('.')] + '.md'

        if os.path.exists(md_path) and not force_convert:
            # Pdf file already converted
            continue

        base64_pdf = _encode_pdf(path)
        ocr_response = mistral.ocr.process(
            model='mistral-ocr-latest',
            document={
                'type': 'document_url',
                'document_url': f'data:application/pdf;base64,{base64_pdf}'
            }
        )
        
        markdowns: list[str] = [page.markdown for page in ocr_response.pages]
        _create_md(md_path, "\n\n".join(markdowns))

def all_md_documents() -> list[Document]:
    '''Load all Markdown files\n
    Returns list of documents'''
    print(f'Loading {len(MD_PATHS)} .md files...')
    splits = []
    for path in MD_PATHS:
        splits += markdown_splitter(path)
    return splits

def load_all() -> list[Document]:
    all_loader = MergedDataLoader(loaders=loader_all_csv_documents() + loader_all_pdf_documents())
    documents = all_loader.load() + all_md_documents()
    print("All documents loaded!")
    return documents


def generate_data_store():
    documents = load_all()
    save_to_chroma(documents)

def save_to_chroma(chunks: list[Document]):
    print("Saving documents to chroma...")
    # Clear out the database first.
    if os.path.exists(CHROMA_PATH):
        shutil.rmtree(CHROMA_PATH)

    # Create a new DB from the documents.
    db = Chroma.from_documents(
        chunks, MistralAIEmbeddings(), persist_directory=CHROMA_PATH
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
