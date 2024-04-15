import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ChallengeTotalPercentageComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isSearch;

  const ChallengeTotalPercentageComponent(
      {super.key, required this.challenge, this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.all(0),
        color: isSearch
            ? Colors.transparent
            : (challenge.isFailed() ? red : green),
        // textColor: Colors.black,
        text: isSearch
            ? ''
            : '${DesignUtil.doubleAsInt((challenge.getCurrentPercentage() * 100).roundToDouble())} %');
  }
}
