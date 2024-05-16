import 'package:flutter/material.dart';
import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/_widgets.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/web_view_container.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'FAQ & Assistance',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FAQ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocHelp('FAQ Voyageurs', 'https://meetpe.fr/FAQVoyageurs'),
                  blocHelp('FAQ Guides', 'https://meetpe.fr/FAQGuides'),
                  blocHelp('FAQ Photos', 'https://meetpe.fr/FAQPhotos'),
                  blocHelp('Customer Expériences', 'https://meetpe.fr/Customer_Exp%C3%A9riences'),
                  const SizedBox(height: 15),
                  Text(
                    'Assistance',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Tu as une question concernant le fonctionnement de Meetpe ? Tu peux nous contacter via le formulaire suivant :',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocHelp('Nous contacter', 'https://meetpe.fr/privacy'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blocHelp(String title, String url) {
    return InkWell(
      onTap: () {
        navigateTo(context, (_) => WebViewContainer(webUrl: url));
      },
      child: Column(
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF797979)),
              ),
              Image.asset('images/chevron_right.png',
                  width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            width: 390,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorImputStroke,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
