import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/cafe.dart';

class CafeCard extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const CafeCard({
    super.key,
    required this.cafe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    child: Center(
                      child: Icon(
                        Icons.coffee,
                        size: 32.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
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
                      child: Icon(
                        Icons.favorite_border,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cafe.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color:
                              cafe.isOpen ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          cafe.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: cafe.isOpen
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (cafe.address != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      cafe.address!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      if (cafe.rating != null) ...[
                        Icon(Icons.star_rate_rounded,
                            size: 14.sp, color: Colors.amber),
                        SizedBox(width: 2.w),
                        Text(
                          cafe.rating!.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Text(
                        '${(cafe.distance / 1000).toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
