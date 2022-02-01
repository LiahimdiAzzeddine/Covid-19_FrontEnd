import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class CallAp{
  final String _url="http://localhost:8000/api/";
  postData(data,apiUrl) async {
    var fullUral=_url+apiUrl;
    return await http.post(
        Uri.parse(fullUral),
        body:jsonEncode(data),
        headers: _setHeaders(),
    );
  }
}
_setHeaders()=>{
  'Content-type':'application/json',
  'Accept':'application/json',
};