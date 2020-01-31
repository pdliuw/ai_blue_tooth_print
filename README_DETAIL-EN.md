# ai_blue_tooth_print 

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_blue_tooth_print/blob/master/README-EN.md)|[中文文档](https://github.com/pdliuw/ai_blue_tooth_print)|
|:-|:-|

## Our aim is to help developers make development more convenient and experience the beauty of programming!

### ai_blue_tooth_print:

[![pub package](https://img.shields.io/pub/v/ai_blue_tooth_print.svg)](https://pub.dev/packages/ai_blue_tooth_print)



[ai_blue_tooth_print](https://github.com/pdliuw/ai_blue_tooth_print) in the[Project](https://github.com/flutter-app-sample/flutter_app_sample)Practical application[flutter sample](https://github.com/flutter-app-sample/flutter_app_sample)

## effect




## 1.Installation

Use the current package as a dependent library

### 1. Rely on this library

Add in file 'pubspec.yaml'

[![pub package](https://img.shields.io/pub/v/ai_blue_tooth_print.svg)](https://pub.dev/packages/ai_blue_tooth_print)

```

dependencies:

  ai_blue_tooth_print: ^version

```

or

```

  # blue tooth print plugin.
  ai_blue_tooth_print:
    git:
      url: https://github.com/pdliuw/ai_blue_tooth_print.git

```

### 2. Install this library

You can install this library via the command line below

```

$ flutter pub get


```

You can also perform the above steps through the visual operation through the project development tool


### 3. Import this library

Now, in your Dart editing code, you can use:

```

import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';

```

## 2.Usage

### 1.Call where your project needs to print:


ai_blue_tooth_print 

```

    AiBlueToothPrint.print(arrayInfo: [
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
    ]);


```


### TODO

* Support ios、macOS.



## LICENSE


    BSD 3-Clause License
    
    Copyright (c) 2020, pdliuw
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    1. Redistributions of source code must retain the above copyright notice, this
       list of conditions and the following disclaimer.
    
    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.
    
    3. Neither the name of the copyright holder nor the names of its
       contributors may be used to endorse or promote products derived from
       this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


