import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class CafeCard extends StatelessWidget {
  const CafeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 175.w,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedCoffee01,
                    size: 32.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cafe Name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedStar,
                        size: 14.sp, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      '4.5',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 8.w),
                    Icon(HugeIcons.strokeRoundedLocation01,
                        size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      '1.2 km',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
