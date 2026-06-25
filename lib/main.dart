import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hrms_ys/app/packages.dart';
import 'package:hrms_ys/app/presentation/screens/splash/splash_screen.dart';
import 'app/core/configs/app_configs.dart';
import 'app/firebase/firebase_message.dart';
import 'app/firebase/firebase_options.dart';
import 'app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(AppConfig.appStorageName);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await NotificationService.service.init();
  await AppFirebaseMessage.instance.permission();
  await AppFirebaseMessage.instance.receiveMessage();

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  FirebaseAnalytics.instance.logAppOpen();

  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HRMS YS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
