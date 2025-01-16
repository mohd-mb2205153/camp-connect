import 'package:campconnect/theme/styling_constants.dart';
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

  const DetailsRow({
    super.key,
    required this.label,
    this.controller,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.special = false,
    this.divider = true,
    this.count,
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
        width: MediaQuery.of(context).size.width * .8,
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
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: special
                        ? specialText(value)
                        : Text(
                            value,
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
