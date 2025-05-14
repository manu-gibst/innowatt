import gemini

class ChatEngine():
    def __init__(self) -> None:
        self.llm_lite = gemini.GeminiLite()
        self.llm_pro = gemini.GeminiPro()

    def summarize(self, new_messages:list[str], prev_summary=None):
        prompt = f'''
You are an AI assistant specializing in summarizing chat conversations while preserving key information and context.

Previous Summary:
{prev_summary}

New Messages:
{new_messages}

Instructions:
1. Carefully review the previous summary and the new messages.
2. Identify the key topics, decisions, and important information discussed in the new messages.
3. Integrate this new information into the previous summary to create an updated summary.
4. Ensure the updated summary is coherent, concise, and accurately reflects the entire conversation so far.
5. Focus on capturing the overall progression of the conversation.
6. If there are conflicting details, prioritize the information from the new messages.

Updated Summary:
'''
        return self.llm_lite.get_response(prompt)
    
    def generate_response(self, query, last_messages=None, summary=None, replied_to=None, )
