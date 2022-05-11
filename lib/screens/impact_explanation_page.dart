import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/common/widgets.dart';
import 'package:ecoscore/gen/colors.gen.dart';
import 'package:ecoscore/translations/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImpactExplanationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translation.current.whyEatingBetter),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translation.current.foodImpactTitle,
                style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(32),
              _ImpactInfo(
                explanation: Translation.current.greenhouseGasImpact,
                percent: 30,
                displayNumberOnRight: false,
              ),
              const _ImpactInfoDivider(),
              _ImpactInfo(
                explanation: Translation.current.meatGreenhouseGasImpact,
                percent: 60,
                displayNumberOnRight: true,
              ),
              const _ImpactInfoDivider(),
              _ImpactInfo(
                explanation: Translation.current.landImpact,
                percent: 50,
                displayNumberOnRight: false,
              ),
              const _ImpactInfoDivider(),
              _ImpactInfo(
                explanation: Translation.current.speciesImpact,
                percent: 86,
                displayNumberOnRight: true,
              ),
              const _ImpactInfoDivider(),
              _ImpactInfo(
                explanation: Translation.current.freshwaterImpact,
                percent: 70,
                displayNumberOnRight: false,
              ),
              const Gap(48),
              Text(
                Translation.current.improvementTitle,
                style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              Text(
                Translation.current.improvementExplanation,
                style: context.textTheme.bodyText1,
              ),
              const Gap(48),
              Text(
                Translation.current.sources,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: context.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              const _Source(
                name: 'OurWorldInData - Environmental impacts of food production',
                link: 'https://ourworldindata.org/environmental-impacts-of-food',
              ),
              const Gap(16),
              const _Source(
                name: 'OurWorldInData - Greenhouse gas emissions of food',
                link: 'https://ourworldindata.org/greenhouse-gas-emissions-food',
              ),
              const Gap(16),
              const _Source(
                name: 'The Guardian - Meat greenhouse gas emissions',
                link: 'https://www.theguardian.com/environment/2021/sep/13/meat-greenhouses-gases-food-production-study',
              ),
              const Gap(16),
              const _Source(
                name: 'UNEP - Biodiversity loss',
                link:
                    'https://www.unep.org/news-and-stories/press-release/our-global-food-system-primary-driver-biodiversity-loss',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactInfoDivider extends StatelessWidget {
  const _ImpactInfoDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Gap(8),
        Divider(),
        Gap(8),
      ],
    );
  }
}

class _ImpactInfo extends StatelessWidget {
  const _ImpactInfo({
    Key? key,
    required this.explanation,
    required this.percent,
    required this.displayNumberOnRight,
  }) : super(key: key);

  final String explanation;
  final int percent;
  final bool displayNumberOnRight;

  @override
  Widget build(BuildContext context) {
    final number = Center(
      child: Text('$percent%', style: context.textTheme.headline2?.copyWith(color: ColorName.primary.shade400)),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (!displayNumberOnRight) number,
          if (!displayNumberOnRight) const Gap(32),
          Expanded(
            child: Text(
              explanation,
              style: context.textTheme.bodyText1,
            ),
          ),
          if (displayNumberOnRight) const Gap(32),
          if (displayNumberOnRight) number,
        ],
      ),
    );
  }
}

class _Source extends StatelessWidget {
  const _Source({
    Key? key,
    required this.name,
    required this.link,
  }) : super(key: key);

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: ColorName.primary[50],
      ),
      child: Tap(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () async {
          try {
            await launchUrlString(link);
          } catch (_) {
            final snackBar = SnackBar(content: Text(Translation.current.browserOpeningError));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: context.textTheme.subtitle2?.copyWith(
                    color: ColorName.primary[900],
                  ),
                ),
              ),
              const Gap(16),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorName.primary,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
