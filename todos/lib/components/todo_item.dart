import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  final String title;
  final String description;
  final bool completed;
  final Function(bool?) onToggle;
  final Function() onDelete;

  const TodoItem({
    required this.title,
    required this.description,
    required this.completed,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool _completed = false;

  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _completed = widget.completed;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return SizedBox.shrink();
    }

    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.description),
      leading: Checkbox(
        value: _completed,
        onChanged: (val) {
          setState(() {
            _completed = val!;
          });
          widget.onToggle(val);
        },
      ),
      trailing: IconButton(
        onPressed: () {
          widget.onDelete();

          setState(() {
            _isDeleted = true;
          });
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}