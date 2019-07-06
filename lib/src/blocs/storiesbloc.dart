import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc{
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>(); 

  //getters to get streams
  Observable <List<int>> get topIds=> _topIds.stream;

  Observable <Map<int,Future<ItemModel>>> get items =>_itemsOutput.stream;
// get items => _items.stream.transform(_itemsTransformer());

  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc(){
    // items= _items.stream.transform(_itemsTransformer());
    _itemFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async{
    final ids= await _repository.fetchTopIds();
    _topIds.sink.add(ids);

  }
  clearCache(){
    _repository.clearCache();
  }
  _itemsTransformer(){
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache,int id, index){
        print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;       
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose(){
    _topIds.close();
    _itemsOutput.close();
    _itemFetcher.close();
}
}
