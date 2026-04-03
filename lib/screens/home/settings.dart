import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../utils/app_color_picker.dart';
import '../../utils/url_launcher_helper.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    List socialAppNames = ['Whatsapp', 'Instagram', 'Facebook', 'TikTok'];
    List socialAppLinks = [
      'https://wa.me/923166496855',
      'https://www.instagram.com/muhammadfarhankareem95/',
      'https://web.facebook.com/profile.php?id=61561078351823',
      'https://www.tiktok.com/@farhan8551?is_from_webapp=1&sender_device=pc',
    ];
    List socialAppImages = [
      'assets/icons/whatsapp_logo.png',
      'assets/icons/instagram_logo.png',
      'assets/icons/facebook_logo.png',
      'assets/icons/tiktok_logo.png',
    ];
    List<Widget> controlIcons = [
      Icon(Icons.lock_open_outlined),
      Icon(Icons.photo_album_outlined),
      Icon(Icons.color_lens_outlined),
    ];
    List controlTitles = [
      'App Permissions',
      'Change theme',
      'Choose color for AppBar',
    ];

    List helpTitle = ['Help Center', 'Terms of Service', 'Privacy Policy'];
    List<Widget> helpIcons = [
      Icon(Icons.help_outline_sharp),
      Icon(Icons.document_scanner_outlined),
      Icon(Icons.phonelink_lock),
    ];
    List helpLinks = [
      'https://remini.zendesk.com/hc/en-us',
      'https://support.bendingspoons.com/tos?app=4976294245518403860&version=2.2.0',
      'https://support.bendingspoons.com/privacy?app=4976294245518403860&version=3.18.0',
    ];
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        showBackButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Controls',
                style: GoogleFonts.sanchez(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: controlIcons[0],
                    title: Text(
                      controlTitles[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () async {
                      await openAppSettings();
                    },
                  ),
                  ListTile(
                    leading: controlIcons[1],
                    title: Text(
                      controlTitles[1],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  ListTile(
                    leading: controlIcons[2],
                    title: Text(
                      controlTitles[2],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      pickColor(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Social',
                style: GoogleFonts.sanchez(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset(socialAppImages[0]),
                    title: Text(
                      socialAppNames[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(socialAppLinks[0]);
                    },
                  ),
                  ListTile(
                    leading: Image.asset(socialAppImages[1]),
                    title: Text(
                      socialAppNames[1],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(socialAppLinks[1]);
                    },
                  ),
                  ListTile(
                    leading: Image.asset(socialAppImages[2]),
                    title: Text(
                      socialAppNames[2],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(socialAppLinks[2]);
                    },
                  ),
                  ListTile(
                    leading: Image.asset(socialAppImages[3]),
                    title: Text(
                      socialAppNames[3],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(socialAppLinks[3]);
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Help',
                style: GoogleFonts.sanchez(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: helpIcons[0],
                    title: Text(
                      helpTitle[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(helpLinks[0]);
                    },
                  ),
                  ListTile(
                    leading: helpIcons[1],
                    title: Text(
                      helpTitle[1],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(helpLinks[1]);
                    },
                  ),
                  ListTile(
                    leading: helpIcons[2],
                    title: Text(
                      helpTitle[2],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openLink(helpLinks[2]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
