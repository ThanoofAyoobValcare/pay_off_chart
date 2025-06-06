
import 'package:pay_off_chart/package/base/axis_chart/axis_chart_data.dart';

extension FlSpotListExtension on List<FlSpot> {
  /// Splits a line by [FlSpot.nullSpot] values inside it.
  List<List<FlSpot>> splitByNullSpots() {
    final barList = <List<FlSpot>>[[]];

    // handle nullability by splitting off the list into multiple
    // separate lists when separated by nulls
    for (final spot in this) {
      if (spot.isNotNull()) {
        barList.last.add(spot);
      } else if (barList.last.isNotEmpty) {
        barList.add([]);
      }
    }
    // remove last item if one or more last spots were null
    if (barList.last.isEmpty) {
      barList.removeLast();
    }
    return barList;
  }
}
