import 'package:flutter/material.dart';

import 'Constants.dart';

class FormLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  FormLayout({ this.formKey, this.children});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.MAX_VIEW_WIDTH),
            child: Column(
              children: children
            )
        ),
      ),
    );
  }
}
AppBar buildAppBar(title){
  return AppBar(
      title: Text(title),
  centerTitle: true,
  elevation: 0.0,
  );
}

SizedBox buildColumnSpacing({height: Constants.COLUMN_SPACING}) =>
    SizedBox(height: height);

void showErrorSnackBar(context, msg){
  Scaffold.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.redAccent,
    content: Text(msg),
    duration: Duration(seconds: 5),
  ));
}

void showErrorDialog(context, message){
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(onPressed: () {Navigator.of(context).pop();}, child: new Text('dismiss')),
        ],
      )
  );
}
