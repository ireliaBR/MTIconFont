#!/usr/bin/env python
# -*- coding: utf-8 -*-
import xml.dom.minidom as xmldom
import sys

plistfilepath = sys.argv[1]

def parsePlistToDict(plistPath):
    dict = {}
    domobj = xmldom.parse(plistPath)
    elementobj = domobj.documentElement
    keys = elementobj.getElementsByTagName("key")
    strings = elementobj.getElementsByTagName("string")

    for i in range(len(keys)):
        key = keys[i].childNodes[0].data
        string = strings[i].childNodes[0].data
        dict[key] = string

    return dict



dict = parsePlistToDict(plistfilepath)

file = open("iconfont.html", "w+")
file.write('''
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">

    <title>Hello, world!</title>

    <style type="text/css">
      @font-face {
        font-family: 'iconfont';
        src: url('iconfont.eot');
        src: url('iconfont.eot?#iefix') format('embedded-opentype'),
        url('iconfont.woff') format('woff'),
        url('iconfont.ttf') format('truetype'),
        url('iconfont.svg#iconfont') format('svg');
      }

      .iconfont{
        font-family:"iconfont" !important;
        font-size:42px;
        font-style:normal;
        -webkit-font-smoothing: antialiased;
        -webkit-text-stroke-width: 0.2px;
        -moz-osx-font-smoothing: grayscale;
      }

      .box {
        text-align: center;
      }

      .code {
        color: #17bbb0;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
''')

for i in dict:
    str = '<div class="col-md-2 box"><i class="iconfont">&#x' + dict[i][2:] + '</i><div class="name">' + i + '</div><div class="code">' + dict[i] + '</div></div>'
    file.write(str)

file.write('''
</div>
    </div>
  </body>
</html>
''')

file.close()
