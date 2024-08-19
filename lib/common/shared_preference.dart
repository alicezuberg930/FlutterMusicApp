import 'dart:convert';

import 'package:flutter_music_app/models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static String userloggedinKeys = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String useremailKey = "USEREMAILKEY";
  static String avatarKey = "AVATARKEY";
  static String userDataKey = "USERDATA";
  static String darkModeKey = "DARKMODE";
  static String currentPlaylist = "CURRENT_PLAYLIST";

  static late SharedPreferences pref;

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  static clearAllData() async {
    await pref.clear();
  }

  static clearKeyData(String key) async {
    await pref.remove(key);
  }

  static Future setCurrentPlaylist(List<Song> songs) async {
    List<String> songStrings = songs.map((e) => json.encode(e.toJson())).toList();
    await pref.setStringList(currentPlaylist, songStrings);
  }

  static List<Song> getCurrentPlaylist() {
    List<String>? playlistData = pref.getStringList(currentPlaylist);
    if (playlistData == null) return [];
    List<Map<String, dynamic>> playlistMap = [];
    for (var e in playlistData) {
      playlistMap.add(json.decode(e));
    }
    return playlistMap.map((e) => Song.fromJson(e)).toList();
  }

  static bool? getDarkMode() {
    bool? darkMode = pref.getBool(darkModeKey);
    return darkMode;
  }
}
