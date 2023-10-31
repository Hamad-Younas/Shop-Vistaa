import 'package:admin/constant.dart';
import 'package:admin/screens/chart_container.dart';
import 'package:admin/widgets/activity_header.dart';
import 'package:admin/widgets/bar_chart.dart';
import 'package:admin/widgets/planing_grid.dart';
import 'package:admin/widgets/planing_header.dart';
import 'package:admin/widgets/products_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import './products.dart';
import './users.dart';
import './profile.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import './orders.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Home Page'),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Hello ",
                    style: TextStyle(color: kDarkBlue, fontSize: 20),
                    children: [
                      TextSpan(
                        text: "Admin",
                        style: TextStyle(
                            color: kDarkBlue, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ", welcome back!",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Stats",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const CourseGrid(),
                const SizedBox(
                  height: 20,
                ),
                // const PlaningHeader(),
                // const SizedBox(
                //   height: 15,
                // ),
                // const PlaningGrid(),
                // const SizedBox(
                //   height: 15,
                // ),
                // const Text(
                //   "Statistics",
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // const StatisticsGrid(),
                // const SizedBox(
                //   height: 15,
                // ),
                const ActivityHeader(),
                const ChartContainer(chart: BarChartContent())
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            // Handle bottom navigation item taps
            if (index == 1) {
              // Navigate to the Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimatedSplashScreen(
                          splash: Image.asset('assets/logo.png'),
                          nextScreen: Productpage(),
                          splashTransition: SplashTransition.fadeTransition,
                        )),
              );
            }
            if (index == 2) {
              // Navigate to the Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimatedSplashScreen(
                          splash: Image.asset('assets/logo.png'),
                          nextScreen: UsersPage(),
                          splashTransition: SplashTransition.fadeTransition,
                        )),
              );
            }
            if (index == 3) {
              // Navigate to the Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimatedSplashScreen(
                          splash: Image.asset('assets/logo.png'),
                          nextScreen: OrdersPage(),
                          splashTransition: SplashTransition.fadeTransition,
                        )),
              );
            }
            if (index == 4) {
              // Navigate to the Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimatedSplashScreen(
                          splash: Image.asset('assets/logo.png'),
                          nextScreen: ProfileScreen(),
                          splashTransition: SplashTransition.fadeTransition,
                        )),
              );
            }
          },
        ),
      ),
    );
  }
}

class DoughnutGraph extends StatelessWidget {
  final String title;
  final List<PieChartSectionData> data;

  DoughnutGraph({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        AspectRatio(
          aspectRatio: 1.0,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 30,
              startDegreeOffset: 180,
              sections: data,
            ),
          ),
        ),
      ],
    );
  }
}
