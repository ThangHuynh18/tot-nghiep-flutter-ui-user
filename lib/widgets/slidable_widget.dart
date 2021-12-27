import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    required this.child,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    child: child,



    /// right side
    secondaryActions: <Widget>[

      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => onDismissed(SlidableAction.delete),
      ),
    ],
  );
}



enum SlidableVoucherAction { add }

class SlidableVoucherWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableVoucherAction action) onDismissed;

  const SlidableVoucherWidget({
    required this.child,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    child: child,



    /// right side
    secondaryActions: <Widget>[

      IconSlideAction(
        caption: 'Add',
        color: Colors.orange,
        icon: Icons.add_circle,
        onTap: () => onDismissed(SlidableVoucherAction.add),
      ),
    ],
  );
}