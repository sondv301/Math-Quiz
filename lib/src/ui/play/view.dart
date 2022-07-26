import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:math_quiz/generated/assets.dart';
import 'package:math_quiz/src/helpers/ads_helper.dart';
import 'package:math_quiz/src/helpers/math_helper.dart';

class PlayPage extends StatefulWidget {
  List<String> maths = [];
  final bool sum, sub, multi, div;

  PlayPage({
    Key? key,
    required this.sum,
    required this.sub,
    required this.multi,
    required this.div,
  }) : super(key: key) {
    if (sum) maths.add('+');
    if (sub) maths.add('-');
    if (multi) maths.add('*');
    if (div) maths.add(':');
  }

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  Timer timer = Timer(const Duration(), () {});
  int maxTime = 5;
  int time = 5;
  int level = 1;
  int score = 0;
  var quiz = [];
  double process = 1.0;

  final BannerAd myBanner = BannerAd(
    adUnitId: AdsHelper.adBanner,
    size: AdSize.banner,
    request: const AdRequest(keywords: ['math', 'quiz']),
    listener: BannerAdListener(onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
    }),
  );
  InterstitialAd? myInter;

  @override
  void initState() {
    quiz = MathHelper.initMath(widget.maths, level);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(time <= 0){
        timer.cancel();
        _showResult(context);
      }
      time--;
      setState(() => process = time / maxTime);
    });
    myBanner.load();
    _createInter();
    super.initState();
  }
  void _createInter(){
    InterstitialAd.load(
        adUnitId: AdsHelper.adInter,
        request: const AdRequest(keywords: ['math','quiz']),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            myInter = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
  }
  Future<void> _showInterAd() async {
    if(myInter == null) return;
    myInter?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad){},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInter();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInter();
      },
      onAdImpression: (InterstitialAd ad){},
    );
    await myInter?.show();
    myInter = null;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
            image: AssetImage(Assets.imagesPlay),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CloseButton(color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(Assets.iconsTime, width: 24),
                            const SizedBox(width: 8),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: process,
                                minHeight: 12,
                                backgroundColor: Colors.orange.withOpacity(0.24),
                                color: Colors.orange,
                              ),
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.iconsScore, width: 32),
                            const SizedBox(width: 8),
                            Text(
                              score.toString(),
                              style: GoogleFonts.rubik(color: Colors.white, fontSize: 22),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          quiz[0],
                          style: GoogleFonts.rubikWetPaint(color: Colors.white, fontSize: 50),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.red.withOpacity(0.25),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.black12,
                              child: MaterialButton(
                                onPressed: () => _checkAnswer(false),
                                color: Colors.red.withOpacity(0.25),
                                height: 88,
                                minWidth: 88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(88)),
                                child: Image.asset(
                                  Assets.iconsError,
                                  width: 36,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.green.withOpacity(0.25),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.black12,
                              child: MaterialButton(
                                onPressed: () => _checkAnswer(true),
                                color: Colors.green.withOpacity(0.25),
                                height: 88,
                                minWidth: 88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(88)),
                                child: Image.asset(
                                  Assets.iconsCorrect,
                                  width: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                  SizedBox(
                    height: myBanner.size.height.toDouble(),
                    width: myBanner.size.width.toDouble(),
                    child: AdWidget(ad: myBanner),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _checkAnswer(bool answer) {
    if (answer == quiz[1]) {
      setState(() {
        score++;
        quiz = MathHelper.initMath(widget.maths, _getLevel(score));
        time = maxTime;
        process = 1;
      });
    } else {
      timer.cancel();
      _showResult(context);
    }
  }

  int _getLevel(int score) {
    if (score <= 10) {
      return 1;
    } else if (score <= 20) {
      return 2;
    } else if (score <= 30) {
      return 3;
    } else if (score <= 40) {
      return 4;
    } else {
      return 5;
    }
  }

  Future<void> _showResult(context) async {
    await _showInterAd();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Result",
                    style: GoogleFonts.rubikWetPaint(color: Colors.white, fontSize: 28),
                  ),
                  Text(
                    "$score",
                    style: GoogleFonts.rubikWetPaint(color: Colors.orange, fontSize: 38),
                  ),
                  Text(
                    "Congratulations on your achievement!",
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                  const Divider(
                    color: Colors.orange,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.pop(dialogContext);
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
  }
}
