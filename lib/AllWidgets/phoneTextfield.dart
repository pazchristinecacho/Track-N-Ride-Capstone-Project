import 'package:flutter/material.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    Key key,
    TextEditingController numnberController,
  })  : _numnberController = numnberController,
        super(key: key);

  final TextEditingController _numnberController;

  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: (v) {
          setState(() {
            isFocus = v;
          });
        },
        child: TextField(
          controller: widget._numnberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: OutlineInputBorder(),
            hintText: 'Enter Phone Number',
            prefix: isFocus
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('PH'),
                  )
                : SizedBox.shrink(),
            prefixIcon: isFocus ? null : Icon(Icons.phone),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ));
  }
}
