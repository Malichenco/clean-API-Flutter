import 'package:Taillz/application/pole/pole_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Localization/t_keys.dart';
import '../../presentation/screens/main_screen.dart';
import '../medal/medal_screen.dart';
import 'c/pole_controller.dart';

enum PollButtons { yes, no, irrelevant, none }

class PollsScreen extends StatefulWidget {
  const PollsScreen({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<PollsScreen> {
  late PoleController _con;
  _PageState() : super(PoleController()) {
    _con = controller as PoleController;
  }
  @override
  void initState() {
    super.initState();
    _con.getPole();
  }

  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  final Color _yesColor = const Color(0xFF9FEB7E);
  final Color _noColor = const Color(0xFFFF5757);
  final Color _irrelevantColor = const Color(0xff9D908A);
  final Color _beforeColor = const Color(0xFFF5F5F5);

  final ValueNotifier<PollButtons> _isClicked = ValueNotifier(PollButtons.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: 0,
        title: CustomAppBarTitle(scaffoldKey: _con.scaffoldKey, index: 1),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_con.response == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_con.response!.payload!.isEmpty) {
      return Container(
        alignment: AlignmentDirectional.center,
        child: Text('No poll available'),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('${_con.response!.payload!.first.pollTopic}',
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          Text('${_con.response!.payload!.first.pollQuestion}',
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: _isClicked,
            builder: (_, isClicked, __) {
              return Row(
                children: [
                  const SizedBox(width: 44),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        _isClicked.value = PollButtons.yes;
                        var response = await _con.opted(1);
                        if (!response.success!) {
                          _showAlreadyVoteAlert();
                        }
                      },
                      child: Container(
                        height: 32,
                        decoration: ShapeDecoration(
                          shape: const StadiumBorder(),
                          color: isClicked == PollButtons.yes
                              ? _yesColor
                              : _beforeColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(TKeys.yes.translate(context),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: isClicked != PollButtons.yes
                                    ? Colors.black
                                    : Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        _isClicked.value = PollButtons.no;
                        var response = await _con.opted(2);
                        if (!response.success!) {
                          _showAlreadyVoteAlert();
                        }
                      },
                      child: Container(
                        height: 32,
                        decoration: ShapeDecoration(
                          shape: const StadiumBorder(),
                          color: isClicked == PollButtons.no
                              ? _noColor
                              : _beforeColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(TKeys.no.translate(context),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: isClicked != PollButtons.no
                                    ? Colors.black
                                    : Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        _isClicked.value = PollButtons.irrelevant;
                        var response = await _con.opted(3);
                        if (!response.success!) {
                          _showAlreadyVoteAlert();
                        }
                      },
                      child: Container(
                        height: 32,
                        decoration: ShapeDecoration(
                          shape: const StadiumBorder(),
                          color: isClicked == PollButtons.irrelevant
                              ? _irrelevantColor
                              : _beforeColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(TKeys.irrelevant.translate(context),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: isClicked != PollButtons.irrelevant
                                    ? Colors.black
                                    : Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 40,
                interval: 10,
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: const TextStyle(color: Colors.transparent),
              ),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: _con.data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: TKeys.votes.translate(context),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  pointColorMapper: (ChartData data, _) {
                    if (data.x.toLowerCase() ==
                        TKeys.yes.translate(context).toLowerCase()) {
                      return const Color(0xFF9FEB7E);
                    } else if (data.x.toLowerCase() ==
                        TKeys.no.translate(context).toLowerCase()) {
                      return const Color(0xFFFF5757);
                    } else if (data.x.toLowerCase() ==
                        TKeys.irrelevant.translate(context).toLowerCase()) {
                      return const Color(0xFF5D17EB);
                    } else {
                      return const Color(0xFF9FEB7E);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
              '${TKeys.total_voters.translate(context)}${_con.response!.payload!.first.totalVotes}',
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 24),
          SvgPicture.asset('assets/images/PageQuestionPollMainPicture.svg',
              height: 250),
        ],
      ),
    );
  }

  void _showAlreadyVoteAlert() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          //title: const Text('Error'),
          content: Text(TKeys.PollsYouAlreadyVoted.translate(context)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.xWidget, this.x, this.y);

  final Widget xWidget;
  final String x;
  final double y;
}
