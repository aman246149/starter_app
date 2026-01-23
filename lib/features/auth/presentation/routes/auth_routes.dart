part of '../../../../core/navigation/app_router.dart';

@TypedGoRoute<AuthRoute>(
  path: RouteDefinitions.authPath,
  name: RouteDefinitions.authName,
)
@immutable
final class AuthRoute extends BaseRoute with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthPage();
  }
}
