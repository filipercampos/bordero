import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'image_source_sheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue,
    bool autoValidate = false,
    double height = 120,
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autoValidate,
      builder: (state) {
        //imagens lado a lado
        return Column(
          children: <Widget>[
            //altura das imagens
            Container(
              height: height,
              padding: EdgeInsets.only(top: 8, bottom: 4),
              //uma lista de imagens na horizontal
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: state.value.map<Widget>((i) {
                  //desenha cada imagem
                  return Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(right: 8), //espaçamento entre as imagens
                    child: GestureDetector(
                      child: i is String //url ou files
                          ? Image.network(i, fit: BoxFit.cover)
                          : Image.file(i, fit: BoxFit.cover),
                      //remove uma image
                      onLongPress: () {
                        //remove a imagem e avisa da alutra (cascata)
                        state.didChange(state.value..remove(i));
                      },
                    ),
                  );
                }).toList()
                  ..add(
                    //ação de upar novas imagens
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Theme.of(context).primaryColor),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ImageSourceSheet(
                                iconColor: Theme.of(context).primaryColor,
                                onImageSelected: (image) {
                                  state
                                      .didChange(state.value..add(image));
                                  Navigator.of(context).pop();
                                },
                              ));
                        },
                      )),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                state.hasError ? state.errorText : "",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            )
          ],
        );
      });
}
