import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widgets/custom_filter_chip.dart';
import 'package:coffee_app/widgets/custom_chip_dropdown.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

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
    // 'Features': [
    //   ChipOption(label: 'WiFi', value: 'wifi'),
    //   ChipOption(label: 'Power Outlets', value: 'power'),
    //   ChipOption(label: 'Quiet Space', value: 'quiet'),
    //   ChipOption(label: 'Group Seating', value: 'group'),
    // ],
    'Open Now': [
      ChipOption(label: 'Open', value: true),
      ChipOption(label: 'Closed', value: false),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
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
        ],
      ),
    );
  }
}
