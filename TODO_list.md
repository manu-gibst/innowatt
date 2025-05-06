# TODO API list
## Chat related:
* Prompt engineering
  * Implement RAG
  * Retrive messages context (last 7 messages, replied to message, summary)
  * Put into prompt the correct learning module
* Send prompt and get response
* Making a summary every 20 messages

## Keeping track of leaning modules
* Storing the index of module on database
* Upgrading to the new module once user passes the evaluation by AI

## Keeping track of notes
* Storing notes as file (or json if you will use `flutter-quill`) on the database
* Appending progress to the chat's notes (agent functionality)
* Displaying notes on the app

## Diplaying Notes
* ### Separate Files for each module sections
  [Flutter Quill Package](https://github.com/singerdmx/flutter-quill/)\
  [GoogleDocs Flutter Clone](https://github.com/funwithflutter/google-docs-clone-flutter)
* ### Fancy Graph (possibly in future)
  [Graph Visualization Framework in JS]()
  
  Rendering JS in Flutter\
  [StackOverflow related issue](https://stackoverflow.com/questions/59600520using-html-code-with-a-javascript-code-as-a-widget-in-flutter-web)\
  [From Flutter Documentation](https://docs.flutter.dev/platform-integration/web/renderers)