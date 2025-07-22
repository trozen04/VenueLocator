import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../Services/venue_model.dart';
import '../Utils/colors.dart';
import '../Utils/distance_calculator.dart';
import '../Utils/sizes.dart';
import '../Utils/text_styles.dart';

class VenueCard extends StatelessWidget {
  final VenueModel venue;
  final double userLat;
  final double userLng;

  const VenueCard({
    super.key,
    required this.venue,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final distance = DistanceCalculator.calculateDistance(
      userLat,
      userLng,
      venue.latitude,
      venue.longitude,
    ).toStringAsFixed(2);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.venueDetails,
          arguments: venue,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.setHeight(12)),
        padding: EdgeInsets.all(SizeConfig.setWidth(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(venue.name, style: AppTextStyles.title),
            SizedBox(height: SizeConfig.setHeight(6)),
            Text('${venue.type} • $distance km away', style: AppTextStyles.bodyText),
            SizedBox(height: SizeConfig.setHeight(4)),
            Text(venue.address, style: AppTextStyles.bodyText),
          ],
        ),
      ),
    );
  }
}