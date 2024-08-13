import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/ui_helpers.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/search.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/section.dart';
import 'package:flutter_music_app/models/video.dart';
import 'package:flutter_music_app/services/http_service.dart';

class ApiService {
  static String searchEndpoint = "/api/v2/search/multi";
  static String homeEndpoint = "/api/v2/page/get/home";
  static String top100Endpoint = "/api/v2/page/get/top-100";
  static String playlistEndpoint = "/api/v2/page/get/playlist";
  static String streamingEndpoint = "/api/v2/song/get/streaming";
  static String videoEndpoint = "/api/v2/page/get/video";
  static String artistEndpoint = "/api/v2/page/get/artist";

  static Future<Search?> search({required String query}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}$searchEndpoint",
        queryParameters: {"q": query, "sig": Utils.hashParamNoId(searchEndpoint)},
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
      final response = await HttpService.get("${Constants.apiUrl}$homeEndpoint", queryParameters: {
        "page": 1,
        "segmentId": "-1",
        "count": "30",
        "sig": Utils.hashParamHome(homeEndpoint),
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

  static Future<List<Section>> getTop100() async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}$top100Endpoint",
        queryParameters: {"sig": Utils.hashParamNoId(top100Endpoint)},
      );
      if (response.data['err'] == 0) {
        List<Section> top100s = [];
        response.data["data"].forEach((item) => top100s.add(Section.fromJson(item)));
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
        "${Constants.apiUrl}$playlistEndpoint",
        queryParameters: {'id': encodeId, "sig": Utils.hashParamWithId(playlistEndpoint, encodeId)},
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
        "${Constants.apiUrl}$streamingEndpoint",
        queryParameters: {"id": encodeId, "sig": Utils.hashParamWithId(streamingEndpoint, encodeId)},
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

  static Future<Video?> getVideo({required String encodeId}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}$videoEndpoint",
        queryParameters: {"id": encodeId, "sig": Utils.hashParamWithId(videoEndpoint, encodeId)},
      );
      if (response.data['err'] == 0) {
        return Video.fromJson(response.data['data']);
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

  static Future<Artist?> getArtist({required String name}) async {
    try {
      final response = await HttpService.get(
        "${Constants.apiUrl}$artistEndpoint",
        queryParameters: {"alias": name, "sig": Utils.hashParamNoId(artistEndpoint)},
      );
      if (response.data['err'] == 0) {
        return Artist.fromJson(response.data['data']);
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
