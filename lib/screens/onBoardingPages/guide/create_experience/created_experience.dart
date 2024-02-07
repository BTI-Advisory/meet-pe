import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';

class CreatedExperience extends StatefulWidget {
  const CreatedExperience({super.key});

  @override
  State<CreatedExperience> createState() => _CreatedExperienceState();
}

class _CreatedExperienceState extends State<CreatedExperience> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEDD8BE), AppResources.colorWhite],
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: AppResources.colorVitamine,
                size: 55,
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(27, context)),
              Text(
                'Expérience créée 🎉 !',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppResources.colorGray100, fontSize: 32),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
              Text(
                'Nous vérifions ton expérience au plus vite, cela peut prendre jusqu’à 72h. Tu recevras une notification dès qu’elle sera disponible pour les voyageurs!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

