import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/Client_Groupe_Parc_Inter_Obs_Photos.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';


class Client_Groupe_Parc_Inter_Obs extends StatefulWidget {
  @override
  Client_Groupe_Parc_Inter_ObsState createState() => Client_Groupe_Parc_Inter_ObsState();
}

class Client_Groupe_Parc_Inter_ObsState extends State<Client_Groupe_Parc_Inter_Obs> {
  final ObsController = TextEditingController();

  List<Widget> imgList = [];

  @override
  void initLib() async {
    imgList.clear();
    DbTools.glfParc_Imgs.forEach((element) {
      Widget wWidget = Container(
        child: Image.file(
          File(element.Parc_Imgs_Path!),
          width: 200,
          height: 300,
        ),
      );
      imgList.add(wWidget);
    });

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build  ${imgList.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: /*Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: */Column(
            children: [
              Row(
                children: [
                  new Flexible(
                    child: TextFormField(
                      minLines: 5, //Normal textInputField will be displayed
                      maxLines:
                          25, // when user presses enter it will adapt to it

                      style: gColors.bodySaisie_N_B,
                      controller: ObsController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Observation',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 8,
              ),

            /*  Container(
                  child: ElevatedButton(
                onPressed: () async {
                  DbTools.gImagePath = "";
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Client_Groupe_Parc_Inter_Obs_Photos()));

                  print("gImagePath ${DbTools.gImagePath}");

                  if (DbTools.gImagePath != "") {
                    print("Add ${DbTools.gImagePath}");
                    Widget wWidget = Container(
                      child: Image.file(
                        File(DbTools.gImagePath!),
                        width: 200,
                        height: 300,
                      ),
                    );

                    setState(() {
                      imgList.add(wWidget);
                      print("Add photo ${imgList.length}");

                      print("setState");
                    });
                  }
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.white,
                      padding: const EdgeInsets.all(12.0),),

                child: Icon(
                  Icons.camera_alt,
                  color: gColors.secondary,
                ),
              )),

*/
              IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                icon: Image.asset("assets/images/Photo.png"),
                onPressed: () async {
                  DbTools.gImagePath = "";
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Client_Groupe_Parc_Inter_Obs_Photos()));

                  print("gImagePath ${DbTools.gImagePath}");

                  if (DbTools.gImagePath != "") {
                    print("Add ${DbTools.gImagePath}");
                    Widget wWidget = Container(
                      child: Image.file(
                        File(DbTools.gImagePath!),
                        width: 200,
                        height: 300,
                      ),
                    );

                    setState(() {
                      imgList.add(wWidget);
                      print("Add photo ${imgList.length}");

                      print("setState");
                    });
                  }
                },
              ),




              Text("${imgList.length} images", style: gColors.bodySaisie_B_G,),
              Container(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imgList.length, // number of items in your list
                    itemBuilder: (BuildContext context, int Itemindex) {


                      final imgFile = File(DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!);
                      print("Change wWidget A ${ imgFile.length()}");



                      return GestureDetector(
                          //You need to make my child interactive
                          onTap: () async {
                            print(Itemindex);



                            DbTools.gImagePath = DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path;

                            final wimgFile = File(DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!);
                            print("Change AVANT ${await wimgFile.length()}");


                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DisplayImageScreen(
                                  imagePath: DbTools
                                      .glfParc_Imgs[Itemindex].Parc_Imgs_Path!,
                                ),
                              ),
                            );

                            if (DbTools.gImagePath == "") {
                              await DbTools.deleteParc_Img(DbTools.glfParc_Imgs[Itemindex].Parc_Imgid!, 99);
                              await DbTools.glfParc_Imgs.removeAt(Itemindex);
                              await imgList.removeAt(Itemindex);
                            }
                            else
                              {
                                final imgFile =  File(DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!);
                                print("Change wWidget A ${await imgFile.length()}");

                                Uint8List fileBytes = imgFile.readAsBytesSync();
                                Widget wWidget = Container(
                                  child: Image.memory(
                                    fileBytes,
                                    width: 200,
                                    height: 100,
                                  ),
                                );
                                print("Change wWidget > ${DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!}");
                                imgList[Itemindex] = wWidget;
                                print("Change wWidget <");

                                setState(() {



                                });

                              }

                            print("setState après click");
                            setState(() {});
                          },
                          child: imgList[Itemindex]
                      );
                    }),
              ),
            ],
          ),
    );
  }
}

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  const DisplayImageScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;


    final imgFile =  File(imagePath);


    Uint8List fileBytes = imgFile.readAsBytesSync();


    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
//          "Client : ${DbTools.gClient.Clients_Nom} (${DbTools.gClient.Clients_Cp}) / ${DbTools.gSite.Sites_Nom} (${DbTools.gSite.Sites_Cp})",
          "Client : xxxxx",
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/Ico.png"),
        ),
        backgroundColor: gColors.primary,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      color: Colors.black,
                      width: size,
                      height: size * 1.5,
                      child: //Image.file(File(imagePath)),
                      Image.memory(
                        fileBytes,

                      ),
                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Icon(
                    Icons.delete,
                    color: gColors.secondary,
                  ),
                  onPressed: () async {
                    DbTools.gImagePath = "";
                    Navigator.pop(context);
                  },
                ),

                ElevatedButton(
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePainterTools(
                          imagePath: DbTools.gImagePath!,
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),



                ElevatedButton(
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
