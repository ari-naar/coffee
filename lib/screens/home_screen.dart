import 'package:coffee_app/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShowingBookmarks = false;
  final _modalKey = GlobalKey<CustomModalState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Stack(
        children: [
          // Centered "map" text with tap handler
          GestureDetector(
            onTap: () {
              _modalKey.currentState?.shrinkModal();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Text(
                  'map',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Persistent bottom sheet
          CustomModal(
            key: _modalKey,
            initialShowBookmarks: isShowingBookmarks,
          ),
          // Heart icon button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  isShowingBookmarks ? Icons.favorite : Icons.favorite_border,
                  size: 20.sp,
                  color:
                      isShowingBookmarks ? Colors.red[400] : Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    isShowingBookmarks = !isShowingBookmarks;
                  });
                  // Expand modal when showing bookmarks
                  if (isShowingBookmarks) {
                    _modalKey.currentState?.expandModal();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
