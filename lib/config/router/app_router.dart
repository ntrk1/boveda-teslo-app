import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';


final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
 return  GoRouter(
  initialLocation: '/check-status-screen',
  refreshListenable: goRouterNotifier,
  routes: [

    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const EpiProductsScreen(),
    ),
    GoRoute(
      path: '/check-status-screen',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),
    GoRoute(
      path: '/produc/:id',
      builder: (context, state) =>  HypoProductScreen(
        productId: state.pathParameters['id'] ?? 'no-id',
      ),
    ),
  ],

  redirect: (context, state) {
     final authStatus = goRouterNotifier.authStatus;
     final isGoingTo = state.matchedLocation;

     if(isGoingTo == '/check-status-screen' && authStatus == AuthStatus.checking) return null;
     if(authStatus == AuthStatus.notAuthenticated) {
      if(isGoingTo == '/login' || isGoingTo == '/register') return null;
     return '/login';
     }
     if(authStatus == AuthStatus.authenticated) {
      if(isGoingTo == '/login' || isGoingTo == '/register' || 
      isGoingTo == '/check-status-screen') {
        return '/';}
     }
     return null;
  },
  
);
});