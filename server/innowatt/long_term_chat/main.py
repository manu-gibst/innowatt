# from innowatt.long_term_chat.config import graph
from config import graph


"""
All of the code in this folder is from this tutorial:
https://python.langchain.com/docs/versions/migrating_memory/long_term_memory_agent/
"""


def pretty_print_stream_chunk(chunk):
    for node, updates in chunk.items():
        print(f"Update from node: {node}")
        if "messages" in updates:
            updates["messages"][-1].pretty_print()
        else:
            print(updates)

        print("\n")

config = {"configurable": {"user_id": "1", "thread_id": "1"}}

for chunk in graph.stream({"messages": [("user", "i love pizza")]}, config=config):
    pretty_print_stream_chunk(chunk)