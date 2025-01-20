import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/edit_screen_fields.dart';
import 'package:campconnect/widgets/special_text.dart';
import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String value;
  final bool special;
  final bool divider;
  final String? count;
  final TextInputType keyboardType;
  final double editWidth;

  const DetailsRow({
    super.key,
    required this.label,
    this.controller,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.special = false,
    this.divider = true,
    this.count,
    this.editWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: divider
            ? const Border(
                bottom: BorderSide(color: AppColors.darkBlue, width: 1),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        width: screenWidth(context) * 0.8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            controller != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: EditScreenTextField(
                      label: "~$value~",
                      controller: controller!,
                      type: keyboardType,
                      width: editWidth,
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: special
                        ? specialText(value)
                        : Text(
                            wrapText(value, 20),
                            style: getTextStyle('small',
                                color: AppColors.darkBlue),
                          ),
                  ),
            if (count != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  count!,
                  style: getTextStyle('smallBold', color: AppColors.darkBlue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
