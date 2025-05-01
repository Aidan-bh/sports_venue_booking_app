import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spod_app/modules/setting/add_payment_card_view.dart';
import 'package:spod_app/utils/dummy_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkMode = false; // This will hold the theme state

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load the theme preference when the page is initialized
  }

  // Load theme preference from SharedPreferences
  _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save the theme preference to SharedPreferences
  _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? darkBlue700 : backgroundColor, // Dynamically update the background color based on theme
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          "Settings",
          style: titleTextStyle,
        ),
        backgroundColor: _isDarkMode ? darkBlue700 : backgroundColor, // AppBar background color based on theme
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              Text(
                "Account",
                style: subTitleTextStyle.copyWith(color: primaryColor500),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/user_profile_example.png"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sampleUser.name,
                            style: subTitleTextStyle,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryColor100.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryColor500),
                            ),
                            child: Text(
                              sampleUser.accountType,
                              style: descTextStyle.copyWith(color: primaryColor500),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Payment Section
              Text(
                "Payment",
                style: subTitleTextStyle.copyWith(color: primaryColor500),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPaymentCardView(),
                    ),
                  );
                },
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite,
                        ),
                        child: const Icon(
                          CupertinoIcons.creditcard_fill,
                          size: 24,
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Payment method", style: normalTextStyle),
                          const SizedBox(height: 8),
                          Text("Not Set", style: descTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Theme Section with Switch
              Text(
                "Other",
                style: subTitleTextStyle.copyWith(color: primaryColor500),
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isDarkMode = !_isDarkMode; // Toggle theme mode
                  });
                  _saveThemePreference(_isDarkMode); // Save the theme preference
                },
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite,
                        ),
                        child: const Icon(
                          CupertinoIcons.moon_circle,
                          size: 24,
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Theme", style: normalTextStyle),
                          const SizedBox(height: 8),
                          Text(_isDarkMode ? "Dark" : "Light", style: descTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Language Section (Restored)
              InkWell(
                onTap: () {},
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite,
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          size: 24,
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Language", style: normalTextStyle),
                          const SizedBox(height: 8),
                          Text("English", style: descTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // About Section (Restored)
              const SizedBox(height: 32),
              Text(
                "About App",
                style: subTitleTextStyle.copyWith(color: primaryColor500),
              ),
              InkWell(
                onTap: () {
                  _showSnackBar(context, "Newest Version");
                },
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite,
                        ),
                        child: const Icon(
                          CupertinoIcons.info_circle_fill,
                          size: 24,
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spod - Sports Venue Booking App",
                              style: normalTextStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Version 1.0.0",
                              style: descTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => launch("https://github.com/mikirinkode"),
                splashColor: primaryColor100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite,
                        ),
                        child: Image.asset(
                          "assets/icons/github.png",
                          color: darkBlue300,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Github", style: normalTextStyle),
                            const SizedBox(height: 8),
                            Text("github.com/mikirinkode", style: descTextStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Created with ", style: normalTextStyle),
                  const SizedBox(width: 4),
                  Text("{code}", style: subTitleTextStyle.copyWith(color: primaryColor500)),
                  const SizedBox(width: 4),
                  Text("and", style: normalTextStyle),
                  const SizedBox(width: 4),
                  const Icon(Icons.favorite_rounded, color: Colors.red)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: primaryColor500,
    ));
  }
}
