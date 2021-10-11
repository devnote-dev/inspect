// ignore_for_file: avoid_relative_lib_imports

import '../lib/inspect.dart';

class Vector {
  int x, y;
  int? z;

  Vector(this.x, this.y, [this.z]);

  String get type => z != null ? '3D' : '2D';
}

void write(String msg) {
  return print(msg);
}

void main() {
  print('Inspect util package test...');

  print('\n# Numbers:');
  print(inspect(123));
  print(inspect(23.45));
  print(inspect(-456));
  print(inspect(0x64));
  print(inspect(1e45));
  print(inspect(1e999));

  print('\n# Strings:');
  print(inspect('This string was inspected!'));
  print(inspect("This also covers 'quotes' within \"quotes\""));

  print('\n# Lists, Maps, Sets:');
  print(inspect([1, 2, 3, 4, 5]));
  print(inspect({'abc': 123, 'def': 456}));
  print(inspect({12, 34, 56}));

  print('\n# Custom:');
  print(inspect(Vector(4, 5, 6)));
  print(inspect(write));
}
