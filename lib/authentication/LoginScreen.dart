import 'package:flutter/material.dart';
import 'package:mobile_book/authentication/AuthService.dart';
import 'package:mobile_book/models/User.dart';
import 'package:mobile_book/utils/Constants.dart';
import 'package:mobile_book/utils/Routes.dart';
import 'package:mobile_book/utils/Validator.dart';
import 'package:mobile_book/utils/widget_util.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Constants.LAYOUT_PADDING),
            child: _buildDefaultLayout(),
            ),
        ),
        ),
      );
/*      body: SafeArea(
        child: Center(
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return orientation == Orientation.portrait
                  ? _buildPortraitLayout()
                  : _buildLandscapeLayout();
            },
          ),
        ),
      ),*/
  }

  _buildDefaultLayout() {
    return Column(
      children: <Widget>[

        _appLogo(200.0),
        _LoginForm(),
      ],
    );

  }

  _appLogo(size) =>
      FlutterLogo(size: size);

}

class _LoginForm extends StatefulWidget {

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _email, _password;
  bool _shouldPasswordVisible = false, _isLoading =  false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() { _email = _emailCtrl.text;});
    _passwordCtrl.addListener(() { _password = _passwordCtrl.text;});
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FormLayout(
      formKey: _formKey,
        children: <Widget>[
          TextFormField(
            key: Key("email"),
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
            key: Key("password"),
            decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _shouldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
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
          buildColumnSpacing(),
          _isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              key: Key("submit"),
              onPressed: _submit,
              child: const Text('Sign In'),
            ),
          ),
          buildColumnSpacing(),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  highlightedBorderColor: Colors.transparent,
                  onPressed: () => Navigator.pushNamed(context, Routes.REGISTRATION),
                  child: const Text('Sign Up'),
                ),
              ),
              buildColumnSpacing(),
              Expanded(
                child: FlatButton.icon(
                  onPressed: _fingerPrintAuth,
                  icon: Icon(Icons.fingerprint,),
                  label: Expanded(child: Text('Use Fingerprint',)),
                ),
              )
            ],
          )
        ]
    );
  }

  void _submit() {
    if( _formKey.currentState.validate()){
      _formKey.currentState.save();
      _loginUser();
    }
  }

  void _fingerPrintAuth() async{
    try{
      var hasAuthenticated = await AuthService.authenticateFingerprint();
      if(hasAuthenticated)
        _navigateToHome(
            User.name(
                firstName: "Mongo",
                lastName: "Park",
                email: "mpark@ymail.com",
                phoneNumber: "08123456789",
            )
        );
      else
        showErrorSnackBar(context, "finger print authentication failed");
    }catch(error){
      setState(()=> _isLoading = false);
      showErrorDialog(context, error.message);
    }
  }

  void _loginUser() async{
    try{
      setState(()=> _isLoading = true);
      var user = await AuthService.authenticateUser(_email, _password);
      if( user != null)
        _navigateToHome(user);
      else{
        setState(()=> _isLoading = false);
        showErrorSnackBar(context, "Invalid username or password");
      }
    }catch(error){
      setState(()=> _isLoading = false);
      showErrorDialog(context, error.message);
    }
  }

  void _navigateToHome(user){
    if( user != null)
      Navigator.pushReplacementNamed(
          context,
          Routes.HOME,
          arguments: {"principal": user.toJson()},
      );
  }
}

