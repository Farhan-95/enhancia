import 'package:enhancia/provider/gallery_provider.dart';
import 'package:enhancia/provider/theme_provider.dart';
import 'package:enhancia/screens/splash/splash_screen.dart';
import 'package:enhancia/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enhancia',
      theme: themeProvider.isDarkTheme ? darkTheme : lightTheme,
      home: Splashscreen(),
    );
  }
}
