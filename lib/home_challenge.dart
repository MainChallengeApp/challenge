import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';
import 'package:nested_navigation_demo_flutter/models/challenge.dart';

class HomeChallenge extends StatelessWidget {
  const HomeChallenge(
      {super.key, required this.title, required this.challenge});
  final String title;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$title/${challenge.title}',
            style:
                const TextStyle(color: Colors.black, fontSize: appBarFontSize),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          width: 345,
          height: 120 + 8 * 64 + 2,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          // margin: EdgeInsets.only(bottom:16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(241, 245, 249, 1),
                    image: DecorationImage(
                      image: AssetImage(challenge.thumbnailPath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Text(
                    challenge.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                  )),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(_dateFormat(challenge.startDate),
                          style: const TextStyle(color: themeColor3))
                    ],
                  )),
                  const Text('  |  '),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'End',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _dateFormat(challenge.endDate),
                        style: const TextStyle(color: themeColor3),
                      )
                    ],
                  )),
                ],
              ),
              const SizedBox(
                height:
                    11, // actually 16 but there is somehow more space between?
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Acceptance Criteria',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Icon(Icons.arrow_right)
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(241, 245, 249, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          'Run 1 Km',
                          style: TextStyle(fontSize: 12, color: themeColor3),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(241, 245, 249, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          'Every Day',
                          style: TextStyle(fontSize: 12, color: themeColor3),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(241, 245, 249, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          'GPS',
                          style: TextStyle(fontSize: 12, color: themeColor3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 10),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: themeColor3.withAlpha(100),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: themeColor3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 10),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: themeColor3.withAlpha(100),
                  ),
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  documentationButton(Icons.numbers),
                  documentationButton(Icons.notes),
                  documentationButton(Icons.gps_fixed),
                  documentationButton(Icons.camera_alt_outlined),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(child: Container()),
              Container(
                height: 53,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: const Center(
                    child: Text(
                  'End Challenge',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  documentationButton(IconData iconData) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Center(child: Icon(iconData)),
    );
  }
}
