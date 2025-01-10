import 'package:coffee_app/widgets/custom_modal.dart';
import 'package:coffee_app/widgets/map_view.dart';
import 'package:coffee_app/models/cafe.dart';
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
  List<Cafe> _visibleCafes = [];

  void _handleCafeTap(Cafe cafe) {
    // Handle cafe tap if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Stack(
        children: [
          // Map layer
          Positioned.fill(
            child: MapView(
              onCafesLoaded: (cafes) {
                setState(() {
                  _visibleCafes = cafes;
                });
              },
            ),
          ),
          // Gesture detector for tap handling
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) {
                _modalKey.currentState?.shrinkModal();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Persistent bottom sheet
          CustomModal(
            key: _modalKey,
            initialShowBookmarks: isShowingBookmarks,
            visibleCafes: _visibleCafes,
            onCafeTap: _handleCafeTap,
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
