import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_test/components/app_text.dart';
import 'package:flutter_music_test/extensions/app_extensions.dart';
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
          child: SingleChildScrollView(
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
                const SizedBox(height: 80.0),
                StreamBuilder(
                  stream: homeViewModel.player.onDurationChanged,
                  builder: (context, snapshotTotalDuration) => StreamBuilder(
                      stream: homeViewModel.player.onPositionChanged,
                      builder: (context, snapshotPositionDuration) {
                        Duration? positionDuration =
                            snapshotPositionDuration.data;
                        Duration? totalDuration = snapshotTotalDuration.data;
                        return Column(
                          children: [
                            Slider.adaptive(
                              value:
                                  positionDuration?.inSeconds.toDouble() ?? 0.0,
                              min: 0.0,
                              max: totalDuration?.inSeconds.toDouble() ?? 1.0,
                              onChanged: (value) {
                                homeViewModel.onSeek(value);
                              },
                              thumbColor: AppColors.h000000,
                              activeColor: AppColors.h000000,
                              inactiveColor: AppColors.h999999,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0)
                                      .copyWith(bottom: 20.0),
                              child: Row(
                                children: [
                                  AppText(
                                    text: positionDuration.formatDuration,
                                    fontSize: 16.0,
                                    color: AppColors.hFFFFFF,
                                  ),
                                  const Spacer(),
                                  AppText(
                                    text: totalDuration.formatDuration,
                                    fontSize: 16.0,
                                    color: AppColors.hFFFFFF,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fast_rewind,
                      size: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: StreamBuilder(
                        stream: homeViewModel.player.onPlayerStateChanged,
                        builder: (context, snapshot) => _buildIconPlay(
                          onTap: homeViewModel.onPlay,
                          icon: snapshot.data == PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.fast_forward,
                      size: 30.0,
                    ),
                  ],
                )
              ],
            ),
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
}
