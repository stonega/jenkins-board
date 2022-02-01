import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/build_result.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:intl/intl.dart';

class BuildDetailPage extends ConsumerWidget {
  BuildDetailPage(this.url, {Key? key}) : super(key: key);
  final String url;

  final buildResultProvider =
      FutureProvider.family<BuildResult?, String>((ref, url) async {
    return JenkinsApi.recentBuild(url);
  });
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildResult = ref.watch(buildResultProvider(url));
    return buildResult.when(
      loading: () => const SettingWrapper(
          child: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          SettingWrapper(child: Center(child: Text('Error: $err'))),
      data: (data) {
        if (data == null) return const Center();
        return SettingWrapper(
          showNavBar: true,
          onNext: data.nextBuild == null
              ? null
              : () => context.push('/build_detail', extra: data.nextBuild),
          onPre: data.preBuild == null
              ? null
              : () => context.push('/build_detail', extra: data.preBuild),
          child: Center(
            child: SizedBox(
              width: 600,
              child: ListView(
                controller: _controller,
                children: [
                  Row(
                    children: [
                      Text(
                        data.displayName,
                        style: context.headline4,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(data.result),
                    ],
                  ),
                  _devider,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data.userName,
                        style: context.bodyText1
                            .copyWith(color: context.accentColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(DateFormat.yMd().add_Hm().format(data.timestamp),
                          style: context.bodyText1
                              .copyWith(color: context.accentColor))
                    ],
                  ),
                  _devider,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var c in data.commits)
                        Text(
                          c,
                          style: context.bodyText1,
                        )
                    ],
                  ),
                  _devider,
                  Text(data.consoleLog ?? '', style: GoogleFonts.firaCode()),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final _devider = const SizedBox(
    height: 10,
  );
}
