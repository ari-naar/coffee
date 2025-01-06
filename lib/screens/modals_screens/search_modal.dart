import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widgets/custom_chip_dropdown.dart';
import 'package:coffee_app/widgets/cafe_grid.dart';
import 'package:coffee_app/models/cafe.dart';

class SearchModal extends StatefulWidget {
  final DraggableScrollableController? modalController;
  final FocusNode searchFocusNode;
  final ScrollController? scrollController;
  final List<Cafe> visibleCafes;
  final Function(Cafe) onCafeTap;

  const SearchModal({
    super.key,
    this.modalController,
    required this.searchFocusNode,
    this.scrollController,
    required this.visibleCafes,
    required this.onCafeTap,
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  Map<String, List<ChipOption>> selectedChipOptions = {};
  bool isTrendingSelected = false;

  final Map<String, List<ChipOption>> cafeFilterOptions = {
    'Distance': [
      ChipOption(label: '< 1km', value: 'low'),
      ChipOption(label: '< 3km', value: 'medium'),
      ChipOption(label: '< 5km', value: 'high'),
      ChipOption(label: '< 10km', value: 'very high'),
    ],
    'Price': [
      ChipOption(label: '\$', value: 'low'),
      ChipOption(label: '\$\$', value: 'medium'),
      ChipOption(label: '\$\$\$', value: 'high'),
    ],
    'Average Rating': [
      ChipOption(label: '★★★★★', value: 'very high'),
      ChipOption(label: '★★★★', value: 'high'),
      ChipOption(label: '★★★', value: 'medium'),
      ChipOption(label: '★★', value: 'low'),
      ChipOption(label: '★', value: 'very low'),
    ],
    'Type': [
      ChipOption(label: 'Chain', value: 'chain'),
      ChipOption(label: 'Independent', value: 'independent'),
    ],
    'Open Now': [
      ChipOption(label: 'Open', value: true),
      ChipOption(label: 'Closed', value: false),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        // Fixed header with filters
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Trending toggle chip
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isTrendingSelected = !isTrendingSelected;
                            });
                          },
                          borderRadius: BorderRadius.circular(100.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: isTrendingSelected
                                  ? Colors.red[400]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                color: Colors.red[400]!,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 16.sp,
                                  color: isTrendingSelected
                                      ? Colors.white
                                      : Colors.red[400],
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Trending',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isTrendingSelected
                                        ? Colors.white
                                        : Colors.red[400],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Other filter chips
                      ...cafeFilterOptions.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: CustomChipDropdown(
                            title: '${entry.key}: ',
                            options: entry.value,
                            allowMultiSelect: entry.key == 'Features',
                            onOptionsChanged: (selected) {
                              setState(() {
                                selectedChipOptions[entry.key] = selected;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
        // Scrollable grid section
        SliverFillRemaining(
          hasScrollBody: true,
          fillOverscroll: true,
          child: CafeGrid(
            cafes: widget.visibleCafes,
            onCafeTap: widget.onCafeTap,
          ),
        ),
      ],
    );
  }
}
