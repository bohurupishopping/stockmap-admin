import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Supabase Auth
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed');
      }

      // Get user profile from profiles table
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('user_id', response.user!.id)
          .single();

      final userProfile = UserProfile.fromJson(profileData);

      // Check if user has 'admin' role
      if (userProfile.role != UserRole.admin) {
        // Sign out the user if they don't have admin role
        await _supabase.auth.signOut();
        throw Exception('Access denied. Only admin users can access this app.');
      }

      return userProfile;
    } on AuthException catch (e) {
      throw Exception('Authentication failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<UserProfile?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      final userProfile = UserProfile.fromJson(profileData);

      // Check if user still has 'admin' role
      if (userProfile.role != UserRole.admin) {
        await _supabase.auth.signOut();
        return null;
      }

      return userProfile;
    } catch (e) {
      return null;
    }
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
