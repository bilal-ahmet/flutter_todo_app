// depolama için lokal depolama sağlayan Hive kullancağız. ancak daha sonra bir depolama yöntemi değiştirme ihtimaline karşı yapıyı 
// başka sınıftaki nesneler etkilenmeden oluşturacağız. bunun için de Abstrack sınıflardan yararlanmamız mantıklı oluyor.
// Abstarck sınıflarda metodlar tanımlanabilir ancak içleri doldurulmaya bilir.

import 'package:flutter_todo_app/model/task_model.dart';

abstract class LocalStorage {

  Future<void> addTask({required Task task});
  Future<Task> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}


class HiveLocalStorage extends LocalStorage{
  @override
  Future<void> addTask({required Task task}) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTask({required Task task}) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getAllTask() {
    // TODO: implement getAllTask
    throw UnimplementedError();
  }

  @override
  Future<Task> getTask({required String id}) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<Task> updateTask({required Task task}) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

}