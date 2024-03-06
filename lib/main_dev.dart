import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'flavors.dart';

import 'main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.dev;
  await dotenv.load(fileName: '.env.development');
  await runner.main();
}