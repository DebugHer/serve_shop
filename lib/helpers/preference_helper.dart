
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper{
  SharedPreferences prefs;
  Future isCached() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cached', true);
  }

  Future<bool> getIsCached() async{
    prefs = await SharedPreferences.getInstance();
    bool isCached = prefs.getBool('cached') ?? false;
    return isCached;
  }
}
