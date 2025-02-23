/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:math' as math;

import 'package:xml/xml.dart';

import '../../pdf.dart';
import 'brush.dart';
import 'clip_path.dart';
import 'operation.dart';
import 'painter.dart';
import 'parser.dart';
import 'transform.dart';

class SvgPath extends SvgOperation {
  SvgPath(
    this.d,
    SvgBrush brush,
    SvgClipPath clip,
    SvgTransform transform,
    SvgPainter painter,
  ) : super(brush, clip, transform, painter);

  factory SvgPath.fromXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final d = element.getAttribute('d');
    if (d == null) {
      throw Exception('Path element must contain "d" attribute');
    }

    final brush = SvgBrush.fromXml(element, wbrush, painter);

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromRectXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final brush = SvgBrush.fromXml(element, wbrush, painter);

    final x =
        SvgParser.getNumeric(element, 'x', brush, defaultValue: 0)!.sizeValue;
    final y =
        SvgParser.getNumeric(element, 'y', brush, defaultValue: 0)!.sizeValue;
    final width =
        SvgParser.getNumeric(element, 'width', brush, defaultValue: 0)!
            .sizeValue;
    final height =
        SvgParser.getNumeric(element, 'height', brush, defaultValue: 0)!
            .sizeValue;
    var rx = SvgParser.getNumeric(element, 'rx', brush)?.sizeValue;
    var ry = SvgParser.getNumeric(element, 'ry', brush)?.sizeValue;

    ry ??= rx ?? 0;
    rx ??= ry;
    final topRight = rx != 0 || ry != 0 ? 'a $rx $ry 0 0 1 $rx $ry' : '';
    final bottomRight = rx != 0 || ry != 0 ? 'a $rx $ry 0 0 1 ${-rx} $ry' : '';
    final bottomLeft =
        rx != 0 || ry != 0 ? 'a $rx $ry 0 0 1 ${-rx} ${-ry}' : '';
    final topLeft = rx != 0 || ry != 0 ? 'a $rx $ry 0 0 1 $rx ${-ry}' : '';
    final d =
        'M${x + rx} ${y}h${width - rx * 2}${topRight}v${height - ry * 2}${bottomRight}h${-(width - rx * 2)}${bottomLeft}v${-(height - ry * 2)}${topLeft}z';

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromCircleXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final brush = SvgBrush.fromXml(element, wbrush, painter);

    final cx = SvgParser.getNumeric(element, 'cx', brush)!.sizeValue;
    final cy = SvgParser.getNumeric(element, 'cy', brush)!.sizeValue;
    final r = SvgParser.getNumeric(element, 'r', brush)!.sizeValue;
    final d =
        'M${cx - r},${cy}A$r,$r 0,0,0 ${cx + r},${cy}A$r,$r 0,0,0 ${cx - r},${cy}z';

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromEllipseXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final brush = SvgBrush.fromXml(element, wbrush, painter);

    final cx = SvgParser.getNumeric(element, 'cx', brush)!.sizeValue;
    final cy = SvgParser.getNumeric(element, 'cy', brush)!.sizeValue;
    final rx = SvgParser.getNumeric(element, 'rx', brush)!.sizeValue;
    final ry = SvgParser.getNumeric(element, 'ry', brush)!.sizeValue;
    final d =
        'M${cx - rx},${cy}A$rx,$ry 0,0,0 ${cx + rx},${cy}A$rx,$ry 0,0,0 ${cx - rx},${cy}z';

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromPolylineXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final points = element.getAttribute('points');
    final d = 'M$points';

    final brush = SvgBrush.fromXml(element, wbrush, painter);

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromPolygonXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final points = element.getAttribute('points');
    final d = 'M${points}z';
    final brush = SvgBrush.fromXml(element, wbrush, painter);

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  factory SvgPath.fromLineXml(
    XmlElement element,
    SvgPainter painter,
    SvgBrush wbrush,
  ) {
    final brush = SvgBrush.fromXml(element, wbrush, painter);

    final x1 = SvgParser.getNumeric(element, 'x1', brush)!.sizeValue;
    final y1 = SvgParser.getNumeric(element, 'y1', brush)!.sizeValue;
    final x2 = SvgParser.getNumeric(element, 'x2', brush)!.sizeValue;
    final y2 = SvgParser.getNumeric(element, 'y2', brush)!.sizeValue;
    final d = 'M$x1 $y1 $x2 $y2';

    return SvgPath(
      d,
      brush,
      SvgClipPath.fromXml(element, painter, brush),
      SvgTransform.fromXml(element),
      painter,
    );
  }

  final String d;

  @override
  void paintShape(PdfGraphics canvas) {
    if (brush.fill!.isNotEmpty) {
      brush.fill!.setFillColor(this, canvas);
      if (brush.fillOpacity! < 1) {
        canvas
          ..saveContext()
          ..setGraphicState(PdfGraphicState(opacity: brush.fillOpacity));
      }
      canvas
        ..drawShape(d)
        ..fillPath(evenOdd: brush.fillEvenOdd!);
      if (brush.fillOpacity! < 1) {
        canvas.restoreContext();
      }
    }

    if (brush.stroke!.isNotEmpty) {
      brush.stroke!.setStrokeColor(this, canvas);
      if (brush.strokeOpacity! < 1) {
        canvas.setGraphicState(PdfGraphicState(opacity: brush.strokeOpacity));
      }
      canvas
        ..drawShape(d)
        ..setLineCap(brush.strokeLineCap!)
        ..setLineJoin(brush.strokeLineJoin!)
        ..setMiterLimit(math.max(1.0, brush.strokeMiterLimit!))
        ..setLineDashPattern(
            brush.strokeDashArray!, brush.strokeDashOffset!.toInt())
        ..setLineWidth(brush.strokeWidth!.sizeValue)
        ..strokePath();
    }
  }

  @override
  void drawShape(PdfGraphics canvas) {
    canvas.drawShape(d);
  }

  @override
  PdfRect boundingBox() {
    return PdfGraphics.shapeBoundingBox(d);
  }
}
