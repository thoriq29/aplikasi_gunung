import 'package:aplikasi_gunung/admin/list.dart';
import 'package:aplikasi_gunung/login.dart';
import 'package:aplikasi_gunung/user/list_gunung.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Si Gunung",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            tooltip: "Login",
            onPressed: ()  {
              User? currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListGunungAdmin()),
                );
              }
              
            },
            icon: Icon(Icons.login, color: Colors.black,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network("https://volcano.si.edu/gallery/photos/GVP-12125.jpg"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Lokasi Gunung"),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("provinces ").get(),
              builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot.data?.docs);
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && snapshot.data?.docs.length == 0) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: 500,
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListGunung(provinceID: data['id'], provinceName: data['name'],)),
                          ),
                          child: Container(
                            height: 70,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(data["name"]),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("assets/images/"+data['image']+".png")
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: AlwaysStoppedAnimation(Colors.blue),));
              },
            )
          ],
        ),
      ),
    );
  }
}