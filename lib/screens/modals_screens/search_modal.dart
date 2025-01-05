import 'package:coffee_app/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widgets/custom_filter_chip.dart';
import 'package:coffee_app/widgets/custom_chip_dropdown.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchModal extends StatefulWidget {
  final DraggableScrollableController? modalController;

  const SearchModal({
    super.key,
    this.modalController,
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  Map<String, List<ChipOption>> selectedChipOptions = {};
  final FocusNode _searchFocusNode = FocusNode();
  bool _isExpanded = false;

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
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus && !_isExpanded) {
      _isExpanded = true;
      widget.modalController?.animateTo(
        0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearch(searchFocusNode: _searchFocusNode),
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
      ),
    );
  }
}
