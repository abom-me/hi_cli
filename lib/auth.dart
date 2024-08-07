

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_widget/dart_widget.dart';
import 'package:hi_cli/hi_cli.dart';

class Auth extends Command{
Auth(){
  argParser.addFlag("login", help: "Login to the system");
  argParser.addFlag("logout", help: "Logout from the system");
  argParser.addFlag("check", help: "Check if user is logged in");
}

final home= Platform.environment["HOME"] ?? Platform.environment["USERPROFILE"];


  @override
 run(){
  if(argResults?["login"]==true){
login();

  }else if(argResults?["logout"]==true){
logout();
  }else if(argResults?["check"]==true) {
    check();

  }else{
    print("Invalid command. Usage: auth --login");
  }

  }


  login() async {
 final userEX=   check();
 if(userEX){
    print("User is already logged in ??");
 }else{
   final file =File("db.json");
   final users= await file.readAsString();
   bool isUserExist = false;
   List usersList= json.decode(users);
   final username =TextField(
       prompt: "Enter your username",
       validator: (value){
         if(value.length<3){
           throw ValidationErrors("Username is required");

         }else{
           return true;
         }
       }
   ).oneline();
   final password= TextField(prompt: "Enter your password",).password();
   final circle = CircleLoading(
     loadingText: "Please wait Login in progress",
     onDoneText: "\nLogin successful",
   );
   circle.start();
await Future.delayed(Duration(seconds: 5),(){

});
   usersList.forEach((element){
     if(element["username"]==username && element["password"]==password) {
       isUserExist = true;
     }

   });
   circle.stop();
   if(isUserExist){
     print("Welcome $username 👋");
     saveUser(username: username??"null", password: password??"null");

   }else {
     print("Sorry, login failed 😢");
     login();
   }
 }

  }


   bool check(){
    final userFile= File("$home/.hiuser");
    if(userFile.existsSync()){

      final user = userFile.readAsStringSync();
      // Map<String, dynamic> userMap = json.decode(user);
      print("Welcome again: ${user} 🥳");
      return true;
    }else{
      print("User is not logged in ??");
      return false;
    }

  }


  saveUser(
{
  required String username,
  required String password,
}
      ){
    final userFile= File("$home/.hiuser");
    userFile.writeAsStringSync({
      "username":username,
      "password":password,
      "loginTime":DateTime.now().toIso8601String(),
    }.toString()
    );
    if(userFile.existsSync()){
      print("User saved successfully ??");
    }else{
      print("User not saved ??");
    }
  }


  logout(){
    final userFile= File("$home/.hiuser");
    userFile.deleteSync();
    if(userFile.existsSync()){
      print("User not logged out , try again ");
    }else{
      print("User logged out successfully 👋");
    }


  }


  @override
  // TODO: implement description
  String get description => "Login to the system";

  @override
  // TODO: implement name
  String get name => "auth";




}