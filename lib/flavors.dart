enum Flavor {
  dev,
  sit,
  uat,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'InvestNation Dev';
      case Flavor.sit:
        return 'InvestNation SIT';
      case Flavor.uat:
        return 'InvestNation UAT';
      case Flavor.prod:
        return 'InvestNation';
      default:
        return 'title';
    }
  }

}
