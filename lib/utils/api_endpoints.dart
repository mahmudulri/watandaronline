class ApiEndPoints {
  // static String baseUrl = "https://app-api-vpro-tt.taktelcom.com/api/reseller/";

  static String baseUrl =
      "https://api-vpro-hetz-25.watandaronline.com/api/reseller/";

  // static String languageUrl =
  //     "https://api-vpro-hetz-25.watandaronline.com/api/locale/";

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
  final String hawalalist = "hawala-orders";
  final String commsiongrouplist = "sub-reseller-commission-group";
  final String branch = "hawala-branches";
  final String sellingprice = "reseller-customer-pricing";
  final String createselling = "reseller-customer-pricing";
  final String hawalacurrency = "hawala-currency";
  final String helparticle = "help-articles";
  final String paymentmethod = "payment-methods";
  final String paymenttypes = "payment-types";
  final String loanbalance = "reseller-balances";
  final String earningtransfer = "earning-transfer";
  final String companies = "companies";
}
