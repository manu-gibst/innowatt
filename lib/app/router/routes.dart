abstract final class Routes {
  static const login = '/login';
  static const signUp = '/sign-up';
  static const home = '/';
  static final ChatRoutes chatRoutes = ChatRoutes();
}

final class ChatRoutes {
  String get allChats => '/chats';
  String singleUserChat({required String chatId}) => '/chats/$chatId';
}
