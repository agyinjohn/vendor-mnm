import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/notification_page.dart';
import 'package:mnm_vendor/screens/add_store_page.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/verification_page.dart';
import 'package:mnm_vendor/screens/dashboard_loading_page.dart';
import 'package:mnm_vendor/screens/no_stores.dart';
import 'package:mnm_vendor/screens/store_selection_page.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/selected_store_notifier.dart';
import '../utils/store_notifier.dart';
import '../utils/update_fcm_token.dart';
import 'dashboard_fragments/analytics_fragment.dart';
import 'dashboard_fragments/home_fragment.dart';
import 'dashboard_fragments/orders_fragment.dart';
import 'dashboard_fragments/profile_fragment.dart';
import 'dashboard_fragments/products_fragment.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});
  static const routeName = '/dashboard';
  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int index = 0;
  late String usertoken;
  bool isLoading = false;
  getUserStore() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences pref = await SharedPreferences.getInstance();

      final token = pref.getString('token');
      setState(() {
        usertoken = token!;
      });
      print("Store token");
      print(token);
      await ref
          .read(storeProvider.notifier)
          .fetchStores(token!, context)
          .then((_) {
        final stores = ref.read(storeProvider);
        print(stores);
        if (stores.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
          // Load selected store or select the first one
          ref
              .read(selectedStoreProvider.notifier)
              .loadSelectedStore(stores)
              .then((_) {
            print(stores);
          });
        } else {
          showCustomSnackbar(
              context: context,
              message: 'Your Account is not complete',
              duration: const Duration(milliseconds: 20),
              action: SnackBarAction(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const KycVerificationScreen()));
                  }));
          // Handle no stores available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const KycVerificationScreen()));
          });
        }
      });
      // setState(() {
      //   isLoading = false;
      // });
    } on ClientException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const NoStores()));
      });
      showCustomSnackbar(context: context, message: e.toString());
    } catch (e) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pushReplacementNamed(context, '/no-stores');
      // });
      showCustomSnackbar(context: context, message: e.toString());
    }
  }

//
  // Request permission for notifications on iOS
  Future<void> requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Initialize the local notifications settings
  void initializeFlutterLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Display the notification when received
  void showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  // Set up Firebase Messaging listeners
  void setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get and print the Firebase Messaging token
    messaging.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message);
      }
    });

    // Listen to messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // You can navigate to a specific screen here if needed
    });
  }

//

  @override
  void initState() {
    super.initState();

    getUserStore();
    requestNotificationPermissions(); // Step 1: Request notification permissions
    initializeFlutterLocalNotifications(); // Step 2: Initialize local notifications
    setupFirebaseMessaging();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Call a function to update the token in the backend
      print(newToken);
      updateFCMTokenInBackend(newToken, usertoken);
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Fetch stores in the background when app is resumed
      getUserStore();
    }
  }

  List<Map<String, dynamic>> menu = [
    {
      'icon': const Icon(IconlyBroken.home),
      'icon_active': const Icon(IconlyBold.home),
      'label': 'Home',
      'fragment': const HomeFragment(),
      'title': "Mealex & Mailex(M&M)",
      'trailing': (BuildContext context) => [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, NotificationsPage.routeName);
              },
              icon: const Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 30,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 8,
                      child: Center(
                        child: Text(
                          '9+',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                // Handle the selected option
                if (value == 1) {
                  Navigator.pushNamed(context, StoreSelectionPage.routeName);
                } else if (value == 2) {
                  Navigator.pushNamed(context, AddStorePage.routeName);
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(value: 1, child: Text('Switch store')),
                  const PopupMenuItem(value: 2, child: Text('Add a store'))
                ];
              },
            )
          ]
    },
    {
      'icon': const Icon(IconlyBroken.paper),
      'icon_active': const Icon(IconlyBold.paper),
      'label': 'Orders',
      'fragment': const OrdersFragment(),
      'title': "Orders",
      'trailing': (BuildContext context) =>
          [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    },
    {
      'icon': const Icon(IconlyBroken.star),
      'icon_active': const Icon(IconlyBold.star),
      'label': 'Products',
      'fragment': const ProductsFragment(),
      'title': "Products",
      'trailing': (BuildContext context) =>
          [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    },
    {
      'icon': const Icon(IconlyBroken.activity),
      'icon_active': const Icon(IconlyBold.activity),
      'label': 'Analytics',
      'fragment': const AnalyticsFragment(),
      'title': "Analytics",
      'trailing': (BuildContext context) =>
          [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    },
    {
      'icon': const Icon(IconlyBroken.profile),
      'icon_active': const Icon(IconlyBold.profile),
      'label': 'Profile',
      'fragment': const ProfileFragment(),
      'title': "Profile",
      'trailing': (BuildContext context) =>
          [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    },
  ];

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return isLoading
        ? const SafeArea(child: Center(child: DashboardLoadingScreen()))
        : Scaffold(
            appBar: AppBar(
              actions: menu[index]['trailing'](context),
              title: Text(
                menu[index]['title'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: menu[index]['fragment'] as Widget,
            bottomNavigationBar: SizedBox(
              height: 64,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedLabelStyle: GoogleFonts.nunito().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black,
                ),
                unselectedLabelStyle: GoogleFonts.nunito().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black45,
                ),
                backgroundColor: AppColors.backgroundColor,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black45,
                currentIndex: index,
                onTap: (newIndex) {
                  setState(() {
                    index = newIndex;
                  });
                },
                items: menu.map((item) {
                  return BottomNavigationBarItem(
                    icon: item['icon'] as Icon,
                    activeIcon: item['icon_active'] as Icon,
                    label: item['label'] as String,
                  );
                }).toList(),
              ),
            ),
          );
  }
}
