
import 'package:pay_off_chart/package/base/axis_chart/axis_chart_data.dart';

extension SideTitlesExtension on AxisTitles {
  double get totalReservedSize {
    var size = 0.0;
    if (showAxisTitles) {
      size += axisNameSize;
    }
    if (showSideTitles) {
      size += sideTitles.reservedSize;
    }
    return size;
  }
}
