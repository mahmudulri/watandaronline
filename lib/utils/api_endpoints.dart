class ApiEndPoints {
  static String baseUrl =
      "https://app.api.wadaron.v1.24.watandaronline.com/api/reseller/";
  static String languageUrl =
      "https://app.api.wadaron.v1.24.watandaronline.com/api/locale/";

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
}
