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
    return JenkinsApi.buildDetail(url);
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
              : () => context.go('/build_detail', extra: data.nextBuild),
          onPre: data.preBuild == null
              ? null
              : () => context.go('/build_detail', extra: data.preBuild),
          child: Center(
            child: SizedBox(
              width: 600,
              child: ListView(
                controller: _controller,
                children: [
                  Text(
                    data.displayName,
                    style: context.headline4,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  _devider,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.yMd().add_Hm().format(data.timestamp),
                          style: context.bodyText1
                              .copyWith(color: context.accentColor))
                    ],
                  ),
                  _devider,
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: _getTextColor(data.result),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        data.result,
                        style: TextStyle(color: _getTextColor(data.result)),
                      ),
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

  Color _getTextColor(String result) {
    switch (result) {
      case 'FAILED':
        return Colors.red;
      case 'SUCCESS':
        return Colors.green;
      case 'ABORTED':
        return Colors.yellow[900]!;
      case 'RUNNING':
        return Colors.yellow[900]!;
      default:
        return Colors.transparent;
    }
  }
}
