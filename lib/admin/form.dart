import 'dart:io';

import 'package:aplikasi_gunung/model/gunung.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemFormPage extends StatefulWidget {
  final Gunung? item;
  final String? docID;
  final List<DocumentSnapshot> provinces;

  const ItemFormPage({
    Key? key,
    this.item,
    this.docID,
    required this.provinces,
  }) : super(key: key);

  @override
  _ItemFormPageState createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  String dropdownvalue = "";
  File? imgFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController jalur_pendakianController = TextEditingController();
  TextEditingController info_gunungController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    nameController.text = '';
    imageController.text = '';
    lokasiController.text = '';
    latController.text = '';
    lonController.text = '';
    deskripsiController.text = '';
    jalur_pendakianController.text = '';
    info_gunungController.text = '';
    colorController.text = '';
    dropdownvalue = widget.item != null ? widget.item!.province_id.toString(): widget.provinces.first['id'].toString();
    super.initState();
  }

  imgSource(String source) async {
    XFile? imgPicker = await ImagePicker().pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );
    setState(() {
      if (imgPicker != null) {
        imgFile = File(imgPicker.path);
      }
    });
  }

  Future<String> uploadFile(File image_url, String filename) {
    Reference reference =
        FirebaseStorage.instance.ref().child('gunungs/' + filename);
    UploadTask uploadTask = reference.putFile(image_url);
    return uploadTask.then((taskSnapshot) async {
      return await taskSnapshot.ref.getDownloadURL();
    });
  }

  deleteFile(String url) {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  showImgOption() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: Colors.black,
              ),
              title: Text('Gallery'),
              onTap: () {
                imgSource('gallery');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: Colors.black,
              ),
              title: Text('Camera'),
              onTap: () {
                imgSource('camera');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      lokasiController.text = widget.item!.lokasi;
      latController.text = widget.item!.lat.toString();
      lonController.text = widget.item!.lon.toString();
      deskripsiController.text = widget.item!.deskripsi;
      jalur_pendakianController.text = widget.item!.jalur_pendakian;
      info_gunungController.text = widget.item!.info_gunung;
      imageController.text = widget.item!.image_url;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              margin: EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.item != null ? 'Edit Gunung' : 'New Gunung',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.item != null ? true : false,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.item!.image_url.isNotEmpty) {
                            deleteFile(widget.item!.image_url);
                          }
                          FirebaseFirestore.instance
                              .collection('gunungs')
                              .doc(widget.item!.id)
                              .delete()
                              .then((value) => Navigator.pop(context))
                              .catchError((error) => debugPrint(
                                  'Failed to delete gunung : ' +
                                      error.toString()));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent.shade700,
                          radius: 20,
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                children: [
                  GestureDetector(
                    onTap: () => showImgOption(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                        bottom: 50,
                      ),
                      child: imgFile != null
                          ? Image.file(
                              imgFile!,
                              height: 200,
                            )
                          : widget.item != null
                              ? widget.item!.image_url.isNotEmpty
                                  ? Image.network(
                                      widget.item!.image_url,
                                      height: 200,
                                    )
                                  : Icon(
                                      Icons.image_outlined,
                                      color: Colors.black,
                                      size: 200,
                                    )
                              : Icon(
                                  Icons.image_outlined,
                                  color: Colors.black,
                                  size: 200,
                                ),
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // TextField(
                  //   controller: imageController,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Image',
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Lokasi"),
                  DropdownButton(  
                    // Initial Value
                    value: dropdownvalue,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),    
                    // Array list of items
                    items: widget.provinces.map((DocumentSnapshot items) {
                      return DropdownMenuItem(
                        value: items["id"].toString(),
                        child: Text(items["name"].toString()),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) { 
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: latController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lat',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: lonController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lon',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: deskripsiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Deskripsi',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: jalur_pendakianController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jalur Pendakian',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: info_gunungController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Info Gunung',
                    ),
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // TextField(
                  //   controller: colorController,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Color',
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        String id = widget.item != null && widget.docID != null ? widget.docID as String :
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Gunung item = Gunung(
                          id: widget.item != null ? widget.item!.id : id,
                          name: nameController.text,
                          image_url: imgFile != null
                              ? widget.item != null
                                  ? await uploadFile(imgFile!, widget.item!.id)
                                  : await uploadFile(imgFile!, id)
                              : widget.item != null ? widget.item?.image_url as String : "",
                          lokasi: lokasiController.text,
                          lat: double.parse(latController.text),
                          lon: double.parse(lonController.text),
                          deskripsi: deskripsiController.text,
                          jalur_pendakian: jalur_pendakianController.text,
                          info_gunung: info_gunungController.text,
                          province_id: int.parse(dropdownvalue.toString())
                        );
                        if (widget.item != null) {
                          // update to db
                          FirebaseFirestore.instance
                              .collection('gunungs')
                              .doc(widget.docID)
                              .update(item.toJson())
                              .then((value) => Navigator.pop(context))
                              .catchError((error) => debugPrint(
                                  'Failed to update gunung : ' +
                                      error.toString()));
                        } else {
                          // insert to db using custom-id
                          FirebaseFirestore.instance
                              .collection('gunungs')
                              .doc(id)
                              .set(item.toJson())
                              .then((value) => Navigator.pop(context))
                              .catchError((error) => debugPrint(
                                  'Failed to insert gunung : ' +
                                      error.toString()));
                          // // insert to db using auto-id
                          // FirebaseFirestore.instance
                          //     .collection('items')
                          //     .add(item.toJson())
                          //     .then((value) => Navigator.pop(context))
                          //     .catchError((error) => debugPrint(
                          //         'Failed to insert item : ' + error.toString()));
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: widget.item != null ? Colors.amber : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        widget.item != null ? 'Edit' : 'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
