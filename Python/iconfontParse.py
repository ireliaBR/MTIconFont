#!/usr/bin/env python
# -*- coding: utf-8 -*-
from biplist import readPlist
import sys


def dictToHtml(map):
    strs = ''
    for key in map:
        value = map[key]
        if isinstance(value, str):
            strs += '<div class="col-md-2 box"><i class="iconfont">&#x' \
                   + map[key][2:] \
                   + '</i><div class="name">' \
                   + key \
                   + '</div><div class="code">' \
                   + map[key] \
                   + '</div></div>'

    for key in map:
        value = map[key]
        if isinstance(value, dict):
            strs += '<div class="col-md-12 group-title h3">' + key + '</div>'
            strs += dictToHtml(value)
            continue


    return strs


plistfilepath = sys.argv[1]
map = readPlist(plistfilepath)


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

      .group-title {
        margin-left: 3%;
        padding-top: 3%;
        color: red;
        border-top-width: 1px;
        border-top-color: black;
        border-top-style: solid;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
''')

htmlStr = dictToHtml(map)
file.write(htmlStr)

file.write('''
      </div>
    </div>
  </body>
</html>
''')

file.close()
