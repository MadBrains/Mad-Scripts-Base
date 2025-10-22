class TagPatterns {
  static RegExp block(String tag) => RegExp('{{#$tag(.*?)}}(.*?)?{{/$tag}}', dotAll: true);
  static RegExp selfClosing(String tag) => RegExp('{{$tag(.*?)}}', dotAll: true);
}
