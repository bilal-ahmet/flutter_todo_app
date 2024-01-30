// depolama için lokal depolama sağlayan Hive kullancağız. ancak daha sonra bir depolama yöntemi değiştirme ihtimaline karşı yapıyı 
// başka sınıftaki nesneler etkilenmeden oluşturacağız. bunun için de Abstrack sınıflardan yararlanmamız mantıklı oluyor.
// Abstarck sınıflarda metodlar tanımlanabilir ancak içleri doldurulmaya bilir.

import 'package:flutter_todo_app/model/task_model.dart';
import 'package:hive/hive.dart';

abstract class LocalStorage {

  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}


class HiveLocalStorage extends LocalStorage{

  late Box<Task> _taskBox;

  HiveLocalStorage(){
    _taskBox = Hive.box<Task>("tasks");
  }

  @override
  Future<void> addTask({required Task task}) async{
  await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {

    // direkt task.delete() diyebilmemizin sebebi, task_model sınıfında Task sınıfına HiveObjects'i extends ettiğimiz için.
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async{
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if(_allTask.isNotEmpty){
      _allTask.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async{
    
    if(_taskBox.containsKey(id)){
      return _taskBox.get(id);
    }
    else{
      null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async{
    await task.save();
    return task;
  }

}