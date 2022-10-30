import 'package:textfield_tags/textfield_tags.dart';

class MyCustomController extends TextfieldTagsController {
  MyCustomController() : super();

  //create your own methods
  void myCustomMethod() {}

  //override the super class method
  @override
  set addTag(String tag) {
    if (tag != 'php') {
      super.addTag = tag;
      notifyListeners();
    }
  }

  //....
}
