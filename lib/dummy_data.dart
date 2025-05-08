import 'dart:convert';

import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:aviato_finance/utils/Providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

/* 
List<Map<String, dynamic>> InOutUserData2=[
  {
    "name": "Salary",
    "amount": 1500,
    "date": "2025-03-01",
    "tags": ["job", "monthly"]
  },
  {
    "name": "Grocery Shopping",
    "amount": -200,
    "date": "2025-03-02",
    "tags": ["food", "supermarket"]
  },
  {
    "name": "Product Sale",
    "amount": 350,
    "date": "2025-03-03",
    "tags": ["business", "sales"]
  },
  {
    "name": "Apartment Rent",
    "amount": -800,
    "date": "2025-03-04",
    "tags": ["housing", "rent"]
  },
  {
    "name": "Freelance Project",
    "amount": 500,
    "date": "2025-03-05",
    "tags": ["freelance", "side job"]
  },
  {
    "name": "Freelance Payment",
    "amount": 250,
    "date": "2025-03-18",
    "tags": ["freelance", "payment"]
  },
  {
    "name": "Restaurant Dinner",
    "amount": -50,
    "date": "2025-03-18",
    "tags": ["food", "dining"]
  },
  {
    "name": "Book Sale",
    "amount": 100,
    "date": "2025-03-18",
    "tags": ["business", "sales"]
  }
]; */
ValueNotifier<List<Map<String, dynamic>>> InOutUserData = ValueNotifier([{
      "name": "_",
      "amount": 0,
      "date": "2000-01-01",
      "tags": ["_"]
    }]);

  AuthService authS = AuthService();
Future<void> getData(BuildContext context) async {
  var userEmail = authS.currentUser?.email;
  CollectionReference data = FirebaseFirestore.instance.collection('InOutUserData');
  await data.get().then((snapshot) {
    final List<Map<String, dynamic>> allData = [];
    for (var doc in snapshot.docs) {
      if (userEmail == doc.id){
        Map<String, dynamic> decoded = doc.data() as Map<String, dynamic>;
        allData.addAll(List<Map<String, dynamic>>.from(decoded['Data']));
      }
    }
    Provider.of<InOutDataProvider>(context, listen: false).setData(allData);
  }).catchError((error) {
    print("Error fetching: $error");
  });
}


Future<void> updateData(String userDocId, int indexToUpdate, String newName) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('InOutUserData');
  
  try {
    DocumentSnapshot doc = await collection.doc(userDocId).get();
    if (doc.exists) {
      List<dynamic> dataList = (doc.data() as Map<String, dynamic>)['Data'];

      if (indexToUpdate < dataList.length) {
        dataList[indexToUpdate]['name'] = newName;

        await collection.doc(userDocId).update({'Data': dataList});
        print("Item updated successfully!");
      } else {
        print("Index out of range.");
      }
    }
  } catch (e) {
    print("Failed to update data: $e");
  }
}


Future<void> addData(String userDocId, Map<String, dynamic> newItem) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('InOutUserData');

  try {
    DocumentSnapshot doc = await collection.doc(userDocId).get();
    if (doc.exists) {
      List<dynamic> currentData = (doc.data() as Map<String, dynamic>)['Data'];
      if (currentData == Null) {
        currentData=[];
      }
      currentData.add(newItem);

      await collection.doc(userDocId).update({'Data': currentData});
      print("Item added successfully!");
    } else {
      // Si no existe el documento, lo creamos con el nuevo item
      await collection.doc(userDocId).set({
        'Data': [newItem],
      });
      print("Document created and item added!");
    }
  } catch (e) {
    print("Failed to add data: $e");
  }
}



/* 

Future<void> deleteData(String user) {
  CollectionReference InOutUserData = FirebaseFirestore.instance.collection('InOutUserData');
  
  return InOutUserData.doc(user).delete()
    .then((value) => print("Product deleted successfully!"))
    .catchError((error) => print("Failed to delete product: $error"));
} */