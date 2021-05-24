
class APIData{

  // Base URL
  static String baseUrl = "http://101.53.153.152:7890/api";
  static String imageBaseUrl = "http://101.53.153.152:7890/";

  // Token API
  static String tokenAPI = "https://b16afb9fdc235b1a7918b096332b6589.m.pipedream.net/";

  // Dashboard API
  static String createPlaylistAPI = "/playlist/create/upload";
  static String fetchPlaylistAPI = "/playlist/list";
  static String deletePlaylistAPI = "/playlist/delete";
  static String updatePlaylistAPI = "/playlist/update";


  static String fetchPlaylistEpisodeAPI = "/media/list";
  static String createNewEpisodeAPI = "/playlist/media";
  static String deleteEpisodeAPI = "/media/delete";
  static String updateEpisodeAPI = "/playlist/media";


  // PodCast API's
  // Status
  static String createNewStatusAPI = "/user/status/upload";
  static String fetchAllStatusAPI = "/user/list?collection=status";
  static String updateStatusViewAPI = "/user/list?collection=status";
  static String deleteStatusAPI = "/user/list?collection=status";

  // Playlist
  static String fetchAllPodCastPlaylistAPI = "/playlist/list?public=1";
}