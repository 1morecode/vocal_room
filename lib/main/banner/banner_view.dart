import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:vocal/main/banner/model/banner_model.dart';

class TopBannerView extends StatelessWidget {
  final List<BannerModel> bannerList = [
    BannerModel("1", "First Banner",
        "https://blogs.glowscotland.org.uk/fi/public/inverkeithinghsmusic/uploads/sites/10406/2018/02/music-banner.jpg"),
    BannerModel("2", "Second Banner", "https://c0.wallpaperflare.com/preview/802/806/381/guitar-notenblatt-bokeh-flame.jpg"),
    BannerModel("3", "Third Banner", "https://elitelyfe.com/public/storage/Event/W39X2oFS9tupqGFk.jpg"),
    BannerModel("4", "Fourth Banner", "https://mirillis.com/blog/wp-content/uploads/2018/03/featured-mikrofon.jpg")
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      height: MediaQuery.of(context).size.width * 0.37,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Swiper(
        itemHeight: 100,
        duration: 1000,
        itemWidth: double.infinity,
        pagination: SwiperPagination(alignment: Alignment.bottomRight,margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int index) => CupertinoButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: new Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            child: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(bannerList[index].image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: new Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.black.withOpacity(0.1)),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              ),
            ),
          ),
        ),
        autoplay: true,
        viewportFraction: 0.9,
        scale: 0.95,
        layout: SwiperLayout.DEFAULT,
      ),
    );
  }
}
