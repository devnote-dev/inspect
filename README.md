# Inspect
If you are familiar with JavaScript's `inspect` module then this is essentially an implementation of that in Dart. If you don't, then this package basically parses and formats an object into a readable string (usually used for console related activities). This can be a Dart literal object, a class (custom or built-in), function or type(s). Like the JS module it also has optional colouring (although it should not be used in debug consoles as the colouring does not always output correctly).

## Why use this?
You don't have to use this, there are a few bugs with this that are yet to be fixed. This package is for testing purposes and part of me learning Dart (but can be used for other things). There is most likely a better version of this somewhere in the pub which you should use instead.

## Examples
You can see a full list of examples by running `dart run` after installing the package, but here's a quick one:

```dart
import 'package:inspect.dart';

class Vector {
    num x, y;

    Vector(this.x, this.y);

    num mult() => x * y;
}

void main() {
    print(inspect(Vector(3, 2)));
}
```

Output:
```shell
Vector {
  x: 3;
  y: 2;
  mult: <method mult()>;
  Vector: <constructor Vector()>;
}
```

This repository is managed under the AGPL v3 license.

© devnote-dev 2021
