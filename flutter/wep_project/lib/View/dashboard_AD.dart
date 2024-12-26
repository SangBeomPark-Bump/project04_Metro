import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wep_project/model/ad_list.dart';
import 'package:wep_project/model/count_chart.dart';

class DashboardAd extends StatefulWidget {
  const DashboardAd({super.key});

  @override
  State<DashboardAd> createState() => _DashboardAdState();
}

class _DashboardAdState extends State<DashboardAd> {
  late int adCount;
  late int vitConunt;
  late DateTime today;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    adCount = 0;
    vitConunt = 0;
    today = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(today);
  }

  Future<int> getTodayVisitorCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('VitCount')
        .where('Date', isEqualTo: formattedDate)
        .get();

    for (var doc in snapshot.docs) {
      vitConunt += int.tryParse(doc['Count'].toString()) ?? 0;
    }
    return vitConunt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  width: 1650,
                  height: 110,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Text(
                                '현황',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xffE4E4E4),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  '진행 광고  ',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Text(
                                '  $adCount',
                                style: TextStyle(
                                    color: Color(0xffF64545), fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(
                                  '오늘 방문자 수  ',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              FutureBuilder(
                                future: getTodayVisitorCount(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  return Text(
                                    '  ${snapshot.data ?? 0}',
                                    style: TextStyle(
                                        color: Color(0xffF64545), fontSize: 17),
                                  );
                                },
                              ),
                              // Text(
                              //   '  $adCount',
                              //   style: TextStyle(
                              //     color: Color(0xffF64545),
                              //     fontSize: 17
                              //   ),
                              //   ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      width: 815,
                      height: 600,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // 방문자 현황
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                  child: Text(
                                    '방문자 현황',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Color(0xffE4E4E4),
                            ),
                            Container(
                              width: 600,
                              height: 500,
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('VitCount')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Center(child: Text("No Data"));
                                  }
                                  final List<QueryDocumentSnapshot> docs =
                                      snapshot.data!.docs;
                                  docs.sort((a, b) {
                                    return a['Date']
                                        .compareTo(b['Date']); // 오름차순 정렬
                                  });
                                  List<CountChart> chartData = docs.map((doc) {
                                    return CountChart(
                                      date: doc['Date'],
                                      count:
                                          int.tryParse(doc['Count'] ?? '0') ??
                                              0,
                                    );
                                  }).toList();

                                  return SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(),
                                    series: <CartesianSeries<CountChart,
                                        String>>[
                                      LineSeries<CountChart, String>(
                                        dataSource: chartData,
                                        xValueMapper: (CountChart data, _) =>
                                            data.date,
                                        yValueMapper: (CountChart data, _) =>
                                            data.count,
                                        color: Colors.blue,
                                        markerSettings: const MarkerSettings(
                                            isVisible: true),
                                        dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            labelAlignment:
                                                ChartDataLabelAlignment.auto,
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 혼잡도 / 예측 비교
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Container(
                      width: 815,
                      height: 600,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                  child: Text(
                                    '혼잡도 / 예측 비교',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Color(0xffE4E4E4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 광고 배너 관리
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Container(
                        width: 815,
                        height: 600,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                    child: Text(
                                      '광고 배너 관리',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xffE4E4E4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 광고 현황
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Container(
                        width: 815,
                        height: 600,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                    child: Text(
                                      '광고 현황',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffFF7777),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                      ),
                                      child: const Text(
                                        '광고 추가'
                                        )
                                      ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xffE4E4E4),
                              ),
                              Container(
              width: 750,
              height: 400,
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                  // firebase에 있는 데이터중 User collection의 문서 전체 출력
                  stream: FirebaseFirestore.instance.collection('AdList').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final documents = snapshot.data!.docs;
                    return ListView(
                      // map형식으로 되어있는 데이터를 list로 변환
                      children: documents.map((e) => buildItemWidgets(e)).toList(),
                    );
                  },
                ),
            ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    Widget buildItemWidgets(DocumentSnapshot doc){
    final user = AdList(
      appdate: doc['AppDate'], 
      condate: doc['ConDate'], 
      conmoney: doc['ConMoney'], 
      copname: doc['CopName'], 
      enddate: doc['EndDate']
      );
      return Card(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                user.appdate,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.condate,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.conmoney,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.copname,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(
              width: 100,
              child: Text(
                user.enddate,
                style: const TextStyle(
                  fontSize: 17
                ),
                textAlign: TextAlign.center,
                )
              ),
          ],
        ),
      );
  }
}
