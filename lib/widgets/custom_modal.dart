import 'package:coffee_app/screens/modals_screens/search_modal.dart';
import 'package:coffee_app/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomModal extends StatefulWidget {
  const CustomModal({super.key});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  DraggableScrollableController? _controller;
  double _currentSize = 0.1;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller?.addListener(_onSheetPositionChanged);
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onSheetPositionChanged);
    _controller?.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _controller?.animateTo(
        0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSheetPositionChanged() {
    if (_controller != null) {
      setState(() {
        _currentSize = _controller!.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentOpacity = ((_currentSize - 0.1) / (0.5 - 0.1)).clamp(0.0, 1.0);

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
                      CustomSearch(searchFocusNode: _searchFocusNode),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: contentOpacity,
                          duration: const Duration(milliseconds: 100),
                          child: IgnorePointer(
                            ignoring: contentOpacity < 0.1,
                            child: SearchModal(
                              modalController: _controller,
                              searchFocusNode: _searchFocusNode,
                              scrollController: scrollController,
                            ),
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
