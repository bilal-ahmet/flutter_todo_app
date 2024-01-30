import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

import '../model/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {

  late final List<Task> allTasks;

  CustomSearchDelegate({
    required this.allTasks,
  });



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24));
  }

  // arama çubuğuna bir şey yazıp submit tuşuna basınca oluşacak şeyler için kullanılır
  @override
  Widget buildResults(BuildContext context) {
    var filtredList = allTasks.where((element) => element.isim.toLowerCase().contains(query.toLowerCase())).toList();
    return filtredList.length > 0 ? ListView.builder(
                itemCount: filtredList.length,
                itemBuilder: (context, index) {
                  var _oankiListeEleman = filtredList[index];

                  // kaydırarak ListTile'dan çıkartma işlemi için kullanılıyor.
                  return Dismissible(

                      // key değerinin uniq olması gerekiyor o yüzden Uuid ile oluşturduğumuz değeri buraya atabiliriz.
                      key: Key(_oankiListeEleman.id),
                      background: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("bu görev silindi")
                        ],
                      ),
                      onDismissed: (direction) async{
                        filtredList.removeAt(index);
                        await locator<LocalStorage>().deleteTask(task: _oankiListeEleman);
                      },
                      child: TaskItem(task: _oankiListeEleman));
                },
              ) : Center(child: Text("aradğınızı bulamadık"),);
  }

  // arama çubuğuna bir şey yazılırken gösterilecek şeyler için kullanılır
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
