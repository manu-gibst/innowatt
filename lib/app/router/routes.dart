abstract final class Routes {
  static const login = '/login';
  static const signUp = '/sign-up';
  static const home = '/';
  static final ChatRoutes chatRoutes = ChatRoutes();

  static const chatsCreateNew = '/chats/new-chat';
}

final class ChatRoutes {
  String get allChats => '/chats';
  String get createNew => '/chats/new-chat';
}
