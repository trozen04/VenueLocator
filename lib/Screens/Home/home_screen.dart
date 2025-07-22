import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../Services/services.dart';
import '../../Services/venue_model.dart';
import '../../Utils/distance_calculator.dart';
import '../../Utils/sizes.dart';
import '../../Utils/text_styles.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/venue_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = SupabaseService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<VenueModel> venues = [];
  List<VenueModel> filteredVenues = [];
  List<VenueModel> visibleVenues = [];

  Position? userPosition;
  String searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        setState(() {
          venues = [];
          filteredVenues = [];
          visibleVenues = [];
          _isLoading = false;
        });
        return;
      }
    }

    userPosition = await Geolocator.getCurrentPosition();

    final fetchedVenues = await service.getVenues();
    developer.log('fetchedVenues = ${fetchedVenues.length}');

    fetchedVenues.sort((a, b) {
      final distA = DistanceCalculator.calculateDistance(
        userPosition!.latitude,
        userPosition!.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = DistanceCalculator.calculateDistance(
        userPosition!.latitude,
        userPosition!.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });

    setState(() {
      venues = fetchedVenues;
      filteredVenues = fetchedVenues;
      _updateVisibleVenues();
      _isLoading = false;
    });
  }


  void _filterVenues(String query) {
    setState(() {
      searchQuery = query;
      filteredVenues = venues
          .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _currentPage = 1;
      _updateVisibleVenues();
      _isLoading = false;
    });
  }

  void _updateVisibleVenues() {
    final int endIndex = (_currentPage * _itemsPerPage).clamp(0, filteredVenues.length);
    visibleVenues = filteredVenues.sublist(0, endIndex);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if ((_currentPage * _itemsPerPage) < filteredVenues.length && !_isLoadingMore) {
        setState(() => _isLoadingMore = true);
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _currentPage++;
            _updateVisibleVenues();
            _isLoadingMore = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Nearby Venues"),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : venues.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 80, color: Colors.grey),
              SizedBox(height: SizeConfig.setHeight(16)),
              const Text('No venues found nearby!', style: AppTextStyles.bodyText),
              SizedBox(height: SizeConfig.setHeight(12)),
              const Text(
                'Please make sure location is enabled and try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText,
              ),
              SizedBox(height: SizeConfig.setHeight(20)),
              ElevatedButton(
                onPressed: _fetchData,
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: _filterVenues,
                decoration: InputDecoration(
                  hintText: 'Search venues...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(SizeConfig.setWidth(16)),
                itemCount: visibleVenues.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i < visibleVenues.length) {
                    return VenueCard(
                      venue: visibleVenues[i],
                      userLat: userPosition!.latitude,
                      userLng: userPosition!.longitude,
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
