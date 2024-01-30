import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/widgets/custom_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _allTasks = <Task>[];
    getAllTaskFromDB();

    // main klasöründe get_it paketini LOcalStorage üzerinden yaptıpımız için başka zaman storage yöntemi değiştiğinde sadece main'de
    // bulunan kısmı değiştireceğiz.
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                _showAddTaskBootmSheet(context);
              },
              child: const Text(
                "title",
                style: TextStyle(color: Colors.black),
              ).tr() ),
          centerTitle:
              false, // ios'ta başlıklar ortadan başlar onu engellemek için kullanılıyor
          actions: [
            IconButton(
                onPressed: () {
                  _showSearchPage();
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showAddTaskBootmSheet(context);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemCount: _allTasks.length,
                itemBuilder: (context, index) {
                  var _oankiListeEleman = _allTasks[index];
                  

                  // kaydırarak ListTile'dan çıkartma işlemi için kullanılıyor.
                  return Dismissible(

                      // key değerinin uniq olması gerekiyor o yüzden Uuid ile oluşturduğumuz değeri buraya atabiliriz.
                      key: Key(_oankiListeEleman.id),
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("remove_task").tr()
                        ],
                      ),
                      onDismissed: (direction) {
                        _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: _oankiListeEleman);
                        setState(() {});
                      },
                      child: TaskItem(task: _oankiListeEleman));
                },
              )
            : Center(
                child: Text("empty_task_list").tr(),
              ));
  }

  void _showAddTaskBootmSheet(BuildContext context) {
    // alttan açılan bir pencere sağlıyor.
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,

          // TextField kullanıldığı zaman klavye onun üzerine gelerek kapatıyor, bu kod ile engellenebilmektedir.
          padding: MediaQuery.of(context).viewInsets,
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "add_task".tr(),

                  // ListTile ile gelen alt çizgiyi kaldırmak için kullanılıyor.
                  border: InputBorder.none),

              // text field'a yazı yazıldıktan sonra okey işaretine basılması onSubmitted ile tutuluyor. bu işlemden sonra ekranı kapattık
              onSubmitted: (value) {
                Navigator.pop(context);

                DatePicker.showTimePicker(
                  context,
                  showSecondsColumn: false,
                  onConfirm: (time) async {
                    var yeniEklenecekGorev =
                        Task.create(isim: value, createdAt: time);
                    _allTasks.insert(0, yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void getAllTaskFromDB()async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }

  void _showSearchPage() {
    showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));

        getAllTaskFromDB();
  }
}
