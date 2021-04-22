class EpisodeModel {
  String title, description, url, banner;

  EpisodeModel(this.title, this.description, this.url, this.banner);

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return new EpisodeModel(
      json['title'],
      json['desc'],
      json['url'],
      json['banner'],
    );
  }

  static List<EpisodeModel> episodesList = [
    EpisodeModel("01 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("02 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("03 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("04 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("05 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("06 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("07 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("08 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("09 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("10 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("11 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
  ];
}
