import 'package:enhancia/provider/gallery_provider.dart';
import 'package:enhancia/screens/camera/camera_screen.dart';
import 'package:enhancia/screens/result/layouts/mobile_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enhancia/screens/home/settings.dart';
import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../services/api service/api_service.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  bool _isCheckingPermission = true;
  bool? hasPermission;

  @override
  void initState() {
    super.initState();
    _checkPhotoPermission();
  }

  void _checkPhotoPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      hasPermission = true;
      _isCheckingPermission = false;
      await context.read<GalleryProvider>().loadImages();
    } else {
      hasPermission = false;
      _isCheckingPermission = false;
    }
    setState(() {});
  }

  void _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );
    } else {
      _requestCameraPermission();
    }
    setState(() {});
  }

  void _requestCameraPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );
    }
  }

  void _requestPhotoPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      hasPermission = true;
      await context.read<GalleryProvider>().loadImages();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/black_logo.png'),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Enhancia',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              themeProvider.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhance✨',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Photos',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 185),
                IconButton(
                  onPressed: _checkCameraPermission,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isCheckingPermission
                  ? const Center(child: CircularProgressIndicator())
                  : !hasPermission!
                  ? _permissionRequiredUI(themeProvider)
                  : Consumer<GalleryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: provider.images.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => _showPreviewDialog(provider, index, themeProvider),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AssetEntityImage(
                              provider.images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionRequiredUI(ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.black),
          const Text('To enhance, Enhancia needs access to', style: TextStyle(color: Colors.black)),
          const Text('your photos.', style: TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _requestPhotoPermission,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50),
                backgroundColor: themeProvider.appBarColor,
              ),
              child: const Text('Give Access', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog(GalleryProvider provider, int index, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AssetEntityImage(
                height: 300,
                width: double.infinity,
                provider.images[index],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Close preview dialog
                Navigator.pop(context);

                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
                );

                try {
                  final file = await provider.getFile(provider.images[index]);
                  if (file == null) throw Exception("Failed to get image file");

                  final enhancedFile = await ApiService.enhanceImage(file);

                  Navigator.pop(context); // close loading

                  if (enhancedFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileResultScreen(
                          originalImage: file,
                          enhancedImage: enhancedFile,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enhancement failed")),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // make sure loading is closed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 60),
                backgroundColor: themeProvider.appBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              child: const Text('Enhance'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}