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
          return _buildShootingList(context, snapshot.data.documents);
        } else {
          return _buildLayupList(context, snapshot.data.documents);
        }
      },
    );
  }

  ListView _buildShootingList(BuildContext context, List<DocumentSnapshot> docs) {
    List<Widget> list = List();

    List<String> exercises = List.from(docs[0]['shooting']);

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

  ListView _buildLayupList(BuildContext context, List<DocumentSnapshot> docs) {
    List<Widget> list = List();

    List<String> exercises = List.from(docs[0]['layups']);

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
          title: Text("Select an exercise"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Shooting",
                icon: Icon(Icons.directions_run),
              ),
              Tab(
                icon: Icon(Icons.switch_camera),
              )
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
