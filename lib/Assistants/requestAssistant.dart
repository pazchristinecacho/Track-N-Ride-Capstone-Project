import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(Uri url) async{
    http.Response response = await http.get(url);
    //http.Response response = await http.get(url);

    try{
      if(response.statusCode == 200){
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        //String jsonsDataString = response.toString();
        //var jsonData = jsonDecode(jsonsDataString);
        //return jsonData;

        return decodeData;
      }
      else{
        return "failed";
      }
    }
    catch(exp){
      return "failed";
    }
  }

}