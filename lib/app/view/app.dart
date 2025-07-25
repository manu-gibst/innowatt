import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/bloc/app_bloc.dart';
import 'package:innowatt/app/router/router.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/theme/theme.dart';
import 'package:innowatt/theme/util.dart';
import 'dart:math' show pi;

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        )..add(const AppUserSubscriptionRequested()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late GoRouter _router;

  @override
  void didChangeDependencies() {
    _router = router(context.watch<AppBloc>());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Innowatt',
      theme: theme.dark(),
      routerConfig: _router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutPressed());
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: TestAnimation(),
      ),
    );
  }
}

enum CircleSide {
  left,
  right;

  Path toPath(Size size) {
    var path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
    }
    path.arcToPoint(
      offset,
      radius: Radius.circular(size.height / 2),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  HalfCircleClipper({super.reclip, required this.side});

  final CircleSide side;

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is HalfCircleClipper && oldClipper.side != side;
  }
}

class TestAnimation extends StatefulWidget {
  const TestAnimation({super.key});

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation _flipAnimation;

  @override
  void initState() {
    super.initState();

    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // Remember that in Flutter - positive angles mean clockwise movement
    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(CurvedAnimation(
      parent: _counterClockwiseRotationController,
      curve: Curves.bounceOut,
    ));

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );

    _counterClockwiseRotationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
            begin: _flipAnimation.value,
            end: _flipAnimation.value + pi,
          ).animate(
            CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
          );

          _flipController
            ..reset()
            ..forward();
        }
      },
    );

    _flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _counterClockwiseRotationAnimation = Tween<double>(
            begin: _counterClockwiseRotationAnimation.value,
            end: _counterClockwiseRotationAnimation.value - pi / 2,
          ).animate(CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ));

          _counterClockwiseRotationController
            ..reset()
            ..forward();
        }
      },
    );

    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(null);
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _counterClockwiseRotationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(
                  _counterClockwiseRotationAnimation.value,
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(
                            _flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            color: Colors.blue,
                            width: 100,
                            height: 200,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(
                            _flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            color: Colors.white,
                            width: 100,
                            height: 200,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        FilledButton(
          onPressed: () {
            context.go(Routes.projectRoutes.allProjects);
          },
          child: const Text("Click me for the new Home"),
        ),
      ],
    );
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration? duration) {
    return Future.delayed(duration ?? const Duration(seconds: 1), this);
  }
}
