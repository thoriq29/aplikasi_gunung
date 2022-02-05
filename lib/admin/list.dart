import 'package:aplikasi_gunung/admin/form.dart';
import 'package:aplikasi_gunung/model/gunung.dart';
import 'package:aplikasi_gunung/user/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListGunungAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListGunung();
  }
}

class _ListGunung extends State<ListGunungAdmin> {
  late List<DocumentSnapshot> provinces;

  @override
  void initState() {
    super.initState();
    provinces = <DocumentSnapshot>[];
    FirebaseFirestore.instance.collection("provinces ").get().then((values) => 
      setState(() => {
        provinces = values.docs
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        title: Text("Admin Gunung", style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gunungs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: AlwaysStoppedAnimation(Colors.blue),));
          }

          return Container(  
            padding: EdgeInsets.only(left: 12, right: 12),  
            child: ListView.separated(  
              itemCount: snapshot.data?.docs.length as int,
              itemBuilder: (BuildContext context, int index) { 
                var data = snapshot.data?.docs[index];
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailGunung(
                      gunungName: data?["name"],
                      provinceName: provinces.firstWhere((element) => element["id"] == data?["province_id"])['name'],
                      gunungID: data?.id as String,
                    )),
                  ),
                  onLongPress: () {
                    Gunung modelData = new Gunung(
                      id: data?["id"], 
                      name: data?["name"], 
                      image_url: data?["image_url"], 
                      lokasi: data?["lokasi"], 
                      lat: data?["lat"], 
                      lon: data?["lon"], 
                      deskripsi: data?["deskripsi"], 
                      jalur_pendakian: data?["jalur_pendakian"], 
                      info_gunung: data?["info_gunung"], 
                      province_id : data?["province_id"]
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemFormPage(
                        item: modelData,
                        provinces: provinces,
                        docID: data?.id,
                      ))
                    );
                  },
                  title: Text(data?["name"]),
                );
              }, separatorBuilder: (BuildContext context, int index) { 
                return Divider();
               },  
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemFormPage(
              provinces: provinces
            ))
          );
        },
        backgroundColor: Colors.blue,
        label: Text("Add"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}