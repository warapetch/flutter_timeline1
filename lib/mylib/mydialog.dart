import 'package:flutter/material.dart';

Future<void> warningDialog(BuildContext context,String message) async { //=>

    showDialog(
        context: context,
        builder: (context) =>

            SimpleDialog(
                title: Text(message),
                children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                     ElevatedButton(onPressed: ()=>
                                            Navigator.pop(context),
                                                    child: Text("ตกลง",
                                                            style: TextStyle(color: Colors.white),
                                                            ),
                                            ),
                                    ]
                            ),
                    ],
            )
    );
}


Future<void> confirmDialog({BuildContext context,String textTitle = "Confirmation",
                        String textBody, String textButtonConfirm = "Confirm",
                        String textButtonCancel = "Cancel",Function(bool) onSelected}
                        ) async {

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(textTitle),
                    content: SingleChildScrollView(
                    child: Column(
                            children: <Widget>[
                                    Text(textBody),
                                ],
                            ),
                    ),
                    actions: <Widget>[
                                TextButton(
                                    child: Text(textButtonConfirm),
                                    onPressed: () {
                                        Navigator.of(context).pop();
                                        if (onSelected != null){
                                            onSelected(true);
                                        }
                                        return true;
                                    },
                                ),

                                TextButton(
                                    child: Text(textButtonCancel),
                                    onPressed: () {
                                    Navigator.of(context).pop();
                                        if (onSelected != null){
                                            onSelected(false);
                                        }
                                    return false;
                                    },
                                ),
                            ],
                    );
      }
    );
}




Widget showStatusSign(String message) {

        return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                                    new Center(
                                        child: new SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: new CircularProgressIndicator(
                                                value: null,
                                                strokeWidth: 7.0,
                                                ),
                                        ),
                                    ),

                                    new Container(
                                            margin: const EdgeInsets.only(top: 25.0),
                                            child: new Center(
                                                        child: new Text(
                                                                    message,
                                                                    style: new TextStyle(
                                                                    color: Colors.white
                                                                    ),
                                                                ),
                                                        ),
                                    ),
                    ]
    );
}
