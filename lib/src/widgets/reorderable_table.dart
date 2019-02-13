//import 'dart:math' as math;
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

import './tabluar_flex.dart';
import './reorderable_flex.dart';
import '../rendering/tabluar_flex.dart';

class ReorderableTableRow extends TabluarRow {
  ReorderableTableRow({
    Key key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline textBaseline,
    List<Widget> children = const <Widget>[],
    Decoration decoration,
  }) : super(
        children: children,
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        decoration: decoration,
  );
}

typedef DecorateDraggableFeedback = Widget Function(BuildContext feedbackContext, Widget draggableFeedback);

class ReorderableTable extends StatelessWidget {
  /// Creates a table.
  ///
  /// The [children], [defaultColumnWidth], and [defaultVerticalAlignment]
  /// arguments must not be null.
  ReorderableTable({
    Key key,
    this.children = const <ReorderableTableRow>[],
    this.columnWidths,
    this.defaultColumnWidth = const FlexColumnWidth(1.0),
    this.textDirection,
    this.border,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.top,
    this.textBaseline,

    this.header,
    this.footer,
    this.onReorder,
    this.decorateDraggableFeedback,
  }) : assert(children != null),
      assert(defaultColumnWidth != null),
      assert(defaultVerticalAlignment != null),
      assert(() {
        if (children.any((ReorderableTableRow row) => row.children.any((Widget cell) => cell == null))) {
          throw FlutterError(
            'One of the children of one of the rows of the table was null.\n'
              'The children of a ReorderableTableRow must not be null.'
          );
        }
        return true;
      }()),
      assert(() {
        if (children.any((ReorderableTableRow row1) => row1.key != null && children.any((ReorderableTableRow row2) => row1 != row2 && row1.key == row2.key))) {
          throw FlutterError(
            'Two or more ReorderableTableRow children of this Table had the same key.\n'
              'All the keyed ReorderableTableRow children of a Table must have different Keys.'
          );
        }
        return true;
      }()),
//      assert(() {
//        if (children.isNotEmpty) {
//          final int cellCount = children.first.children.length;
//          if (children.any((ReorderableTableRow row) => row.children.length != cellCount)) {
//            throw FlutterError(
//              'Table contains irregular row lengths.\n'
//                'Every ReorderableTableRow in a Table must have the same number of children, so that every cell is filled. '
//                'Otherwise, the table will contain holes.'
//            );
//          }
//        }
//        return true;
//      }()),

      super(key: key) {
    assert(() {
      final List<Widget> flatChildren = children.expand<Widget>((ReorderableTableRow row) => row.children).toList(growable: false);
      if (debugChildrenHaveDuplicateKeys(this, flatChildren)) {
        throw FlutterError(
          'Two or more cells in this Table contain widgets with the same key.\n'
            'Every widget child of every TableRow in a Table must have different keys. The cells of a Table are '
            'flattened out for processing, so separate cells cannot have duplicate keys even if they are in '
            'different rows.'
        );
      }
      return true;
    }());
  }

  /// The rows of the table.
  ///
  /// Every row in a table must have the same number of children, and all the
  /// children must be non-null.
  final List<ReorderableTableRow> children;

  /// How the horizontal extents of the columns of this table should be determined.
  ///
  /// If the [Map] has a null entry for a given column, the table uses the
  /// [defaultColumnWidth] instead. By default, that uses flex sizing to
  /// distribute free space equally among the columns.
  ///
  /// The [FixedColumnWidth] class can be used to specify a specific width in
  /// pixels. That is the cheapest way to size a table's columns.
  ///
  /// The layout performance of the table depends critically on which column
  /// sizing algorithms are used here. In particular, [IntrinsicColumnWidth] is
  /// quite expensive because it needs to measure each cell in the column to
  /// determine the intrinsic size of the column.
  final Map<int, TableColumnWidth> columnWidths;

  /// How to determine with widths of columns that don't have an explicit sizing algorithm.
  ///
  /// Specifically, the [defaultColumnWidth] is used for column `i` if
  /// `columnWidths[i]` is null.
  final TableColumnWidth defaultColumnWidth;

  /// The direction in which the columns are ordered.
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection textDirection;

  /// The style to use when painting the boundary and interior divisions of the table.
  final TableBorder border;

  /// How cells that do not explicitly specify a vertical alignment are aligned vertically.
  final TableCellVerticalAlignment defaultVerticalAlignment;

  /// The text baseline to use when aligning rows using [TableCellVerticalAlignment.baseline].
  final TextBaseline textBaseline;

  final Widget header;
  final Widget footer;
  final ReorderCallback onReorder;
  final DecorateDraggableFeedback decorateDraggableFeedback;

  @override
  Widget build(BuildContext context) {
//    return TabluarColumn(
//      mainAxisSize: MainAxisSize.min,
//      children: itemRows +
//        [
//          ReorderableTableRow(key: ValueKey<int>(1), mainAxisSize:MainAxisSize.min, children: <Widget>[Text('111111111111'), Text('222')]),
//          ReorderableTableRow(key: ValueKey<int>(2), mainAxisSize:MainAxisSize.min, children: <Widget>[Text('33'), Text('4444444444')])
//        ],
//    )
    final GlobalKey tableKey = GlobalKey(debugLabel: '$ReorderableTable table key');

    return ReorderableFlex(
      header: header,
      footer: footer,
      children: children,
      onReorder: onReorder,
      direction: Axis.vertical,
      buildItemsContainer: (BuildContext containerContext, Axis direction, List<Widget> children) {
//        List<ReorderableTableRow> wrappedChildren = children.map((Widget child) {
//          return ReorderableTableRow(children: <Widget>[],);
//        }).toList();
        //get keys in this.children
//        this.children[0].
        return TabluarFlex(
          key: tableKey,
          direction: direction,
//          mainAxisAlignment: mainAxisAlignment,
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
//          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: children
        );
      },
      buildDraggableFeedback: (BuildContext feedbackContext, BoxConstraints constraints, Widget child) {
        // The child is a ReorderableTableRow because children is a List<ReorderableTableRow>
        ReorderableTableRow tableRow = child;
//        debugPrint('buildDraggableFeedback: ${tableKey.currentContext.findRenderObject()}');
        RenderTabluarFlex renderTabluarFlex = tableKey.currentContext.findRenderObject();
        for (int i=0; i<tableRow.children.length; i++) {
          tableRow.children[i] = ConstrainedBox(
            constraints: BoxConstraints(minWidth: renderTabluarFlex.maxGrandchildrenCrossSize[i]),
            child: tableRow.children[i]
          );
        }

        ConstrainedBox constrainedTableRow = ConstrainedBox(constraints: constraints, child: tableRow);

        return Transform(
          transform: new Matrix4.rotationZ(0),
          alignment: FractionalOffset.topLeft,
          child: Material(
//            child: Card(child: ConstrainedBox(constraints: constraints, child: tableRow)),
            child: (decorateDraggableFeedback ?? defaultDecorateDraggableFeedback)(feedbackContext, constrainedTableRow),
            elevation: 6.0,
            color: Colors.transparent,
            borderRadius: BorderRadius.zero,
          ),
        );
      }
    );
  }

  Widget defaultDecorateDraggableFeedback(BuildContext feedbackContext, Widget draggableFeedback) => Card(child: draggableFeedback);
}