import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watantelecom/controllers/iso_code_controller.dart';
import 'package:watantelecom/controllers/language_controller.dart';

class ChangeLanguageScreen extends StatefulWidget {
  ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final IscoCodeController iscoCodeController = Get.put(IscoCodeController());

  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: Obx(
        () => iscoCodeController.isLoading.value == false
            ? ListView.builder(
                itemCount: iscoCodeController
                    .allisoCodeData.value.data!.languages.length,
                itemBuilder: (context, index) {
                  final data = iscoCodeController
                      .allisoCodeData.value.data!.languages[index];
                  return languageBox(
                    lanName: data.languageName,
                    onpressed: () {
                      languageController
                          .fetchlanData(data.language_code.toString());
                      setState(() {});
                    },
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      )),
    );
  }
}

class languageBox extends StatelessWidget {
  const languageBox({
    super.key,
    this.lanName,
    this.onpressed,
  });
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
              child: Text(
            lanName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }
}
