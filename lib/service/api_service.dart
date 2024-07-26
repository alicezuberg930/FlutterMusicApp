import 'dart:convert';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/service/http_service.dart';

class ApiService extends HttpService {
  Future search({required String query}) async {
    final response = await get("/search/multi", queryParameters: {"query": query});
    Map<String, dynamic> map = jsonDecode(response.data);
  }

  Future<Song?> getInfo({required String encodeId}) async {
    try {
      final response = await get("/info/get", queryParameters: {"encode_id": encodeId});
      if (response.data["err"] != null) {
        return null;
      } else {
        return Song.fromJson(response.data);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Song>> getHome() async {
    try {
      final response = await get("/page/get/home");
      List<Song> songs = [];
      response.data['items'][2]['items']['all'].forEach((song) => songs.add(Song.fromJson(song)));
      return songs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Top100>?> getTop100() async {
    // try {
    final response = await get("/page/get/top-100");
    // List<Playlist> songs = [];
    // response.data['items'].forEach((song) => songs.add(Playlist.fromJson(song)));
    // return songs;
    List<Top100> top100s = [];
    response.data.forEach((item) => top100s.add(Top100.fromJson(item)));
    // response.data['items'][2]['items']['all'].forEach((song) => songs.add(Song.fromJson(song)));
    return top100s;
    // return response.data.map((item) => Top100.fromJson(item)).toList();
    // } catch (e) {
    //   print(e);
    //   return [];
    // }
  }
}
