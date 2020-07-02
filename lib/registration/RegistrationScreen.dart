import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_book/registration/RegService.dart';
import 'package:mobile_book/utils/Constants.dart';
import 'package:mobile_book/utils/Routes.dart';
import 'package:mobile_book/utils/Validator.dart';
import 'package:mobile_book/utils/widget_util.dart';

import '../models/User.dart';

class RegistrationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('${Constants.APP_NAME} Registration'),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Constants.LAYOUT_PADDING, Constants.LAYOUT_PADDING, Constants.LAYOUT_PADDING, Constants.LAYOUT_BOTTOM_PADDING),
          child: _RegistrationForm(),
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatefulWidget {

  const _RegistrationForm({Key key}) : super(key: key);

  @override
  __RegistrationFormState createState() => __RegistrationFormState();
}

class __RegistrationFormState extends State<_RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _user = User();
  bool _shouldPasswordVisible = false;//password toggle
  bool _isLoading = false;//for progress bar toggle
  //text controllers for form fields
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameCtrl.addListener(() { _user.firstName = _firstNameCtrl.text;});
    _lastNameCtrl.addListener(() { _user.lastName = _lastNameCtrl.text;});
    _emailCtrl.addListener(() { _user.email = _emailCtrl.text;});
    _phoneCtrl.addListener(() { _user.phoneNumber = _phoneCtrl.text;});
    _passwordCtrl.addListener(() { _user.password = _passwordCtrl.text;});
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
        formKey: _formKey,
      children: <Widget>[
        TextFormField(
          key: Key('firstName'),
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
          validator:(value) => Validator.isNameValid(value, 'First Name'),
          controller: _firstNameCtrl,
          keyboardType: TextInputType.text,
        ),
        buildColumnSpacing(),
        TextFormField(
          key: Key('lastName'),
          decoration: const InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => Validator.isNameValid(value, 'Last Name'),
          controller: _lastNameCtrl,
        ),
        buildColumnSpacing(),
        TextFormField(
          key: Key('email'),
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) => Validator.isEmailValid(value),
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        buildColumnSpacing(),
        TextFormField(
          key: Key('phoneNumber'),
          decoration:  InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            /*suffixIcon: IconButton(
                    onPressed: () => _phoneCtrl.clear(),
                    icon: Icon(Icons.clear),
                  ),*/
          ),
          validator: (value) => Validator.isPhoneValid(value),
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
        ),
        buildColumnSpacing(),
        TextFormField(
          key: Key('password'),
          decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _shouldPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  //color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toggle the state of _shouldPasswordVisible variable
                  setState(() {
                    _shouldPasswordVisible = !_shouldPasswordVisible;
                  });
                },
              )
          ),
          validator: (value) => Validator.isPasswordValid(value),
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_shouldPasswordVisible,
        ),
        SizedBox(height: 24.0),
        _isLoading ?
        Center(
          child: CircularProgressIndicator(),
        ) :
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            key: Key('submit'),
            onPressed: _submit,
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if( _formKey.currentState.validate()){
      _formKey.currentState.save();
      _registerUser();
    }
  }
  
  void _registerUser() async{
    try{
      setState(()=> _isLoading = true);
      var confirmed = await RegService.registerUser(_user);
      if( confirmed)
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.HOME,
            (Route<dynamic> route) => false,
            arguments: {"principal": _user.toJson()}
            );
      else{
        setState(()=> _isLoading = false);
        showErrorSnackBar(context, 'Unable to register! Please try again');
      }
    }catch(error){
      setState(()=> _isLoading = false);
      showErrorDialog(context, error.message);
    }
  }
}

