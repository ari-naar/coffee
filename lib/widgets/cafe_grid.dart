import 'package:coffee_app/widgets/cafe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/cafe.dart';

class CafeGrid extends StatelessWidget {
  final List<Cafe> cafes;
  final Function(Cafe) onCafeTap;

  const CafeGrid({
    super.key,
    required this.cafes,
    required this.onCafeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.88,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: cafes.length,
      itemBuilder: (context, index) {
        final cafe = cafes[index];
        return CafeCard(
          cafe: cafe,
          onTap: () => onCafeTap(cafe),
        );
      },
    );
  }
}
