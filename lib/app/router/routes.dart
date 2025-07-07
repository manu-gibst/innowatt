abstract final class Routes {
  static const login = '/login';
  static const signUp = '/sign-up';
  static const home = '/';
  static final projectRoutes = ProjectRoutes();
  static final chatRoutes = ChatRoutes();
}

final class ProjectRoutes {
  String get allProjects => '/projects';
  String projectScreen({required String projectId}) => '/project/$projectId';
}

final class ChatRoutes {
  String get allChats => '/chats';
  String singleUserChat({required String chatId}) => '/chats/$chatId';
}
