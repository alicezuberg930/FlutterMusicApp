import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/search.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/services/http_service.dart';

class ApiService extends HttpService {
  Future<Search> search({required String query}) async {
    final response = await get("/search/multi", queryParameters: {"search": query});
    // print(response.data['songs'][0]['artists'][0]);
    return Search.fromJson(response.data);
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
      // print(e);
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
      // print(e);
      return [];
    }
  }

  Future<List<Top100>> getTop100() async {
    try {
      final response = await get("/page/get/top-100");
      List<Top100> top100s = [];
      response.data.forEach((item) => top100s.add(Top100.fromJson(item)));
      return top100s;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<Playlist?> getPlaylist({required String encodeId}) async {
    try {
      final response = await get("/page/get/playlist", queryParameters: {'id': encodeId});

      return Playlist.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getStreaming({required String encodeId}) async {
    try {
      final response = await get("/song/get/streaming", queryParameters: {'id': encodeId});
      if (response.data['err'] == null) {
        return response.data['128'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
