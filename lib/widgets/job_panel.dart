import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/model/build_param.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/model/job.dart';
import 'package:jenkins_board/provider/build_tasks_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:jenkins_board/widgets/running_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:popover/popover.dart';

class JobPanel extends ConsumerWidget {
  JobPanel({required this.job, Key? key}) : super(key: key);
  final Job job;

  final branchesProvider =
      FutureProvider.autoDispose.family<List<Branch>, Job>((ref, job) async {
    return JenkinsApi.getJobDetail(job);
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: _calculateWidth(context),
      decoration: BoxDecoration(
          color: context.primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.headline5.copyWith(
                  color: context.accentColor, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ref.watch(branchesProvider(job)).when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, stack) {
                    return const Center(child: Text('Something wrong'));
                  },
                  data: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return _JobItem(data[index]);
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  double _calculateWidth(BuildContext context) {
    final width = context.width;
    if (width > 990) {
      return (width - 90) / 3;
    }
    if (width > 660) {
      return (width - 70) / 2;
    }
    return width - 30;
  }
}

class _JobItem extends ConsumerStatefulWidget {
  const _JobItem(this.branch, {Key? key}) : super(key: key);
  final Branch branch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JobItemState();
}

class _JobItemState extends ConsumerState<_JobItem> {
  late bool _loadBuilding;

  @override
  initState() {
    _loadBuilding = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.branch.name,
          style: context.headline6,
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            context.go('/home/build_detail');
            final url = await JenkinsApi.recentBuildUrl(widget.branch.url);
            if (url != null) {
              context.go('/home/build_detail', extra: url);
            } else {
              context.go('/');
              context.toast('No build under the branch',
                  icon: LineIcons.infoCircle);
            }
          },
          child: (widget.branch.isRunning)
              ? const RunningWidget()
              : CircleAvatar(
                  radius: 6,
                  backgroundColor: widget.branch.statusColor,
                ),
        ),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: Builder(
            builder: (context) {
              if (_loadBuilding) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return IconButton(
                splashRadius: 20,
                icon: Icon(
                  LineIcons.running,
                  color: context.accentColor,
                ),
                onPressed: () => _onBuild(context),
              );
            },
          ),
        ),
      ],
    );
  }

  _onBuild(BuildContext context) async {
    setState(() {
      _loadBuilding = true;
    });
    try {
      final buildParams =
          await JenkinsApi.getBranchBuildParams(widget.branch.url);
      if (buildParams.isEmpty) {
        await _newBuild(context, ref, widget.branch);
      } else {
        showPopover(
          context: context,
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: _RunBuildWidget(widget.branch, buildParams),
            );
          },
          shadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(-1, 1))
          ],
          onPop: () {},
          direction: PopoverDirection.top,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      }
    } catch (e) {
      context.toast('Build Not started, please try again');
    } finally {
      if (mounted) {
        setState(() {
          _loadBuilding = false;
        });
      }
    }
  }
}

class _RunBuildWidget extends ConsumerWidget {
  _RunBuildWidget(this.branch, this.buildParams, {Key? key}) : super(key: key);
  final Branch branch;
  final List<BuildParam> buildParams;

  final _buildParam = <String, dynamic>{};
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...[for (var p in buildParams) _paramWidget(p)],
          CustomButton(
            onPressed: () async {
              try {
                await _newBuild(context, ref, branch, buildParam: _buildParam);
              } catch (e) {
                print(e.toString());
                context.toast('Build Not started, please try again');
              }
              context.pop();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Buiild'),
            ),
          )
        ],
      ),
    );
  }

  Widget _paramWidget(BuildParam buildParam) {
    _buildParam[buildParam.name] = buildParam.defautlValue;
    switch (buildParam.type) {
      case 'ChoiceParameterDefinition':
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(buildParam.name),
              ...[
                for (var v in buildParam.choices!)
                  Row(
                    children: [
                      Radio(
                        groupValue: _buildParam[buildParam.name],
                        value: v,
                        onChanged: (value) {
                          _buildParam[buildParam.name] = value;
                        },
                      ),
                      const Spacer(),
                      Text(v)
                    ],
                  ),
              ],
            ]);
      case 'BooleanParameterDefinition':
        return Row(
          children: [
            Text(buildParam.name),
            const Spacer(),
            Switch(
              value: buildParam.defautlValue as bool,
              onChanged: (value) {
                _buildParam[buildParam.name] = value;
              },
            ),
          ],
        );
      default:
        return const Center();
    }
  }
}

Future _newBuild(BuildContext context, WidgetRef ref, Branch branch,
    {Map<String, dynamic>? buildParam}) async {
  final url = await JenkinsApi.newBuild(branch, params: buildParam);
  final task = BuildTask(
      name: branch.name,
      branchUrl: branch.url,
      buildUrl: url,
      startTime: DateTime.now());
  ref.read(buildTasksProvider.notifier).add(task);
  context.toast('Build started, good luck!', icon: LineIcons.running);
}
