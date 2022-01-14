import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'recommandation/reco.dart';

DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

CollectionReference service = FirebaseFirestore.instance.collection('Service');
CollectionReference company = FirebaseFirestore.instance.collection('Company');
CollectionReference typeserv = FirebaseFirestore.instance.collection('Type');
FirebaseApp ?instance;

Future<void> intializeDatabase() async {
  if (instance == null) {
    WidgetsFlutterBinding.ensureInitialized();
    instance = await Firebase.initializeApp();
  }
}

Future<String> getIdComp(String nomComp) async {
  nomComp = nomComp;
  dynamic d = '';
  try {
    dynamic value = await company.where("nom", isEqualTo: nomComp).get();
    d = value.docs.first.id;
    print("laal $d");
  } catch (e) {
    print(e);
  }
  return d.toString();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getCompTypeService(
    String nomComp, String id) async* {
  print("id : '$id'");
  yield* company.doc(id).collection('Type_service').snapshots();
}

List<TypeService> toTypeServiceList(
    QuerySnapshot<Map<String, dynamic>> element) {
  return element.docs.map((e) {
    print(e.get('nom'));
    return TypeService(nom: e.get('nom'), id: e.id.toString());
  }).toList();
}

/*------------------------------------*/
Stream<List<Service>> getCompService(TypeService type) async* {
  yield* company
      .doc(type.idComp)
      .collection('Type_service')
      .doc(type.id)
      .collection("Service")
      .snapshots()
      .map((event) {
    return event.docs.map((e) {
      print(e.data());
      return Service(
          nom: e.data()['nom'] ?? "Unknown",
          idComp: type.idComp,
          idType: type.id,
          id: e.id.toString(),
          prix: e.data()['prix'] ?? "Unknown",
          code: e.data()['code'] ?? "Unknown",
          duree: e.data()['date'] ?? "Unknown");
    }).toList();
  });
}

/*---------------------------------------------------*/
Stream<List<Service>> getrecomandedServices(String nomsim) async* {
  List<Service> ls = await sortedListService(nomsim);
  if (ls.isEmpty || ls == null) return;
  List<String> serviceids = [];
  for (Service s in ls) {
    serviceids.add(s.id!);
    print('-----------id-----------');
    print('-${s.id}-');
  }

  yield* FirebaseFirestore.instance
      .collectionGroup('Service')
      .snapshots()
      .map((event) {
    return event.docs.map((e) {
      print(e.data());
      if (serviceids.contains(e.id.toString())) {
        return Service(
            nom: e.data()['nom'] ?? "Unknown",
            idComp: ls.first.idComp,
            id: e.id.toString(),
            prix: e.data()['prix'] ?? "Unknown",
            code: e.data()['code'] ?? "Unknown",
            duree: e.data()['date'] ?? "Unknown");
      }
    }).skipWhile((value) {
    return  value==null;
    } ).toList() as List<Service>;
  });
}
/*
Future<List<Service>> getrecomandedServices(String id) async {
  List<Service> l = await sortedListService(id);
  List<Service> mylist = [];
  int i = 0;
  Service temp;

  for (Service s in l) {
    temp = await getservice(s);
    print(temp.nom);
    if (temp != null) {
      mylist.add(temp);
      i++;
    }
    if (i == 5) break;
  }

  return mylist;
}

---------------------------------------------------
Stream<Service> getservice(Service s) async* {
  yield* company
      .doc(s.idComp)
      .collection('Type_service')
      .doc(s.idType)
      .collection("Service")
      .doc(s.id)
      .snapshots()
      .map((event) {
    s.code = event.data()['code'] ?? "Unknown";
    s.prix = event.data()['Prix'] ?? "Unknown";
    s.duree = event.data()['date'] ?? "Unknown";
    s.nom = event.data()['nom'] ?? "unknown";
    return s;
  });
}

Stream<List<Service>> getrecomandedServices(String id) async* {
  List<Service> l = await sortedListService(id);
  List<Service> mylist;
  Service s;
  for (Service s in l) {
    s = await getservice(s).first;
    mylist.add(s);
    yield mylist;
  }
}
*/
