import 'package:flutter/foundation.dart';
import 'package:socialite/firebase_options.dart';
import 'package:socialite/layout/Home/home_layout.dart';
import 'package:socialite/pages/Login/login_screen.dart';
import 'package:socialite/pages/on-boarding/on_boarding_screen.dart';
import 'package:socialite/shared/components/show_toast.dart';
import 'package:socialite/shared/cubit/socialCubit/social_cubit.dart';
import 'package:socialite/shared/cubit/socialCubit/social_state.dart';
import 'package:socialite/shared/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialite/shared/enum/enum.dart';
import 'package:socialite/shared/network/dio_helper.dart';
import 'package:socialite/shared/styles/themes.dart';
import 'package:wakelock/wakelock.dart';
import 'shared/components/constants.dart';
import 'shared/network/cache_helper.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showToast(text: 'You Received Message', state: ToastStates.success);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }
  ScreenUtil.ensureScreenSize();
  Wakelock.enable();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  //when the app is opened
  FirebaseMessaging.onMessage.listen((event) {
    showToast(text: 'You Received Message', state: ToastStates.success);
  });
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'on Message Opened App', state: ToastStates.success);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  uId = CacheHelper.getData(key: 'uId');
  debugPrint('*** User ID == $uId ***');

  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  if (onBoarding != null) {
    if (uId != null) {
      widget = const HomeLayout();
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const OnBoard();
  }
  runApp(
    MyApp(
      startWidget: widget,
      isDark: isDark,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget, this.isDark})
      : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPosts()
            ..getAllUsers()
            ..getStories()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'socialite',
                theme: getThemeData[AppTheme.lightTheme],
                darkTheme: getThemeData[AppTheme.darkTheme],
                themeMode: uId == null
                    ? ThemeMode.system
                    : SocialCubit.get(context).isDark
                        ? ThemeMode.light
                        : ThemeMode.dark,
                debugShowCheckedModeBanner: false,
                home: startWidget,
              );
            },
          );
        },
      ),
    );
  }
}
