import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

http.Response res;
http.Response searchRes;
int NumImages = 30;
int pageNum = 1;
String old;
int SearchNumImages = 30;
int SearchpageNum = 1;

String APIkey = '563492ad6f9170000100000161bb480c51fa411ab725f56452f31bb6';
// ignore: deprecated_member_use
List<String> jsonList = new List<String>();
// ignore: deprecated_member_use
List<String> searchList = new List<String>();
Future<dynamic> getResponse() async {
  String url =
      'https://api.pexels.com/v1/curated?page=$pageNum&per_page=$NumImages';
  res = await http.get(url, headers: {"Authorization": APIkey});
  Map<String, dynamic> jsonData = json.decode(res.body);
  for (int i = 0; i < jsonData["per_page"]; i++) {
    if (!jsonList.contains(jsonData["photos"][i]["src"]["portrait"])) {
      jsonList.add(jsonData["photos"][i]["src"]["portrait"]);
    }
  }
  return jsonList;
}

Future<dynamic> getSearchResponse(String searchQuery) async {
  if (old != searchQuery) {
    searchList.clear();
    old = searchQuery;
  } else if (old == searchQuery) {
    print('$searchQuery');
  }
  print(searchList.length);
  String url =
      'https://api.pexels.com/v1/search?query=$searchQuery&page=$SearchpageNum&per_page=$SearchNumImages';
  searchRes = await http.get(url, headers: {"Authorization": APIkey});
  Map<String, dynamic> jsonSearchData = json.decode(searchRes.body);
  if (jsonSearchData["total_results"] == 0) {
    throw ('error');
  } else {
    for (int i = 0; i < jsonSearchData["per_page"]; i++) {
      if (!searchList
          .contains(jsonSearchData["photos"][i]["src"]["portrait"])) {
        searchList.add(jsonSearchData["photos"][i]["src"]["portrait"]);
      }
    }
    return searchList;
  }
}
