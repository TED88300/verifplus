
import 'package:url_launcher/url_launcher.dart';



void launchURL(String url) async {
  Uri uri = Uri.parse(url);

  print ("launchURL $url");
  print ("uri ${uri}");


  if (await canLaunchUrl(uri)) {
    print ("canLaunchUrl $url");
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }

}
