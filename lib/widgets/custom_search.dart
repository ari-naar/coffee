import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomSearch extends StatefulWidget {
  final FocusNode searchFocusNode;

  const CustomSearch({super.key, required this.searchFocusNode});

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        focusNode: widget.searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(HugeIcons.strokeRoundedSearch01),
        ),
      ),
    );
  }
}
