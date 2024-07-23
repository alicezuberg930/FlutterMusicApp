import 'dart:convert';
import 'package:flutter_music_app/models/song.dart';
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
}
