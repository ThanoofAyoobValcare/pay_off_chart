
import 'package:flutter/widgets.dart';
import 'package:pay_off_chart/package/base/axis_chart/axis_chart_data.dart';
import 'package:pay_off_chart/package/extensions/side_titles_extension.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
        left: show ? leftTitles.totalReservedSize : 0.0,
        top: show ? topTitles.totalReservedSize : 0.0,
        right: show ? rightTitles.totalReservedSize : 0.0,
        bottom: show ? bottomTitles.totalReservedSize : 0.0,
      );
}
