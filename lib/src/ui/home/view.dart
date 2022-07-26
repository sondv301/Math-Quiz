import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:math_quiz/generated/assets.dart';
import 'package:math_quiz/src/helpers/ads_helper.dart';
import 'package:math_quiz/src/ui/play/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool sum = true, sub = true, multi = true, div = true;
  bool isLoadedAds = false;
  NativeAd? myNative;

  @override
  void initState() {
    super.initState();
    myNative = NativeAd(
      adUnitId: AdsHelper.adNative,
      factoryId: 'adFactoryExample',
      request: const AdRequest(keywords: ['math', 'quiz']),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() => isLoadedAds = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() => isLoadedAds = false);
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
        onNativeAdClicked: (NativeAd ad) {},
      ),
    );
    myNative?.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(top: 24),
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBg),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Math Quiz',
                style: GoogleFonts.rubikWetPaint(
                  color: Colors.white,
                  fontSize: 62,
                ),
              ),
              isLoadedAds
                  ? SizedBox(
                      width: 450,
                      height: 220,
                      child: AdWidget(ad: myNative!),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                        value: sum,
                        onChanged: (value) => setState(() => sum = value!),
                        title: Text(
                          "+",
                          style: GoogleFonts.rubikMoonrocks(fontSize: 36, color: Colors.white),
                        ),
                      )),
                      Expanded(
                          child: CheckboxListTile(
                        value: sub,
                        onChanged: (value) => setState(() => sub = value!),
                        title: Text(
                          "-",
                          style: GoogleFonts.rubikMoonrocks(fontSize: 36, color: Colors.white),
                        ),
                      )),
                      Expanded(
                          child: CheckboxListTile(
                        value: multi,
                        onChanged: (value) => setState(() => multi = value!),
                        title: Text(
                          "x",
                          style: GoogleFonts.rubikMoonrocks(fontSize: 36, color: Colors.white),
                        ),
                      )),
                      Expanded(
                          child: CheckboxListTile(
                        value: div,
                        onChanged: (value) => setState(() => div = value!),
                        title: Text(
                          ":",
                          style: GoogleFonts.rubikMoonrocks(fontSize: 36, color: Colors.white),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 36),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white30,
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.white12,
                      child: MaterialButton(
                        onPressed: _onStart,
                        color: Colors.white30,
                        elevation: 0,
                        height: 110,
                        minWidth: 110,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(88)),
                        child: Text(
                          "Start",
                          style: GoogleFonts.rubikWetPaint(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onStart() {
    if (!sum && !sub && !multi && !div) {
      showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Unselected",
                      style: GoogleFonts.rubikWetPaint(color: Colors.white, fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Need to choose at least one operation",
                      style: GoogleFonts.rubik(color: Colors.white),
                    ),
                    const Divider(
                      color: Colors.orange,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      minWidth: 98,
                      color: Colors.white24,
                      child: Text(
                        "OK",
                        style: GoogleFonts.rubik(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayPage(sum: sum, sub: sub, multi: multi, div: div),
        ),
      );
    }
  }
}
