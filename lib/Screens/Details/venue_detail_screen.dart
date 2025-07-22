import 'package:flutter/material.dart';
import '../../Services/venue_model.dart';
import '../../Utils/sizes.dart';
import '../../Utils/text_styles.dart';
import '../../Widgets/custom_app_bar.dart';

class VenueDetailScreen extends StatelessWidget {
  final VenueModel venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: CustomAppBar(title: venue.name, showBack: true),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${venue.type}', style: AppTextStyles.title),
            SizedBox(height: SizeConfig.setHeight(12)),
            Text('Address:', style: AppTextStyles.title),
            Text(venue.address, style: AppTextStyles.bodyText),
            SizedBox(height: SizeConfig.setHeight(12)),
            Text('Coordinates:', style: AppTextStyles.title),
            Text(
              'Lat: ${venue.latitude}, Lng: ${venue.longitude}',
              style: AppTextStyles.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
