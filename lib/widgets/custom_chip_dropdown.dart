import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class ChipOption {
  final String label;
  final dynamic value;
  bool isSelected;

  ChipOption({
    required this.label,
    required this.value,
    this.isSelected = false,
  });
}

class CustomChipDropdown extends StatefulWidget {
  final String title;
  final List<ChipOption> options;
  final bool allowMultiSelect;
  final Function(List<ChipOption>) onOptionsChanged;
  final EdgeInsetsGeometry? chipPadding;
  final EdgeInsetsGeometry? dropdownItemPadding;
  final double? dropdownWidth;

  const CustomChipDropdown({
    super.key,
    required this.title,
    required this.options,
    required this.onOptionsChanged,
    this.allowMultiSelect = false,
    this.chipPadding,
    this.dropdownItemPadding,
    this.dropdownWidth,
  });

  @override
  State<CustomChipDropdown> createState() => _CustomChipDropdownState();
}

class _CustomChipDropdownState extends State<CustomChipDropdown> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  String get _selectedText {
    final selected = widget.options.where((opt) => opt.isSelected).toList();
    if (selected.isEmpty) return '';
    if (selected.length == 1) return selected.first.label;
    return '${selected.length} selected';
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _showOptions() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            width: widget.dropdownWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 5.h),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12.r),
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    constraints: BoxConstraints(
                      minWidth: size.width,
                      maxWidth: widget.dropdownWidth ?? 300.w,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.allowMultiSelect &&
                            widget.options.any((opt) => opt.isSelected)) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (var opt in widget.options) {
                                  opt.isSelected = false;
                                }
                              });
                              widget.onOptionsChanged([]);
                            },
                            child: Container(
                              padding: widget.dropdownItemPadding ??
                                  EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.clear_all,
                                    size: 20.r,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Clear All',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(height: 1),
                        ],
                        ...widget.options.map((option) {
                          final bool isSelected = option.isSelected;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.allowMultiSelect) {
                                  option.isSelected = !option.isSelected;
                                } else {
                                  for (var opt in widget.options) {
                                    opt.isSelected =
                                        opt == option ? !opt.isSelected : false;
                                  }
                                  _removeOverlay();
                                }
                              });
                              widget.onOptionsChanged(
                                widget.options
                                    .where((opt) => opt.isSelected)
                                    .toList(),
                              );
                            },
                            child: Container(
                              padding: widget.dropdownItemPadding ??
                                  EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.allowMultiSelect)
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Icon(
                                        option.isSelected
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 20.r,
                                        color: option.isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: TextStyle(
                                        color: option.isSelected
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                      ),
                                    ),
                                  ),
                                  if (!widget.allowMultiSelect &&
                                      option.isSelected)
                                    Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                      size: 18.r,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IntrinsicWidth(
        child: GestureDetector(
          onTap: () {
            if (_overlayEntry != null) {
              _removeOverlay();
            } else {
              _showOptions();
            }
          },
          child: Container(
            padding: widget.chipPadding ??
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              color: Colors.grey.shade300,
              border: _selectedText.isNotEmpty
                  ? Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _selectedText.isNotEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
                if (_selectedText.isNotEmpty) ...[
                  Text(
                    _selectedText,
                    style: TextStyle(
                      color: _selectedText.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ],
                SizedBox(width: 4.w),
                HugeIcon(
                  icon: _isOpen
                      ? HugeIcons.strokeRoundedArrowUp01
                      : HugeIcons.strokeRoundedArrowDown01,
                  size: 18.r,
                  color: _selectedText.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
