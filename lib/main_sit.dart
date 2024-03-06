import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavors.dart';

import 'main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.sit;
  await dotenv.load(fileName: '.env.sit');
  await runner.main();
}
