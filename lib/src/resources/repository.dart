import 'dart:async';
import 'newsapiprovider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

//may not work for long term , can use it still
class Repository {
  List<Source> sources = <Source>[
    NewsApiProvider(),
    newsDbProvider,
  ];
  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];
  
//iterate over sources when dbprovider
//get fetchTopIds implemented
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }
    for(var cache in caches)
    {
      if(cache!=(source as Cache))
      {
      cache.addItem(item);
      }  
    }
    return item;
    // var item =await dbProvider.fetchItem(id);
    // if(item!=null)
    // {
    //   return item;
    // }
    // item = await apiProvider.fetchItem(id);
    // await dbProvider.addItem(item);
    // return item;
  }
  clearCache() async{
    for (var cache in  caches)
    {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}