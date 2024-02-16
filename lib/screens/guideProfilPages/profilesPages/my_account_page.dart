import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mon Compte',
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
                    'Informations de connexion',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 32),
                  accountRowDefault('Nom & prénom', ''),
                  accountRowDefault('Numéro de téléphone', '+xx xx xx xx xx 92'),
                  accountRowDefault('e-mail', 'sofia.martins@cognac.com'),
                  accountRowDefault('mot de passe', '********'),
                  accountRowDefault('adresse', ''),
                  accountRowDefault('sécurité & vie privée', ''),
                  const SizedBox(height: 20),
                  Text(
                    'Informations bancaires',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 17),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informations de compte bancaire',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 73,
                            height: 21,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFECAB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'à compléter',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xFFC89C00)),
                            ),
                          ),
                          Image.asset('images/chevron_right.png',
                              width: 27, height: 27, fit: BoxFit.fill),
                        ],
                      ),
                    ],
                  ),
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
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informations de paiement',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                      ),
                      Image.asset('images/chevron_right.png',
                          width: 27, height: 27, fit: BoxFit.fill),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                  child: Row(
                    children: [
                      Image.asset('images/bank_logo.png'),
                      const SizedBox(width: 21),
                      Text(
                        'xxxx xxxx xxxx 792',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorDark),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 42),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Supprimer mon compte',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorGray30)
                    ),
                ),
                const SizedBox(height: 65),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget accountRowDefault(String name, String? info) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
            ),
            Row(
              children: [
                Text(
                  info ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorDark),
                ),
                Image.asset('images/chevron_right.png',
                    width: 27, height: 27, fit: BoxFit.fill),
              ],
            ),
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
    );
  }
}
