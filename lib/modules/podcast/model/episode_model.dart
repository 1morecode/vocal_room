class EpisodeModel {
  String id, title, description, url, banner;

  EpisodeModel(this.id, this.title, this.description, this.url, this.banner);

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return new EpisodeModel(
      json['id'],
      json['title'],
      json['desc'],
      json['url'],
      json['banner'],
    );
  }

  static List<EpisodeModel> episodesList = [
    EpisodeModel("1", "01 Episode", "Episode Description", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("2", "02 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("3", "03 Episode", "Episode Description", "https://www.kozco.com/tech/LRMonoPhase4.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("4", "04 Episode", "Episode Description", "https://www.kozco.com/tech/LRMonoPhase4.mp3", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("5", "05 Episode", "Episode Description", "https://www.kozco.com/tech/piano2.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("6", "06 Episode", "Episode Description", "https://www.kozco.com/tech/piano2-CoolEdit.mp3", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("7", "07 Episode", "Episode Description", "https://www.kozco.com/tech/piano2-Audacity1.2.5.mp3", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("8", "08 Episode", "Episode Description", "https://www.kozco.com/tech/WAV-MP3.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("9", "09 Episode", "Episode Description", "https://www.kozco.com/tech/organfinale.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("10", "10 Episode", "Episode Description", "https://www.kozco.com/tech/32.mp3", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
    EpisodeModel("11", "11 Episode", "Episode Description", "https://www.kozco.com/tech/c304-2.wav", "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
  ];
}
