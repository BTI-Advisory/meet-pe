import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resources/resources.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/experience_model.dart';

class AllReviewsPage extends StatefulWidget {
  const AllReviewsPage({super.key, required this.reviews, required this.reviewsAVG});

  final List<Reviews> reviews;
  final String reviewsAVG;

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EpAppBar(
        title: AppLocalizations.of(context)!.all_reviews_community_text,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                      widget.reviewsAVG,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black.withOpacity(0.5))
                  ),
                  SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                  SvgPicture.asset('images/match.svg', color: AppResources.colorVitamine, width: 16, height: 16),
                  SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                  Text(
                      "(${widget.reviews.length} ${AppLocalizations.of(context)!.reviews_text})",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black.withOpacity(0.5))
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                children: widget.reviews.map((review) {
                  return ReviewsItems(
                    image: review.voyageur.profilePath,
                    name: review.voyageur.name,
                    note: "${review.note}",
                    date: review.createdAt,
                    message: review.message ?? "",
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewsItems extends StatelessWidget {
  final String image;
  final String name;
  final String note;
  final String date;
  final String message;

  const ReviewsItems({
    Key? key,
    required this.image,
    required this.name,
    required this.note,
    required this.date,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
