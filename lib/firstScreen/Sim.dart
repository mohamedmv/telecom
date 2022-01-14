import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sim_info/sim_info.dart';
import '../database.dart';
import 'package:mobile_number/mobile_number.dart';

// Future<Map<String, dynamic>> getSimInfo() async {
//   List<List<String>> sims = [];
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   PermissionStatus state = await Permission.phone.status;
//   if (!state.isGranted) {
//     bool isGranted = await Permission.phone.request().isGranted;
//     if (!isGranted) return {'sims': sims, 'per': false};
//   }
//   SimData simdata = await SimDataPlugin.getSimData();
//   var v = SimDataPlugin.channel_name;
//   List<SimCard> cards = simdata.cards;
//   String nom;
//   print("---------------------------");
//   print(cards.length);
//   print(v);
//   for (SimCard i in cards) {
//     nom = i.carrierName;

//     print(nom);
//     print("---------------------------");
//     String id =
//         await getIdComp(nom == "T-Mobile" || nom == "Android" ? "MATTEL" : nom);

//     sims.add([nom, id]);
//   }

//   return {'sims': sims, 'per': true};
// }

// Future<int> getSimInfo() async {
//   bool isPermissionGranted = await MobileNumber.hasPhonePermission;
//   if (!isPermissionGranted) {
//     await MobileNumber.requestPhonePermission;
//     await [Permission.phone].request();
//     isPermissionGranted = await MobileNumber.hasPhonePermission;
//     if (!isPermissionGranted) {
//       await openAppSettings();
//     }
//   }
//   return 0;
// }

List<String> companies = ["mattel", "mauritel", "chinguitel"];
Future<Map<String, dynamic>> getSimInfo() async {
  List<List<String>> sims = [];
  await intializeDatabase();

  if (Platform.isIOS) {
    String nomsim = await SimInfo.getCarrierName;
    String id = await getIdComp(nomsim.toLowerCase());
    sims.add([nomsim, id]);
    return {'sims': sims, 'per': true};
  }
  if (Platform.isAndroid) {
    PermissionStatus state = await Permission.phone.status;
    if (!state.isGranted) {
      bool isGranted = await Permission.phone.request().isGranted;
      if (!isGranted) return {'sims': sims, 'per': false};
    }

    List<SimCard> simCards = await MobileNumber.getSimCards;
    String nom = '';
    for (int i = 0; i < simCards.length; i++) {
      nom = simCards[i].carrierName.toLowerCase();

      String id = await getIdComp(
          nom == "T-Mobile" || nom == "Android" ? "mattel" : nom);
      print("-----------------------------");
      print(nom);
      print("id : $id");
      sims.add([nom, id]);
    }
    if (sims.isEmpty) {
      String id;
      for (String company in companies) {
        id = "";
        id = await getIdComp(
            nom == "T-Mobile" || nom == "Android" ? "mattel" : nom);
        sims.add([company, id]);
      }
    }
    return {'sims': sims, 'per': true};
  }
  return {};
}
