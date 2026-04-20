import 'package:enhancia/provider/gallery_provider.dart';
import 'package:enhancia/routes/named_routes.dart';
import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:enhancia/services/api%20service/api_service.dart';
import 'package:enhancia/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../widgets/custom_loader_widget.dart';

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
      if (!mounted) return;
      await context.read<GalleryProvider>().loadImages();
    } else {
      hasPermission = false;
      _isCheckingPermission = false;
    }
    if (mounted) setState(() {});
  }

  void _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (!mounted) return;
    if (status.isGranted) {
      await Navigator.pushNamed(context, AppRoutes.camera);
    } else {
      final request = await Permission.camera.request();
      if (!mounted) return;
      if (request.isGranted) {
        Navigator.pushNamed(context, AppRoutes.camera);
      }
    }
  }

  void _requestPhotoPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      hasPermission = true;
      if (!mounted) return;
      await context.read<GalleryProvider>().loadImages();
    }
    if (mounted) setState(() {});
  }

  // FIXED: Moved inside the State class to resolve 'context' and 'mounted' errors
  void _showPreviewDialog(
    GalleryProvider provider,
    int index,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                isOriginal: false,
                thumbnailSize: const ThumbnailSize(400, 400),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                navigator.pop(); // Close preview

                // 1. Show Custom FYP Loader
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.black,
                  builder: (context) => const NonDismissibleApiLoader(),
                );

                try {
                  final file = await provider.getFile(provider.images[index]);
                  if (file == null) throw "File error";

                  // 2. API Call
                  final enhancedFile = await ApiService.enhanceImage(file);

                  if (!mounted) return;
                  if (navigator.canPop()) navigator.pop(); // Close loader

                  if (enhancedFile != null) {
                    navigator.pushNamed(
                      AppRoutes.result,
                      arguments: {'original': file, 'enhanced': enhancedFile},
                    );
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text("Enhancement failed.",style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (navigator.canPop()) navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text("An Error Occurred"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 60),
                backgroundColor: themeProvider.appBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Enhance AI',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/black_logo.png'),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
            onPressed: () => Navigator.pushNamed(context, AppRoutes.setting),
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhance✨',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                IconButton(
                  onPressed: _checkCameraPermission,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.red,
                    size: 28,
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
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
                              onTap: () => _showPreviewDialog(
                                provider,
                                index,
                                themeProvider,
                              ),
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionRequiredUI(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text(
            'Access to photos is required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _requestPhotoPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.appBarColor,
            ),
            child: const Text('Grant Access'),
          ),
        ],
      ),
    );
  }
}
