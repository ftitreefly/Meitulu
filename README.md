# Meitulu.com Website Resources Downloader

A website resoucres downloader for site: Meitulu.com, super fast download speed by aria2c.



```bash
$ ./Meitulu

Usage:  <command> [options]

Meitulu.com website resourses downloader.

Commands:
  album           CLI tools for show and download albums.
  tag             CLI tools for show and download tags.
  help            Prints help information
  version         Prints the current version of this app
```



## How to use — album command

```bash
$ ./Meitulu album -h
Usage:  album <id> [options]

CLI tools for show and download albums.

Options:
  -d, --download    Download album
  -h, --help        Show help information
```



- Show a album information.

```bash
$ ./Meitulu album 18131
[XIAOYU语画界] Vol.034 女神@Angela喜欢猫丝袜美腿写真[51P]_美图录
https://mtl.ttsqgs.com/images/img/18131/1.jpg
...
https://mtl.ttsqgs.com/images/img/18131/51.jpg
```




- Download a album. Default folder **~/Downloads/**

```bash
$./Meitulu album 18131 --download
start downloading
```

## How to use — tag command

```bash
$ ./Meitulu tag -h

Usage:  tag <tagString> [options]

CLI tools for show and download tags.

Options:
  -d, --download                  Download album
  -h, --help                      Show help information
  -p, --number-of-page <value>    Specify the number of page.
```

- show a tag info.

```bash
$ ./Meitulu tag qizhi
18414 [Ugirls尤果圈] No.1482 Coral - 性感留下 写真套图
18410 [Ugirls尤果圈] No.1478 Chelesa - 梦蔷薇 写真套图
18390 [Ugirls尤果圈] No.1458 欣凌 - 心电心 写真套图
18351 [Kelagirls克拉女神] 依娜丝 - 水晶透趾 写真套图
18350 [Kelagirls克拉女神] 诺雅 - 娉婷袅娜 写真套图
...
15623 [台湾正妹] Winnie小雪 - 晚礼服美腿写真
15520 [XINGYAN星颜社] Vol.066 丽质美女@卓雅首套写真
TAG：qizhi. PAGE: 1/21. WITH '-p <Int>' FOR MORE.
```

- download all the albums in a tag  group. with '-p <int>' flag for more. Default save folder **~/Downloads/**

```bash
$ ./Meitulu tag qizhi -d -p 2
start download all the albums with page 2 in the tag group.
```

