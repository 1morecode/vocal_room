class APIData {
  // Base URL
  static final String serverUrl = 'http://101.53.153.152:7890';
  static String baseUrl = "http://101.53.153.152:7890/api";
  static String imageBaseUrl = "http://101.53.153.152:7890/";

  // Token API
  static String tokenAPI =
      "https://b16afb9fdc235b1a7918b096332b6589.m.pipedream.net/";
  static String getUserByUIdAPI =
      "/user/list?collection=register_devices&user_id=";

  // Dashboard API
  static String createPlaylistAPI = "/playlist/create/upload";
  static String fetchPlaylistAPI = "/playlist/list";
  static String deletePlaylistAPI = "/playlist/delete";
  static String updatePlaylistAPI = "/playlist/update";

  static String fetchPlaylistEpisodeAPI = "/media/list";
  static String createNewEpisodeAPI = "/playlist/media";
  static String deleteEpisodeAPI = "/media/delete";
  static String updateEpisodeAPI = "/media/update";

  // PodCast API's
  // Status
  static String createNewStatusAPI = "/user/status/upload";
  static String fetchAllStatusAPI = "/user/list?collection=status";
  static String updateStatusViewAPI = "/user/list?collection=status";
  static String deleteStatusAPI = "/user/delete";

  // Playlist
  static String fetchAllPodCastPlaylistAPI = "/playlist/list?public=1";

  // Category
  static String fetchAllCategoryListAPI = "/category/list";
  static String fetchAllPlaylistByCategoryAPI =
      "/playlist/list?public=1&cat_id=";

  // Search
  static String playlistSearchAPI = "/playlist/list?q=";

  // Chat API
  static String searchAllUsersAPI = "/user/list?collection=register_devices";

  // Follow/Unfollow
  static String getFollowStatusAPI = "/user/follow_status?follow_id=";
  static String followAPI = "/user/follow?follow_id=";
  static String unfollowAPI = "/user/unfollow?follow_id=";
}
