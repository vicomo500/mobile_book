
class Validator {
  static final _nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final _emailRegExp = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  static final _numberRegExp = RegExp('[0-9]');
  static const int _MIN_PASS_LENGTH = 3;

  static String isNameValid(name, label){
    if (name.trim().isEmpty)
      return '$label is required';
    if(_nameRegExp.hasMatch(name))
      return "Please enter a valid $label";
    if(name.length < 3)
      return "$label must be at least 3 characters";
    return null;
  }

  static String isEmailValid(email){
    if (email.trim().isEmpty)
      return 'Email is required';
    if(!_emailRegExp.hasMatch(email))
      return "Please enter a valid email";
    return null;
  }

  static String isPhoneValid(phone){
    if (phone.trim().isEmpty)
      return 'Phone number is required';
    if(!_numberRegExp.hasMatch(phone))
      return "Phone number can only contain digits";
    if(phone.length != 11)
      return "Phone number must be 11 digits long";
    return null;
  }

  static String isPasswordValid(password){
    if (password.trim().isEmpty)
      return 'Password is required';
    if(password.length < _MIN_PASS_LENGTH)
      return "Password must be at least $_MIN_PASS_LENGTH character(s) long";
    return null;
  }
}