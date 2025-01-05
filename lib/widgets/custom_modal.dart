import 'package:coffee_app/screens/modals_screens/search_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomModal extends StatefulWidget {
  const CustomModal({super.key});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  DraggableScrollableController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _controller?.animateTo(
          0.1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 0.5,
        snap: true,
        snapSizes: const [0.1, 0.5],
        builder: (context, scrollController) {
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(36.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(36.r)),
                  child: Column(
                    children: [
                      SizedBox(height: 6.h),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          width: 35.w,
                          height: 5.h,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: SearchModal(
                            modalController: _controller,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
