import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/storiesprovider.dart';
import 'screens/news_detail.dart';
import 'blocs/commentsprovider.dart';

class App extends StatelessWidget {
  Widget build(context) {

    return CommentsProvider(child:StoriesProvider(
      child: MaterialApp(
        title: 'NEWS !',
        // home:NewsList(),
        //  Navigation begins

        onGenerateRoute: (RouteSettings settings) {
         
        },
      ),
    ) ,);
  }
  // Widget buildList(){
  //   return ListView.builder(
  //       itemCount: 1000,
  //       itemBuilder:(context , int index){
  //         return FutureBuilder(
  //           future:getFuture(),
  //           builder:(context,snapshot){
  //             return Container(
  //               height: 80.0,
  //               child: snapshot.hasData
  //             ?Text('Im visible $index')
  //             : Text('I havent fetched data yet $index'),
  //             );
  //           },
  //         );
  //     } ,
  //   );
  // }
  // getFuture()
  // {
  //   return Future.delayed(
  //     Duration(seconds:2),
  //     ()=> 'hi',
  //   );
  // }
  Route routes(RouteSettings settings){
    if(settings.name == '/')
    {
    return MaterialPageRoute(
      builder: (context){
        final storiesBloc= StoriesProvider.of(context);
        storiesBloc.fetchTopIds();
        return NewsList();
      },
    );
    }
    else {
      return MaterialPageRoute(
        builder: (context){
          //extract the id from settings.name and send to newsdetail
          //for data fetching
          final itemId= int.parse(settings.name.replaceFirst('/', ''));
          final commentsBloc = CommentsProvider.of(context);
          commentsBloc.fetchItemWithComments(itemId);
          return NewsDetail(
            itemId:itemId,
          );
        },
      );
    }
  }
}
