// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  TransactionModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  final List<ResellerBalanceTransaction> resellerBalanceTransactions;

  Data({
    required this.resellerBalanceTransactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        resellerBalanceTransactions: List<ResellerBalanceTransaction>.from(
            json["reseller_balance_transactions"]
                .map((x) => ResellerBalanceTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reseller_balance_transactions": List<dynamic>.from(
            resellerBalanceTransactions.map((x) => x.toJson())),
      };
}

class ResellerBalanceTransaction {
  final int? id;
  final String? resellerId;
  final String? amount;
  final dynamic? currencyCode;
  final String? currencyId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final Reseller? reseller;
  final Currency? currency;
  final Order? order;

  ResellerBalanceTransaction({
    this.id,
    this.resellerId,
    this.amount,
    this.currencyCode,
    this.currencyId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.reseller,
    this.currency,
    this.order,
  });

  factory ResellerBalanceTransaction.fromJson(Map<String, dynamic> json) =>
      ResellerBalanceTransaction(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        amount: json["amount"] == null ? null : json["amount"],
        currencyCode:
            json["currency_code"] == null ? null : json["currency_code"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        reseller: json["reseller"] == null
            ? null
            : Reseller.fromJson(json["reseller"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "amount": amount,
        "currency_code": currencyCode,
        "currency_id": currencyId,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "reseller": reseller!.toJson(),
        "currency": currency!.toJson(),
        "order": order!.toJson(),
      };
}

class Currency {
  final int? id;
  final CurrencyName? name;
  final String? code;
  final Symbol? symbol;
  final String? exchangeRatePerUsd;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name:
            json["name"] == null ? null : currencyNameValues.map[json["name"]],
        code: json["code"] == null ? null : json["code"],
        symbol:
            json["symbol"] == null ? null : symbolValues.map[json["symbol"]],
        exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
            ? null
            : json["exchange_rate_per_usd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": currencyNameValues.reverse[name],
        "code": code,
        "symbol": symbolValues.reverse[symbol],
        "exchange_rate_per_usd": exchangeRatePerUsd,
      };
}

enum CurrencyName { AFGHANI, TOMAN }

final currencyNameValues =
    EnumValues({"Afghani": CurrencyName.AFGHANI, "Toman": CurrencyName.TOMAN});

enum Symbol { AFN, TMN }

final symbolValues = EnumValues({"AFN": Symbol.AFN, "TMN": Symbol.TMN});

class Order {
  final int? id;
  final String? resellerId;
  final String? rechargebleAccount;
  final Bundle? bundle;
  final String? transactionId;
  final String? isPaid;
  final String? status;
  final String? rejectReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  Order({
    this.id,
    this.resellerId,
    this.rechargebleAccount,
    this.bundle,
    this.transactionId,
    this.isPaid,
    this.status,
    this.rejectReason,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        rechargebleAccount: json["rechargeble_account"] == null
            ? null
            : json["rechargeble_account"],
        bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        isPaid: json["is_paid"] == null ? null : json["is_paid"],
        status: json["status"] == null ? null : json["status"],
        rejectReason:
            json["reject_reason"] == null ? null : json["reject_reason"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "rechargeble_account": rechargebleAccount,
        "bundle": bundle!.toJson(),
        "transaction_id": transactionId,
        "is_paid": isPaid,
        "status": status,
        "reject_reason": rejectReason,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Bundle {
  final int? id;
  final String? bundleCode;
  final String? serviceId;
  final String? bundleTitle;
  final String? bundleDescription;
  final String? validityType;
  final String? adminBuyingPrice;
  final String? buyingPrice;
  final String? sellingPrice;
  final String? bundleImageUrl;
  final String? currencyId;
  final dynamic? expiredDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final Currency? preferedCurrency;
  final Service? service;
  final Currency? currency;

  Bundle({
    this.id,
    this.bundleCode,
    this.serviceId,
    this.bundleTitle,
    this.bundleDescription,
    this.validityType,
    this.adminBuyingPrice,
    this.buyingPrice,
    this.sellingPrice,
    this.bundleImageUrl,
    this.currencyId,
    this.expiredDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.preferedCurrency,
    this.service,
    this.currency,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        id: json["id"] == null ? null : json["id"],
        bundleCode: json["bundle_code"] == null ? null : json["bundle_code"],
        serviceId: json["service_id"] == null ? null : json["service_id"],
        bundleTitle: json["bundle_title"] == null ? null : json["bundle_title"],
        bundleDescription: json["bundle_description"] == null
            ? null
            : json["bundle_description"],
        validityType:
            json["validity_type"] == null ? null : json["validity_type"],
        adminBuyingPrice: json["admin_buying_price"] == null
            ? null
            : json["admin_buying_price"],
        buyingPrice: json["buying_price"] == null ? null : json["buying_price"],
        sellingPrice:
            json["selling_price"] == null ? null : json["selling_price"],
        bundleImageUrl:
            json["bundle_image_url"] == null ? null : json["bundle_image_url"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        expiredDate: json["expired_date"] == null ? null : json["expired_date"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        preferedCurrency: json["prefered_currency"] == null
            ? null
            : Currency.fromJson(json["prefered_currency"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bundle_code": bundleCode,
        "service_id": serviceId,
        "bundle_title": bundleTitle,
        "bundle_description": bundleDescription,
        "validity_type": validityType,
        "admin_buying_price": adminBuyingPrice,
        "buying_price": buyingPrice,
        "selling_price": sellingPrice,
        "bundle_image_url": bundleImageUrl,
        "currency_id": currencyId,
        "expired_date": expiredDate,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "prefered_currency": preferedCurrency!.toJson(),
        "service": service!.toJson(),
        "currency": currency!.toJson(),
      };
}

class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final ServiceCategory? serviceCategory;
  final Company? company;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.serviceCategory,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        companyId: json["company_id"] == null ? null : json["company_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        serviceCategory: json["service_category"] == null
            ? null
            : ServiceCategory.fromJson(json["service_category"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "company_id": companyId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "service_category": serviceCategory!.toJson(),
        "company": company!.toJson(),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final String? countryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.countryId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
        "country_id": countryId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class ServiceCategory {
  final int? id;
  final String? categoryName;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  ServiceCategory({
    this.id,
    this.categoryName,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"] == null ? null : json["id"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        type: json["type"] == null ? null : json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "type": type,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Reseller {
  final int? id;
  final String? userId;
  final dynamic? parentId;
  final ResellerUuid? uuid;
  final ResellerNameEnum? resellerName;
  final String? contactName;
  final String? resellerType;
  final dynamic? emailVerifiedAt;
  final AccountPassword? accountPassword;
  final String? personalPin;
  final dynamic? rememberToken;
  final String? profileImageUrl;
  final Email? email;
  final String? phone;
  final String? countryId;
  final String? provinceId;
  final dynamic? districtsId;
  final String? isResellerVerified;
  final String? status;
  final String? balance;
  final String? loanBalance;
  final dynamic? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final User? user;

  Reseller({
    this.id,
    this.userId,
    this.parentId,
    this.uuid,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.emailVerifiedAt,
    this.accountPassword,
    this.personalPin,
    this.rememberToken,
    this.profileImageUrl,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.balance,
    this.loanBalance,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        uuid:
            json["uuid"] == null ? null : resellerUuidValues.map[json["uuid"]],
        resellerName: json["reseller_name"] == null
            ? null
            : resellerNameEnumValues.map[json["reseller_name"]],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        resellerType:
            json["reseller_type"] == null ? null : json["reseller_type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : json["email_verified_at"],
        accountPassword: json["account_password"] == null
            ? null
            : accountPasswordValues.map[json["account_password"]],
        personalPin: json["personal_pin"] == null ? null : json["personal_pin"],
        rememberToken:
            json["remember_token"] == null ? null : json["remember_token"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        email: json["email"] == null ? null : emailValues.map[json["email"]],
        phone: json["phone"] == null ? null : json["phone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtsId: json["districts_id"] == null ? null : json["districts_id"],
        isResellerVerified: json["is_reseller_verified"] == null
            ? null
            : json["is_reseller_verified"],
        status: json["status"] == null ? null : json["status"],
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "parent_id": parentId,
        "uuid": resellerUuidValues.reverse[uuid],
        "reseller_name": resellerNameEnumValues.reverse[resellerName],
        "contact_name": contactNameValues.reverse[contactName],
        "reseller_type": resellerType,
        "email_verified_at": emailVerifiedAt,
        "account_password": accountPasswordValues.reverse[accountPassword],
        "personal_pin": personalPin,
        "remember_token": rememberToken,
        "profile_image_url": profileImageUrl,
        "email": emailValues.reverse[email],
        "phone": phone,
        "country_id": countryId,
        "province_id": provinceId,
        "districts_id": districtsId,
        "is_reseller_verified": isResellerVerified,
        "status": status,
        "balance": balance,
        "loan_balance": loanBalance,
        "fcm_token": fcmToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user!.toJson(),
      };
}

enum AccountPassword {
  THE_2_Y_10_SZX6_COPDO2_HW_G_C8_D_CC_XC_Q_GVE_LNA_QX8_C4_U_Y9_FPK_JS_MX_NIXE_HU_IU
}

final accountPasswordValues = EnumValues({
  "\u00242y\u002410\u0024szx6copdo2HwG/C8dCCXc.QGveLnaQX8c4uY9FPKJs.MxNixeHuIu":
      AccountPassword
          .THE_2_Y_10_SZX6_COPDO2_HW_G_C8_D_CC_XC_Q_GVE_LNA_QX8_C4_U_Y9_FPK_JS_MX_NIXE_HU_IU
});

enum ContactName { RESELLER }

final contactNameValues = EnumValues({"Reseller": ContactName.RESELLER});

enum Email { TEST_RESELLER_GMAIL_COM }

final emailValues =
    EnumValues({"test.reseller@gmail.com": Email.TEST_RESELLER_GMAIL_COM});

enum ResellerNameEnum { TEST_RESELLER }

final resellerNameEnumValues =
    EnumValues({"Test Reseller": ResellerNameEnum.TEST_RESELLER});

class User {
  final int? id;
  final UserUuid? uuid;
  final ResellerNameEnum? name;
  final Email? email;
  final String? phone;
  final String? userType;
  final dynamic? emailVerifiedAt;
  final String? currencyPreferenceCode;
  final String? currencyPreferenceId;
  final dynamic? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final Currency? currency;

  User({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.emailVerifiedAt,
    this.currencyPreferenceCode,
    this.currencyPreferenceId,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.currency,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        uuid: json["uuid"] == null ? null : userUuidValues.map[json["uuid"]],
        name: json["name"] == null
            ? null
            : resellerNameEnumValues.map[json["name"]],
        email: json["email"] == null ? null : emailValues.map[json["email"]],
        phone: json["phone"] == null ? null : json["phone"],
        userType: json["user_type"] == null ? null : json["user_type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : json["email_verified_at"],
        currencyPreferenceCode: json["currency_preference_code"] == null
            ? null
            : json["currency_preference_code"],
        currencyPreferenceId: json["currency_preference_id"] == null
            ? null
            : json["currency_preference_id"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": userUuidValues.reverse[uuid],
        "name": resellerNameEnumValues.reverse[name],
        "email": emailValues.reverse[email],
        "phone": phone,
        "user_type": userType,
        "email_verified_at": emailVerifiedAt,
        "currency_preference_code": currencyPreferenceCode,
        "currency_preference_id": currencyPreferenceId,
        "fcm_token": fcmToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "currency": currency!.toJson(),
      };
}

enum UserUuid { E10_BN_DDPV }

final userUuidValues = EnumValues({"E10BnDDPV": UserUuid.E10_BN_DDPV});

enum ResellerUuid { AM_I_TSWA_TV }

final resellerUuidValues = EnumValues({"AmITswaTv": ResellerUuid.AM_I_TSWA_TV});

// enum Status { CREDIT, DEBIT }

// final statusValues =
//     EnumValues({"credit": Status.CREDIT, "debit": Status.DEBIT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
