import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/pags/widget/selectFile.dart';
import 'package:flutter_application_10/shard/app_colors.dart';

class Headaddfile extends StatelessWidget {
  final String page_anme;

  const Headaddfile({super.key, required this.page_anme});

  @override
  Widget build(BuildContext context) {
    return header(pageName: page_anme);
  }

  Widget header({pageName}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.bgcolor, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pageName),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.green,
                height: 3,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Research Name'),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        hintText: 'Research Name',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // مثال استخدام أساسي
                  CustomFilePicker(
                    onFileSelected: (file) {
                      print('تم اختيار الملف: ${file.name}');
                    },
                    onError: (error) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text(error)),
                      // );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MyButton(
                      color: Colors.blue,
                      title: 'Add Team Research',
                      onPressed: () {})

// // مثال مع خصائص مخصصة
// CustomFilePicker(
//   buttonText: 'اختر صورة',
//   buttonIcon: Icons.image,
//   allowedExtensions: ['jpg', 'png', 'jpeg'],
//   fileType: FileType.image,
//   buttonStyle: ElevatedButton.styleFrom(
//     backgroundColor: Colors.green,
//     foregroundColor: Colors.white,
//   ),
//   filePreview: _selectedFile != null
//       ? Image.file(File(_selectedFile!.path!))
//       : null,
// )
                ],
              ),
            ]));
  }
}
