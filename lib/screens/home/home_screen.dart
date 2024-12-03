import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_test/components/app_text.dart';
import 'package:flutter_music_test/extensions/app_extensions.dart';
import 'package:flutter_music_test/models/lyric_item_model.dart';
import 'package:flutter_music_test/models/lyric_model.dart';
import 'package:flutter_music_test/resources/app_assets.dart';
import 'package:flutter_music_test/resources/app_colors.dart';
import 'package:flutter_music_test/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = HomeViewModel()..onInit();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<HomeViewModel>.value(
      value: homeViewModel,
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0)
              .copyWith(top: MediaQuery.of(context).padding.top + 20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.h3D85C6,
              AppColors.hA64D79,
            ]),
          ),
          child: Selector<HomeViewModel, ViewState>(
            selector: (_, vm) => vm.viewState,
            builder: (_, viewState, __) {
              if (viewState == ViewState.success) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Selector<HomeViewModel, String>(
                        selector: (_, vm) => vm.song.nameSong,
                        builder: (_, nameSong, __) => AppText(
                          text: nameSong,
                        ),
                      ),
                      Selector<HomeViewModel, String>(
                        selector: (_, vm) => vm.song.singer,
                        builder: (_, singer, __) => AppText(
                          text: singer,
                          color: AppColors.hFFFFFF,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          AppAssets.imgDisk,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      StreamBuilder(
                        stream: homeViewModel.player.onDurationChanged,
                        builder: (context, snapshotTotalDuration) =>
                            StreamBuilder(
                                stream: homeViewModel.player.onPositionChanged,
                                builder: (context, snapshotPositionDuration) {
                                  Duration? positionDuration =
                                      snapshotPositionDuration.data;
                                  Duration? totalDuration =
                                      snapshotTotalDuration.data;

                                  double currentPosition =
                                      (positionDuration?.inMilliseconds ?? 0) /
                                          1000;
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 80.0,
                                        child: SingleChildScrollView(
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Selector<HomeViewModel,
                                                  LyricModel>(
                                                selector: (_, vm) =>
                                                    vm.lyricModel,
                                                builder: (_, lyricModel, __) {
                                                  return ItemLineLyric(
                                                    currentPosition:
                                                        currentPosition,
                                                    lyricModel: lyricModel,
                                                  );
                                                },
                                              ),
                                              Selector<HomeViewModel, int>(
                                                selector: (p0, vm) =>
                                                    vm.lyricIndex,
                                                builder: (context, lyricIndex,
                                                    child) {
                                                  final song =
                                                      homeViewModel.song;
                                                  if (lyricIndex <
                                                      song.lyrics.length - 1) {
                                                    return ItemLyricDes(
                                                      lyrics: song.lyrics,
                                                      index: lyricIndex + 1,
                                                    );
                                                  }
                                                  return const SizedBox();
                                                },
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                      Slider.adaptive(
                                        value: positionDuration?.inSeconds
                                                .toDouble() ??
                                            0.0,
                                        min: 0.0,
                                        max: totalDuration?.inSeconds
                                                .toDouble() ??
                                            1.0,
                                        onChanged: (value) {
                                          homeViewModel.onSeek(value);
                                        },
                                        thumbColor: AppColors.h000000,
                                        activeColor: AppColors.h000000,
                                        inactiveColor: AppColors.h999999,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ).copyWith(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            AppText(
                                              text: positionDuration
                                                  .formatDuration,
                                              fontSize: 16.0,
                                              color: AppColors.hFFFFFF,
                                            ),
                                            const Spacer(),
                                            AppText(
                                              text:
                                                  totalDuration.formatDuration,
                                              fontSize: 16.0,
                                              color: AppColors.hFFFFFF,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              double seconds =
                                                  (currentPosition - 5);
                                              homeViewModel.onSeek(seconds);
                                            },
                                            icon: const Icon(Icons.fast_rewind,
                                                size: 30.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0),
                                            child: StreamBuilder(
                                              stream: homeViewModel
                                                  .player.onPlayerStateChanged,
                                              builder: (context, snapshot) =>
                                                  _buildIconPlay(
                                                onTap: homeViewModel.onPlay,
                                                icon: snapshot.data ==
                                                        PlayerState.playing
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              double seconds =
                                                  (currentPosition + 5);
                                              homeViewModel.onSeek(seconds);
                                            },
                                            icon: const Icon(Icons.fast_forward,
                                                size: 30.0),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIconPlay({
    required Function() onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: AppColors.h000000, shape: BoxShape.circle),
        child: Icon(
          icon,
          size: 40.0,
          color: AppColors.hA64D79,
        ),
      ),
    );
  }

  @override
  void dispose() {
    homeViewModel.onDispose();
    super.dispose();
  }
}

class ItemLyricDes extends StatelessWidget {
  const ItemLyricDes({
    super.key,
    required this.lyrics,
    required this.index,
  });

  final List<LyricModel> lyrics;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        lyrics[index].lyrics.length,
        (indexItem) => AppText(
          text: lyrics[index].lyrics[indexItem].text,
          fontSize: 14,
          color: AppColors.hFFFFFF,
        ),
      ),
    );
  }
}

class ItemLineLyric extends StatelessWidget {
  const ItemLineLyric({
    super.key,
    required this.currentPosition,
    required this.lyricModel,
  });

  final double currentPosition;
  final LyricModel lyricModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(lyricModel.lyrics.length, (index) {
        final lyric = lyricModel.lyrics[index];
        double space = 0.5;
        if (index < lyricModel.lyrics.length - 1) {
          space =
              lyricModel.lyrics[index + 1].time - lyricModel.lyrics[index].time;
          if (space == 0) {
            space = 0.0005;
          }
        }
        return ItemGroupChar(
          lyric: lyric,
          space: space,
          currentPosition: currentPosition,
        );
      }),
    );
  }
}

class ItemGroupChar extends StatelessWidget {
  const ItemGroupChar({
    super.key,
    required this.lyric,
    required this.space,
    required this.currentPosition,
  });

  final LyricItemModel lyric;
  final double space;
  final double currentPosition;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        lyric.text.length,
        (indexChar) {
          double charSeconds = space / lyric.text.length;
          double secondsDuration = lyric.time + charSeconds * indexChar;
          final isActive = currentPosition >= secondsDuration;

          return ItemCharLyric(
            text: lyric.text[indexChar],
            milliseconds: secondsDuration.toInt(),
            isActive: isActive,
          );
        },
      ),
    );
  }
}

class ItemCharLyric extends StatelessWidget {
  const ItemCharLyric({
    super.key,
    required this.text,
    required this.milliseconds,
    required this.isActive,
  });

  final String text;
  final int milliseconds;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      curve: Curves.bounceInOut,
      duration: Duration(
        milliseconds: milliseconds,
      ),
      style: TextStyle(
        fontSize: 16,
        color: isActive ? AppColors.h000000 : AppColors.hFFFFFF,
        fontWeight: FontWeight.bold,
      ),
      child: Text(text),
    );
  }
}
