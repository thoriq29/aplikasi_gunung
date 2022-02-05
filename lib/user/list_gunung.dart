import 'package:aplikasi_gunung/user/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListGunung extends StatelessWidget {
  final String provinceName;
  final int provinceID;

  ListGunung({required this.provinceID, required this.provinceName});

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
        title: Text(provinceName,style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gunungs').where("province_id", isEqualTo: provinceID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: AlwaysStoppedAnimation(Colors.blue),));
          }

          return Container(  
            padding: EdgeInsets.only(left: 12, right: 12),  
            child: GridView.builder(  
              itemCount: snapshot.data?.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                  crossAxisCount: 2,  
                  crossAxisSpacing: 4.0,  
                  mainAxisSpacing: 4.0  
              ),  
              itemBuilder: (BuildContext context, int index){ 
                var data = snapshot.data?.docs[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailGunung(
                      gunungName: data?["name"],
                      provinceName: provinceName,
                      gunungID: data?.id as String,
                    )),
                  ),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Image.network(data?['image_url']),
                        ),
                        Text(data?['name']),
                        Text(provinceName)
                      ],
                    ),
                  ),
                );
              },  
            )
          );
        },
      ),
    );
  }
}