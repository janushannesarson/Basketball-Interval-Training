import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogScreen extends StatelessWidget {
  Widget _buildBody(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('exercises').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        if(index == 0){
          return _buildList(context, snapshot.data.documents, 'dribbling');
        } else {
          return _buildList(context, snapshot.data.documents, 'shooting');
        }
      },
    );
  }

  ListView _buildList(BuildContext context, List<DocumentSnapshot> docs, String fbArray) {
    List<Widget> list = List();

    List<String> exercises = List.from(docs[0][fbArray]);

    for (final exercise in exercises) {
      list.add(Card(
          child: ListTile(
            title: Text(exercise),
            onTap: () => {
              Navigator.pop(context, exercise)
            },
          )));
    }

    return ListView(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Select an exercise"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Dribbling",
                icon: Icon(Icons.beach_access),
              ),
              Tab(
                text: "Shooting",
                icon: Icon(Icons.thumbs_up_down),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[_buildBody(context, 0), _buildBody(context, 1)],
        ),
      ),
    );
  }
}
