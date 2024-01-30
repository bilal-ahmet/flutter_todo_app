import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

// @ anotasyonlarını kullanıyoruz ki build runner okuyabilsin.

@HiveType(typeId: 1)
class Task extends HiveObject{

  @HiveField(0)
  final String
      id; // her görevi birbirinden ayırt etmek için kullanılacak. hive veri tabanında kullanım sırasında.

  @HiveField(1)    
  String isim;

  @HiveField(2)
  final DateTime createdAt; // oluşturulan görevin ne zaman yapılacağı

  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.isim,
      required this.createdAt,
      required this.isCompleted});

  factory Task.create({required String isim, required DateTime createdAt}) {
    return Task(

        // Uuid().v1(): o anki zamanı Stringe dönüştürüp çıktı veriyor, 2 farklı görevi de bu şekilde ayırmış oluyoruz.
        id: const Uuid().v1(), isim: isim, createdAt: createdAt, isCompleted: false);
  }
}
