import 'package:demo/repositories/firestore_product_repo.dart';
import 'package:demo/repositories/product_repo.dart';
import 'package:demo/services/firestore_service.dart';
import 'package:demo/viewmodels/auth_cubit.dart';
import 'package:demo/viewmodels/product_viewmodel.dart';
import 'package:demo/views/auth/auth_page.dart';
import 'package:demo/viewmodels/auth_states.dart';
import 'package:demo/repositories/firebase_auth_repo.dart';
import 'package:demo/firebase_options.dart';
import 'package:demo/views/home/home_page.dart';
import 'package:demo/views/common/loading_page.dart';
import 'package:demo/themes/dark_mode.dart';
import 'package:demo/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    // setup auth cubit and product viewmodel with providers
    return MultiProvider(
      providers: [
        Provider<FirestoreProductService>(
          create: (_) => FirestoreProductService(FirebaseFirestore.instance),
        ),
        Provider<ProductRepository>(
          create: (context) => FirestoreProductRepository(
            context.read<FirestoreProductService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsViewModel(
            productRepository: context.read<ProductRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          darkTheme: darkMode,

          // bloc consumer for auth cubit
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              // unauthenticated state => show auth page
              if (state is Unauthenticated) {
                return const AuthPage();
              }
              // authenticated state => show home page
              if (state is Authenticated) {
                return const HomePage();
              }
              // loading state => show loading page
              else {
                return const LoadingScreen();
              }
            },
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}
