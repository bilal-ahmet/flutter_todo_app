import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  // var olan görev eğer henüz tamamlanmadıysa üzerinde dğişiklik yapabilmek için yeni bir listTile oluşturrarak orada kullanacağız.
  final TextEditingController _taskNameController = TextEditingController();

  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();

    // aramdan geri gelince 1 kere çalıştığı güncellenmedi o yüzden builde taşıdık
    //_taskNameController.text = widget.task.isim;
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.isim;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
        ],
      ),
      child: ListTile(
        // leading'e tıklanıldığında görevi tamamladın demek için gesture detector kullanılıyor.
        leading: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1)),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          onTap: () async {
            widget.task.isCompleted = !widget.task.isCompleted;
            await _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
        ),

        title: widget.task.isCompleted
            ? Text(
                widget.task.isim,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                minLines: 1,
                maxLines: 10,

                // max line eklediğimiz zaman klavyede submit tuşu yerine new line tuşu aktif oldu, bu kod ile submit tuşu getirildi
                textInputAction: TextInputAction.done,

                // artı tuşuna basıldığı zaman direkt klavye ile başlanmasını sağlıyor
                //autofocus: true,
                controller: _taskNameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  widget.task.isim = value;
                  _localStorage.updateTask(task: widget.task);
                  setState(() {});
                },
              ),
        trailing: Text(
          DateFormat(
            "hh: mm a",
          ).format(widget.task.createdAt),
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
