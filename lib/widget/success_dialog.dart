import 'package:flutter/material.dart';

class Consts{
  Consts._();
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;

}

class SuccessDialog extends StatelessWidget{
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({Key? key, this.description, this.okClick})
      : super (key: key);
}

@override
Widget build (BuildContext context){
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Consts.padding),
    ),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: contentBox(context),
  )
}

dialogContent(BuildContext context){
  return Container(
    padding: const EdgeInsets.only(
      top: Consts.padding,
      bottom: Consts.padding,
      left: Consts.padding,
      right: Consts.padding,
    ),
    margin: const EdgeInsets.only(top: Consts.avatarRadius),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.white,
      borderRadius: BorderRadius.circular(Consts.padding),
      boxShadow: const [
        BoxShadow(
          color: Colors.black, offset: Offset(0,10),
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "SUKSES",
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.green,),
        ),
        const SizedBox(height: 16.0,),
        Text(
          description!,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24,),
        Align(
          alignment: Alignment.bottomRight,
          child: OutlinedButton(
            onPressed: (){
              Navigator.of(context).pop();
              okClick!();
            },
            child: const Text("OK"),
          ),
        ),
      ],
    ),
  );
}