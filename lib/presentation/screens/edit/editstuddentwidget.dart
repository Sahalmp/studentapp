import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentapp/application/bloc/home_bloc.dart';

import '../../../domain/constants/constants.dart';
import '../../../domain/models/studentmodel.dart';
import '../../widgets/headtitlewidget.dart';
import '../../widgets/textfieldwidget.dart';

class EditStudentWidget extends StatelessWidget {
  final data;
  final index;
  EditStudentWidget({Key? key, required this.data, required this.index})
      : super(key: key);
  final TextEditingController _agecontroller = TextEditingController();
  final TextEditingController _gendercontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _standardcontroller = TextEditingController();
  var pathimage;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    _agecontroller.text = data.age;
    _gendercontroller.text = data.gender;
    _namecontroller.text = data.name;
    _standardcontroller.text = data.standard;
    var _image;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              onsavebuttonclicked(context, index);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 197, 250, 225),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeadTitle(
                    title: "Edit Student",
                  ),
                  height20,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        height: 110,
                        width: 130,
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          return data.image == null && state.image == null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(avatarimage),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle,
                                  ))
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(state.image ?? data.image)),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle,
                                  ));
                        },
                      ),
                      Positioned(
                        bottom: 4,
                        right: -7,
                        child: ElevatedButton(
                          onPressed: () async {
                            await showChoiceDialog(context);
                          },
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                          ),
                          child: const Icon(Icons.photo_camera),
                        ),
                      ),
                    ],
                  ),
                  height20,
                  TextFieldWidget(
                    label: 'Name',
                    type: TextInputType.name,
                    getcontrol: _namecontroller,
                  ),
                  height20,
                  TextFieldWidget(
                    label: 'Age',
                    type: TextInputType.number,
                    getcontrol: _agecontroller,
                  ),
                  height20,
                  TextFieldWidget(
                    label: 'Gender',
                    type: TextInputType.name,
                    getcontrol: _gendercontroller,
                  ),
                  height20,
                  TextFieldWidget(
                    label: 'Class',
                    type: TextInputType.name,
                    getcontrol: _standardcontroller,
                  ),
                  height20,
                ],
              ),
            ),
          )),
    );
  }

  onsavebuttonclicked(BuildContext context, index) async {
    final _name = _namecontroller.text.trim();
    final _age = _agecontroller.text.trim();

    final _gender = _gendercontroller.text.trim();
    final _standard = _standardcontroller.text.trim();

    if (_name.isEmpty || _age.isEmpty || _gender.isEmpty || _standard.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill up all blanks'),
        backgroundColor: Colors.red,
      ));
    }

    final _student = StudentModel(
        name: _name,
        age: _age,
        key: DateTime.now().microsecond,
        image: pathimage,
        gender: _gender,
        standard: _standard);

    BlocProvider.of<HomeBloc>(context)
        .add(EditStudent(model: _student, index: index));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Student Updated'),
    ));
  }

  Future<void> showChoiceDialog(BuildContext context) {
    var _image;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.teal),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.teal,
                  ),
                  ListTile(
                    onTap: () async {
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      _image = image!.path;
                      pathimage = _image;

                      BlocProvider.of<HomeBloc>(context)
                          .add(HomeEvent.getimage(image: pathimage));
                      Navigator.of(context).pop();
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(Icons.photo_library_sharp,
                        color: Colors.teal),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.teal,
                  ),
                  ListTile(
                    onTap: () async {
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      _image = image!.path;
                      pathimage = _image;
                      BlocProvider.of<HomeBloc>(context)
                          .add(HomeEvent.getimage(image: pathimage));

                      Navigator.of(context).pop();
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
