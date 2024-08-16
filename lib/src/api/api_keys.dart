import 'package:get_it/get_it.dart';
import 'api_keys.dart'; // Import the file containing your API key

final GetIt getIt = GetIt.instance;

const String apiKey = '88f78e957f44e559b55731e4216ea2a3';

void setupInjection() {
  // Register the API key
  getIt.registerSingleton<String>(apiKey);
}
