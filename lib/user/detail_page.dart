import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailGunung extends StatelessWidget {
  final String gunungName;
  final String provinceName;
  final String gunungID;

  DetailGunung({required this.gunungName, required this.provinceName, required this.gunungID});

  TextStyle styleTextBold(fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Detail",style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("gunungs").doc(gunungID).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: AlwaysStoppedAnimation(Colors.blue),));
          }

          DocumentSnapshot? data = snapshot.data;
          return Stack(
            children: [ 
              Image.network(data?['image_url']),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  expand: true,
                  initialChildSize: 0.75,
                  minChildSize: .70,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                      color: Colors.black
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Text(data?['name'], style: styleTextBold(22.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(children: [
                                  Icon(Icons.location_on, size: 14,),
                                  Text(provinceName)
                                ],),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14, right: 14),
                                child: Text(data?["deskripsi"].toString().replaceAll("\\n", "\n") as String, textAlign: TextAlign.justify,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14, right: 14),
                                child: Text("Jalur pendakian", style: styleTextBold(18.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, right: 14),
                                child: Text(data?["jalur_pendakian"].toString().replaceAll("\\n", "\n") as String),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14, right: 14),
                                child: Text("Informasi gunung", style: styleTextBold(18.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, right: 14),
                                child: Text(data?["info_gunung"].toString().replaceAll("\\n", "\n") as String),
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  },
                ),
              ),
            ]
          );
        }
      ),
    );
  }
}