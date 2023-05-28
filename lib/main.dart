import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/courier.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/mainPage.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itec404_delivery_app/pages/order.dart';
import 'package:itec404_delivery_app/pages/makeOrder.dart';
import 'package:itec404_delivery_app/pages/account.dart';
import 'package:itec404_delivery_app/pages/more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itec404_delivery_app/pages/passwordreset.dart';
import 'package:itec404_delivery_app/pages/review.dart';
import 'package:itec404_delivery_app/pages/orderDetail.dart';
import 'Pages/about.dart';
import 'Pages/contact.dart';
import 'Pages/courrier.dart';
import 'Pages/changepass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Pages/admin.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  bool isWeb = GetPlatform.isWeb;

  WidgetsFlutterBinding.ensureInitialized();
  if (isWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC-Bh9XwKf8WIN8yXBf85dhE1jZE0tExds",
        authDomain: "itec404deliveryapp.web.app",
        projectId: "itec404deliveryapp",
        storageBucket: "itec404deliveryapp.appspot.com",
        messagingSenderId: "655429434868",
        appId: "1:655429434868:web:b7f78f4334dd7f1e3bcda1",
        measurementId: "G-4JTX4BW6WX",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  bool _isAdmin = false;
  String role = prefs.getString('role') ?? '';
  _isAdmin = role == 'Admin';

  bool _isCourier = false;
  String role1 = prefs.getString('role') ?? '';
  _isCourier = role == 'Courier';

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(isDarkMode: isDarkMode),
      child: MyApp(
        isLoggedIn: isLoggedIn,
        isAdmin: _isAdmin,
        isCourier: _isCourier,
        firestore: FirebaseFirestore.instance,
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider({required bool isDarkMode}) : _isDarkMode = isDarkMode;

  ThemeData get themeData => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;
  final bool isCourier;
  final FirebaseFirestore firestore;

  const MyApp({
    Key? key,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.isCourier,
    required this.firestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData,
        initialRoute: isLoggedIn ? '/mainPage' : '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/mainPage': (context) => MainPage(),
          '/order': (context) => OrderPage(),
          '/makeorder': (context) => MakeOrderPage(controller: TextEditingController()),
          '/account': (context) => Account(firestore: firestore),
          '/more': (context) => More(),
          '/orderdetail': (context) => OrderDetail(
            documentId: ModalRoute.of(context)!.settings.arguments as String,
          ),
          '/about': (context) => About(),
          '/contact': (context) => Contact(),
          '/courrier': (context) => Courrier(),
          '/changepass': (context) => Changepass(),
          '/reset': (context) => PasswordResetForm(),
          '/review': (context) => ReviewPage(
            documentId: ModalRoute.of(context)!.settings.arguments as String,
          ),
          '/admin': (context) {
            if (isAdmin) {
              return AdminPage();
            } else {
              // Redirect to a different page or show an error message
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text('Access Denied'),
                ),
              );
            }
          },
          '/courier': (context) {
            if (isCourier || isAdmin) {
              return CourierPage();
            } else {
              // Redirect to a different page or show an error message
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text('Access Denied'),
                ),
              );
            }
          },
        },
      ),
    );
  }
}
