import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meet_pe/screens/travelersPages/reservation_page.dart';

import '../models/experience_model.dart';
import '../resources/resources.dart';
import '../utils/_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsItemWidget extends StatelessWidget {
  final List<Reviews> reviews;

  const ReviewsItemWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(right: 13),
            child: ReviewsItem(
              image: review.voyageur.profilePath,
              name: review.voyageur.name,
              note: "${review.note}",
              date: review.createdAt,
              message: review.message ?? "",
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ReviewsItem extends StatelessWidget {
  final String image;
  final String name;
  final String note;
  final String date;
  final String message;

  const ReviewsItem({
    Key? key,
    required this.image,
    required this.name,
    required this.note,
    required this.date,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      height: 154,
      decoration: BoxDecoration(
        color: AppResources.colorWhite,
        border: Border.all(color: AppResources.colorImputStroke),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: ResponsiveSize.calculateWidth(32, context),
                  height: ResponsiveSize.calculateHeight(32, context),
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(32, context)),
                    ),
                  ),
                ),
                SizedBox(width: 9),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (index) => SvgPicture.asset(
                          'images/match.svg',
                          color: index < int.parse(note) ? AppResources.colorVitamine : AppResources.colorGray,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppResources.colorDark,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          AppResources.formatterDate.format(DateTime.parse(date)),
                          //formatDateFrench(date),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Color(0xFF898989), fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
