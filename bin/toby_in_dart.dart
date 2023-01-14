void main(List<String> arguments) {
  if (arguments.length != 2) {
    print('Usage: dart toby_in_dart.dart <firstname> <lastname>');
    return;
  }

  String firstname = arguments[0];
  String lastname = arguments[1];

  print('Hi $firstname $lastname!');
}
