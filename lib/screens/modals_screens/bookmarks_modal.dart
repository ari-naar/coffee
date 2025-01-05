import 'package:coffee_app/widgets/cafe_grid.dart';
import 'package:coffee_app/widgets/custom_chip_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarksModal extends StatefulWidget {
  final DraggableScrollableController? modalController;
  final ScrollController? scrollController;

  const BookmarksModal({
    super.key,
    this.modalController,
    this.scrollController,
  });

  @override
  State<BookmarksModal> createState() => _BookmarksModalState();
}

class _BookmarksModalState extends State<BookmarksModal> {
  Map<String, List<ChipOption>> selectedChipOptions = {};

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
        // Header
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
        // Grid of bookmarked cafes
        SliverFillRemaining(
          hasScrollBody: true,
          fillOverscroll: true,
          child: CafeGrid(),
        ),
      ],
    );
  }
}
