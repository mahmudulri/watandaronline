class ApiEndPoints {
  // static String baseUrl =
  //     "https://app-api-wadaron-v2-hr.watandaronline.com/api/reseller/";

  static String baseUrl =
      "https://api-vpro-hetz-25.watandaronline.com/api/reseller/";

  static String languageUrl =
      "https://api-vpro-hetz-25.watandaronline.com/api/locale/";

  static OtherendPoints otherendpoints = OtherendPoints();
}

class OtherendPoints {
  final String loginIink = "login";
  final String signUp = "register";
  final String dashboard = "dashboard";
  final String countrylist = "countries";
  final String subreseller = "sub-resellers";
  final String transactions = "balance_transactions";
  final String subresellerDetails = "sub-resellers/";
  final String servicecategories = "service_categories";
  final String services = "services";
  final String currency = "currency";
  final String province = "provinces";
  final String district = "districts";
  final String languages = "languages";
  final String sliders = "advertisements";
  final String customrecharge = "custom-recharge";
}
