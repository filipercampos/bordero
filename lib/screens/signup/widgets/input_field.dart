import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String hint;
  final bool obscure;
  final IconData icon;
  final TextInputType keyboardType;


  InputField({this.hint, this.obscure, this.icon, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
            ),
          ),
          child: TextField(
            obscureText: obscure,
            style: TextStyle(
              color: Colors.white,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.only(
                top: 20,
                right: 20,
                bottom: 20,
                left: 5
              ),
              errorStyle: TextStyle(color: Colors.red[500]),
              errorText: "Informe um nome para Exibição"
            ),
          ),
        );
  }
}
