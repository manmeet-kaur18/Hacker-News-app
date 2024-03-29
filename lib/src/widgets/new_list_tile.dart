import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/storiesprovider.dart';
import 'dart:async';
import '../widgets/loading_container.dart';

class NewsListTile extends StatelessWidget{

  final int itemId;
  NewsListTile({this.itemId});
  Widget build(context){
    final bloc= StoriesProvider.of(context);

    return StreamBuilder(
      stream:bloc.items,
      builder:(context,AsyncSnapshot<Map<int,Future<ItemModel>>>snapshot){
        if(!snapshot.hasData)
        {
          return  LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder:(context,AsyncSnapshot <ItemModel> itemsnapshot){
            if(!itemsnapshot.hasData)
            {
              return LoadingContainer();
            }
            return buildTile(context,itemsnapshot.data);

          }
        );
      }
    );
  }

  Widget buildTile(BuildContext context,ItemModel item)
  {
    return Column(
      children:[
        ListTile(
      title:Text(item.title),
      subtitle: Text('${item.score} votes'),
      trailing:Column(
        children:[
          Icon(Icons.comment),
          Text('${item.descendants}'),
      ],
      ) ,
      onTap:(){ Navigator.pushNamed(context, '/${item.id}');},
    ),
    Divider(
      height:8.0,
    ),
      ],
    );

  }
}