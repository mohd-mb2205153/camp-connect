import 'package:campconnect/theme/constants.dart';
import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String selectedFilter;
  final List<String> options;
  final ValueChanged<String?> onSelected;
  final double height;

  const FilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.options,
    required this.onSelected,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.darkBlue, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Colors.white,
          value: selectedFilter,
          items: options
              .map((filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(
                      filter,
                      style: getTextStyle(
                        'small',
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onSelected,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}
