/// # Inspect util for Dart
/// The core purpose of this package is to make formatting in the console better.
/// This package can format Dart literals, classes (including built-ins), functions,
/// an types. These all come with optional colouring for the console.
/// It's advised not to use the colour option in the debug console as they do not
/// always output correctly.
export 'inspect.dart';

import 'dart:mirrors';

final colours = <String, String>{
  'reset': '\x1b[0m',
  'crimson': '\x1b[38m',
  'red': '\x1b[31m',
  'yellow': '\x1b[33m',
  'green': '\x1b[32m',
  'cyan': '\x1b[36m',
  'blue': '\x1b[34m',
  'magenta': '\x1b[35m',
  'black': '\x1b[30m',
  'white': '\x1b[37m'
};

/// Parses a class into a formatted readable list of strings. In combination with
/// the [inspect] function it can be used to properly display the methods and
/// properties of a class.
List<String> parseClass(Object cls, [bool? colour]) {
  colour ??= false;
  String clsName = cls.toString();
  if (clsName.contains("'")) clsName = clsName.split("'")[1];
  InstanceMirror mirror = reflect(cls);
  List<String> res = [];

  for (var dec in mirror.type.declarations.entries) {
    String k = dec.key.toString().split('"')[1];
    dynamic v;
    if (dec.value is MethodMirror) {
      String name = dec.value.simpleName.toString().split('"')[1];
      v = '<${name == clsName ? "constructor" : "method"} $name()>';
      if (colour) v = p('ma')! + v + p('re')!;
    } else {
      v = parseType(mirror.getField(dec.key).reflectee.toString());
      if (colour) v = colourType(v)!;
    }
    res.add('  $k: $v;');
  }

  return res;
}

/// A shorthand accessor function for the [colours] constant
/// (aka the "paint" function). This returns the colour code for a specified
/// colour that matches the name. The full name does not need to be given to
/// return the correct colour.
String? p(String n) {
  for (var k in colours.keys) {
    if (k.startsWith(n)) return colours[k];
  }
  return '';
}

/// Parses an object from a string and returns a string, number, or null.
dynamic parseType(String obj) {
  dynamic v = int.tryParse(obj);
  v ??= double.tryParse(obj);
  if (v == null) {
    if (obj.contains('"')) return "'$obj'";
    if (obj.contains("'")) return '"$obj"';
    return "'$obj'";
  }
  return v;
}

/// Parses an object and returns the corresponding colours for the object
/// in a formatted string.
String? colourType(dynamic obj) {
  if (obj is num || obj is List) return p('bl')! + obj.toString() + p('re')!;

  if (obj is String) {
    if (obj.contains('"')) return p('gr')! + "'$obj'" + p('re')!;
    if (obj.contains("'")) return p('gr')! + '"$obj"' + p('re')!;
    return p('gr')! + "'$obj'" + p('re')!;
  }

  if (obj is bool) {
    return '${p("cy")}$obj${p("re")}';
  }

  if (obj is Map) {
    List<String> res = [];
    obj.forEach((k, v) => res.add('  ${colourType(k)} => ${colourType(v)}'));
    return '${p("ye")}${obj.runtimeType.toString().substring(19)}${p("re")} {\n${res.join(",\n")}\n}';
  }

  if (obj is Set) {
    List<String> res = [];
    for (var e in obj) {
      res.add(colourType(e)!);
    }
    return '${p("ye")}${obj.runtimeType.toString().substring(18)}${p("re")} {\n${res.join(",\n")}\n}';
  }
}

/// Inspects an object and returns a formatted (and optionally coloured)
/// string representation. This also covers nested objects/classes.
String inspect(Object object, [bool? colour]) {
  final type = object.runtimeType.toString();
  final c = colour ?? false;

  if (
    object is num ||
    object is String ||
    object is bool ||
    object is List
    ) {
    if (c) return '${p("ye")}$type${p("re")} { ${colourType(object)} }';
    return '$type { ${object.toString()} }';
  }

  if (object is Map) {
    if (c) return colourType(object)!;
    List<String> res = [];
    object.forEach((k, v) => res.add('  $k => $v'));
    return '${type.substring(19)} {\n${res.join(",\n")}\n}';
  }

  if (object is Set) {
    if (c) return colourType(object)!;
    return '${type.substring(18)} {\n${object.map((e) => "  $e").join(",\n")}\n}';
  }

  List<String> cls = parseClass(object, c);
  if (c) return '${p("ye")}$type${p("re")} {\n${cls.join("\n")}\n}';
  return '$type {\n${cls.join("\n")}\n}';
}
