// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

// class _SfThumbShape extends SfThumbShape {
//   @override
//   void paint(PaintingContext context, Offset center,
//       {required RenderBox parentBox,
//       required RenderBox? child,
//       required SfSliderThemeData themeData,
//       SfRangeValues? currentValues,
//       dynamic currentValue,
//       required Paint? paint,
//       required Animation<double> enableAnimation,
//       required TextDirection textDirection,
//       required SfThumb? thumb}) {
//       final Path path = Path();

//       path.moveTo(center.dx, center.dy);
//       path.lineTo(center.dx + 10, center.dy - 15);
//       path.lineTo(center.dx - 10, center.dy - 15);
//       path.close();
//       context.canvas.drawPath(
//           path,
//           Paint()
//             ..color = themeData.activeTrackColor!
//             ..style = PaintingStyle.fill
//             ..strokeWidth = 2);
//   }
// }