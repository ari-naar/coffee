import 'package:coffee_app/widgets/cafe_card.dart';
import 'package:coffee_app/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widgets/custom_filter_chip.dart';
import 'package:coffee_app/widgets/custom_chip_dropdown.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchModal extends StatefulWidget {
  final DraggableScrollableController? modalController;
  final FocusNode searchFocusNode;

  const SearchModal({
    super.key,
    this.modalController,
    required this.searchFocusNode,
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
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
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount:
                    10, // This will be replaced with actual cafe data count
                itemBuilder: (context, index) {
                  return const CafeCard();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
