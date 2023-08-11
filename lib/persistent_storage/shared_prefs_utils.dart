import '/persistent_storage/shared_prefs.dart';
import '/persistent_storage/shared_prefs_keys.dart';

class SharedPrefUtils {
  static Future<bool> setAccessToken(String value) =>
      SharedPrefs.setString(PreferenceKeys.accessToken, value);

  static String? getAccessToken() =>
      SharedPrefs.getString(PreferenceKeys.accessToken);

  static Future<bool> removeAccessToken(String value) =>
      SharedPrefs.remove(PreferenceKeys.accessToken);

  static Future<bool> setRefreshToken(String value) =>
      SharedPrefs.setString(PreferenceKeys.refreshToken, value);

  static String? getRefreshToken() =>
      SharedPrefs.getString(PreferenceKeys.refreshToken);

  static Future<bool> removeRefreshToken() =>
      SharedPrefs.remove(PreferenceKeys.refreshToken);

  static void removeAllTokens() {
    SharedPrefs.remove(PreferenceKeys.refreshToken);
    SharedPrefs.remove(PreferenceKeys.accessToken);
  }
}
