
class Validators {



bool validateText(String value){
  print(value);
  bool res;
  if(value.isEmpty){
    res = false;
  }else{
    res = true;
  }
 
  return res;
}

 bool validateEmail(String value) {
 
 bool res;
  
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);
  if (regExp.hasMatch(value)) {
    res = true;
  }else{
    res = false;
  }
 
  return res;
  
  
}

 bool validatePassword(String value){
   bool res;
  

  if(value.length<5){
    res = false;
  }else{
    res = true;
  }
   
  return res;
  
}

}