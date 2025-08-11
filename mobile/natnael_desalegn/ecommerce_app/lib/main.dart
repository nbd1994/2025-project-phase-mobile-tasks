import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/common/bloc/auth/auth_state.dart';
import 'core/common/bloc/auth/auth_state_cubit.dart';
import 'core/common/bloc/button/button_state_cubit.dart';
import 'features/authentication/presentation/bloc/user_display_cubit.dart';
import 'features/authentication/presentation/pages/signin.dart';
import 'features/authentication/presentation/pages/signup.dart';
import 'features/authentication/presentation/pages/splash_screen.dart';
import 'features/chat/presentation/pages/chat_room_page.dart';
import 'features/chat/presentation/pages/chats_page.dart';
import 'features/chat/presentation/pages/users_page.dart';
import 'injection_container.dart';
import 'add_product.dart';
import 'features/product_mgt/presentation/bloc/product_mgt_bloc.dart';
import 'features/product_mgt/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'features/product_mgt/presentation/pages/product_details.dart';
import 'search_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthStateCubit()..appStarted()),
        BlocProvider(create: (context) => sl<ProductMgtBloc>()),
      ],
      child: BlocBuilder<AuthStateCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthInitialState) {
            return const SplashScreen();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF5F5F5),
              primaryColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black87),
                titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF007AFF),
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                titleMedium: TextStyle(fontSize: 14, color: Colors.grey),
                titleSmall: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),

            initialRoute:
                state is AuthAuthenticatedState ? '/' : '/splash-screen',

            routes: {
              '/':
                  (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => sl<ButtonStateCubit>()),
                      BlocProvider(
                        create:
                            (context) => sl<UserDisplayCubit>()..displayUser(),
                      ),
                    ],
                    child: const HomePage(),
                  ),

              '/add-product': (context) => const AddProduct(),
              '/product-details': (context) => const ProductDetails(),
              '/search': (context) => const SearchProduct(),

              //auth
              '/signin':
                  (context) => BlocProvider(
                    create: (context) => sl<ButtonStateCubit>(),
                    child: SigninPage(),
                  ),
              '/signup':
                  (context) => BlocProvider(
                    create: (context) => sl<ButtonStateCubit>(),
                    child: SignupPage(),
                  ),
              '/splash-screen': (context) => const SplashScreen(),

              //chat
              '/chats': (context) => const ChatsPage(),
              '/users': (context) => const UsersPage(),
              '/chat-room': (context) {
                final chatId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return ChatRoomPage(chatId: chatId);
              },
            },
          );
        },
      ),
    );
  }
}
