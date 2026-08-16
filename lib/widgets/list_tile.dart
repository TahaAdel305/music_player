import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  Widget leading;
  String title;
  // ListTile({required IconButton leading, required Text title,});
  CustomListTile({required this.leading,required this.title,});
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading:leading,
      title: Text(title),
    );
  }
}
