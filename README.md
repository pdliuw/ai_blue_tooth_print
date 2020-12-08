# ai_blue_tooth_print

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_blue_tooth_print/blob/master/README-EN.md)|[中文文档](https://github.com/pdliuw/ai_blue_tooth_print)|
|:-|:-|

## 我们的宗旨是：帮助开发者更加便利开发、切身体会编程之美！

### ai_blue_tooth_print:

[![pub package](https://img.shields.io/pub/v/ai_blue_tooth_print.svg)](https://pub.dev/packages/ai_blue_tooth_print)



[ai_blue_tooth_print](https://github.com/pdliuw/ai_blue_tooth_print) 在[项目](https://github.com/flutter-app-sample/flutter_app_sample)中的实战应用[flutter sample](https://github.com/flutter-app-sample/flutter_app_sample)

## 效果图




## 1.安装

使用当前包作为依赖库

### 1. 依赖此库

在文件 'pubspec.yaml' 中添加

[![pub package](https://img.shields.io/pub/v/ai_blue_tooth_print.svg)](https://pub.dev/packages/ai_blue_tooth_print)

```

dependencies:

  ai_blue_tooth_print: ^version

```

或以这种方式添加

```

  # blue tooth print plugin.
  ai_blue_tooth_print:
    git:
      url: https://github.com/pdliuw/ai_blue_tooth_print.git

```

### 2. 安装此库

你可以通过下面的命令行来安装此库

```

$ flutter pub get


```

你也可以通过项目开发工具通过可视化操作来执行上述步骤

### 3. 导入此库

现在，在你的Dart编辑代码中，你可以使用：

```

import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';


```

## 2.使用

### 1.在你的项目需要打印的地方调用：

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



* 更多用法[点击，查看更多](https://github.com/pdliuw/ai_blue_tooth_print/blob/master/README_DETAIL.md)

### 待办

* 支持： macOS.


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

