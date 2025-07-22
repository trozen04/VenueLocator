import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:venues_locater/Services/venue_model.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<VenueModel>> getVenues() async {
    final response = await client.from('venues').select();
    final data = List<Map<String, dynamic>>.from(response);
    return data.map((json) => VenueModel.fromJson(json)).toList();
  }
}
