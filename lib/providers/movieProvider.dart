import 'package:filmster/Widgets/UI/CustomSnackBar.dart';
import 'package:filmster/model/BasicResponse.dart';
import 'package:filmster/model/search.dart';
import 'package:filmster/setting/api.dart';
import 'package:flutter/cupertino.dart';

class MovieProvider extends ChangeNotifier{

  List<SearchResults> similarList=[];
  List<SearchResults> recommendedList=[];

  getSimilarMovie(id, keyState) async{
    similarList.clear();
    var response = await Api().getSimilarMovie(id);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
    }else{
      response.results.forEach((SearchResults element)=>
          similarList.add(element));
    }
    notifyListeners();
  }

  getSimilarTv(id, keyState) async{
    similarList.clear();
    var response = await Api().getSimilarTv(id);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
    }else{
      response.results.forEach((SearchResults element)=>
          similarList.add(element));
    }
    notifyListeners();
  }


  getRecommendedMovie(id, keyState) async{
    recommendedList.clear();
    var response = await Api().getRecommendedMovie(id);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
    }else{
      response.results.forEach((SearchResults element)=>
          recommendedList.add(element));
    }
    notifyListeners();
  }

  getRecommendedTv(id, keyState) async{
    recommendedList.clear();
    var response = await Api().getRecommendedTv(id);
    if(hasError(response)){
      CustomSnackBar().showSnackBar(title: response.massage, state: keyState);
    }else{
      response.results.forEach((SearchResults element)=>
          recommendedList.add(element));
    }
    notifyListeners();
  }

  bool hasError(response) {
    return response.runtimeType == BasicResponse();
  }
}