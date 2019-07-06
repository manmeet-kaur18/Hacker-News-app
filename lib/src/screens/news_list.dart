import 'package:flutter/material.dart';
import 'package:newsapi/src/blocs/storiesbloc.dart';
import '../blocs/storiesprovider.dart';
import '../widgets/new_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    
    // //this is bad
    // bloc.fetchTopIds();


    return Scaffold(
      appBar: AppBar(
        title: Text('Top news'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            // return Text('Still waiting on ids');
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Refresh(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                // return Text('${snapshot.data[index]}');
                return NewsListTile(
                  itemId: snapshot.data[index],
                );
              },
            ),
          );
        }
      );
  }
}
