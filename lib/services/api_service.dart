import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/ui_helpers.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/search.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/services/http_service.dart';

class ApiService {
  static Future<Search?> search({required String query}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}/api/v2/search/multi",
        queryParameters: {"q": query, "sig": Utils.hashParamNoId("/api/v2/search/multi")},
      );
      if (response.data['err'] == 0) {
        return Search.fromJson(response.data["data"]);
      } else if (response.data['err'] != 0) {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      } else {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      }
    } catch (e) {
      UIHelpers.showSnackBar(message: e.toString());
      return null;
    }
  }

  static Future<List<Song>> getHome() async {
    try {
      final response = await HttpService.get("${Constants.apiUrl}/api/v2/page/get/home", queryParameters: {
        "page": 1,
        "segmentId": "-1",
        "count": "30",
        "sig": Utils.hashParamHome("/api/v2/page/get/home"),
      });
      if (response.data['err'] == 0) {
        List<Song> songs = [];
        response.data["data"]['items'][2]['items']['all'].forEach((song) => songs.add(Song.fromJson(song)));
        return songs;
      } else if (response.data['err'] != 0) {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return [];
      } else {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return [];
      }
    } catch (e) {
      UIHelpers.showSnackBar(message: e.toString());
      return [];
    }
  }

  static Future<List<Top100>> getTop100() async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}/api/v2/page/get/top-100",
        queryParameters: {"sig": Utils.hashParamNoId("/api/v2/page/get/top-100")},
      );
      if (response.data['err'] == 0) {
        List<Top100> top100s = [];
        response.data["data"].forEach((item) => top100s.add(Top100.fromJson(item)));
        return top100s;
      } else if (response.data['err'] != 0) {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return [];
      } else {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return [];
      }
    } catch (e) {
      UIHelpers.showSnackBar(message: e.toString());
      return [];
    }
  }

  static Future<Playlist?> getPlaylist({required String encodeId}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}/api/v2/page/get/playlist",
        queryParameters: {'id': encodeId, "sig": Utils.hashParamWithId("/api/v2/page/get/playlist", encodeId)},
      );
      if (response.data['err'] == 0) {
        return Playlist.fromJson(response.data["data"]);
      } else if (response.data['err'] != 0) {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      } else {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      }
    } catch (e) {
      UIHelpers.showSnackBar(message: e.toString());
      return null;
    }
  }

  static Future<String?> getStreaming({required String encodeId}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}/api/v2/song/get/streaming",
        queryParameters: {"id": encodeId, "sig": Utils.hashParamWithId("/api/v2/song/get/streaming", encodeId)},
      );
      if (response.data['err'] == 0) {
        return response.data['data']['128'];
      } else if (response.data['err'] != 0) {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      } else {
        UIHelpers.showSnackBar(message: response.data['msg']);
        return null;
      }
    } catch (e) {
      UIHelpers.showSnackBar(message: e.toString());
      return null;
    }
  }
}
