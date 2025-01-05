import 'package:coffee_app/screens/modals_screens/search_modal.dart';
import 'package:coffee_app/screens/modals_screens/bookmarks_modal.dart';
import 'package:coffee_app/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomModal extends StatefulWidget {
  final bool initialShowBookmarks;

  const CustomModal({
    super.key,
    this.initialShowBookmarks = false,
  });

  @override
  State<CustomModal> createState() => CustomModalState();
}

class CustomModalState extends State<CustomModal> {
  DraggableScrollableController? _controller;
  final FocusNode _searchFocusNode = FocusNode();
  bool _showBookmarks = false;
  double _currentSize = 0.1;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller?.addListener(_onSheetPositionChanged);
    _showBookmarks = widget.initialShowBookmarks;
    _searchFocusNode.addListener(_onFocusChange);

    if (_showBookmarks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller?.jumpTo(0.5);
      });
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
  void didUpdateWidget(CustomModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialShowBookmarks != oldWidget.initialShowBookmarks) {
      setState(() {
        _showBookmarks = widget.initialShowBookmarks;
      });
      if (_showBookmarks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller?.animateTo(
            0.5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    }
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
    if (_searchFocusNode.hasFocus && !_showBookmarks) {
      expandModal();
    }
  }

  void expandModal() {
    _controller?.animateTo(
      0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void shrinkModal() {
    _controller?.animateTo(
      0.1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showSearchContent = !_showBookmarks && _currentSize > 0.15;
    final double contentOpacity = showSearchContent ? 1.0 : 0.0;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.1, 0.5, 0.9],
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              shrinkModal();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
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
                    if (!_showBookmarks)
                      CustomSearch(searchFocusNode: _searchFocusNode),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showBookmarks
                            ? BookmarksModal(
                                modalController: _controller,
                                scrollController: scrollController,
                              )
                            : AnimatedOpacity(
                                opacity: contentOpacity,
                                duration: const Duration(milliseconds: 200),
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
    );
  }
}
