# Blog_Album
* 博客的相册源文件备份
* 文件夹结构. album下的内容, 存放所有的图片, 在七牛[http://photo.yanss.top/album.zip](http://photo.yanss.top/album.zip)下载解压
```
D:.
├─album
│  ├─game
│  │  ├─min_pic
│  │  └─pic
│  └─photo
│     ├─min_pic
│     └─pic
├─game
│  ├─min_pic
│  └─pic
└─photo
   └─min_pic
   └─pic
```

* 添加新图片后的提交命令. `release.sh`
```sh
#!/bin/bash
cd /Users/yanss/Documents/Blog/Blog_Album
#删除占位文件
rm -f -v /Users/yanss/Documents/Blog/Blog_Album/photo/pic/README.md
rm -f -v /Users/yanss/Documents/Blog/Blog_Album/photo/min_pic/README.md
rm -f -v /Users/yanss/Documents/Blog/Blog_Album/game/pic/README.md
rm -f -v /Users/yanss/Documents/Blog/Blog_Album/game/min_pic/README.md
#生成缩略图
python compress.py
#上传新图片
python upload-files-to-qiniu.py photo/pic
python upload-files-to-qiniu.py min_photos/ photo/min_pic
python upload-files-to-qiniu.py game/pic
python upload-files-to-qiniu.py min_photos/ game/min_pic
#移动新图片到album下
if [ "`ls photo/pic/`" != "" ]; then
  mv photo/pic/* album/photo/pic/ 
fi
if [ "`ls photo/min_pic/`" != "" ]; then
  mv photo/min_pic/* album/photo/min_pic/
fi
if [ "`ls game/pic/`" != "" ]; then
  mv game/pic/* album/game/pic/
fi
if [ "`ls game/min_pic/`" != "" ]; then
  mv game/min_pic/* album/game/min_pic/
fi
#生成json文件
python make-json.py
#压缩备份album文件夹
python zip.py
#上传压缩文件（可以不用每次都上传）
python upload-files-to-qiniu.py album.zip
#生成占位文件
echo "这是一个占位文件！" > photo/pic/README.md
echo "这是一个占位文件！" > photo/min_pic/README.md
echo "这是一个占位文件！" > game/pic/README.md
echo "这是一个占位文件！" > game/min_pic/README.md
#上传到远程git仓库
git add .
git commit -m "add photos"
git push origin master
```

* 以下是两个独立的上传图片到七牛的功能
    * Feature: 拖拽单文件上传到[七牛云](https://portal.qiniu.com/create)并返回markdown格式外链, 脚本是`upload-a-file-to-qiniu(md).py`, 修改`access_key`, `secret_key`, `bucket`等参数后运行`python upload-a-file-to-qiniu(md).py filename`即可，filename为待上传file路径，window环境下可以将图片拖拽到`drag-file-on-me.bat`上直接运行.
    * Feature: 批量上传到七牛云，脚本是`upload-files-to-qiniu.py`, 用法`python upload-files-to-qiniu.py a/ dir`,  可以把本地dir路径下的文件(dir可以是文件夹)上传到对应bucket下，并且前缀是`a/`. 或者写`/a`, 则上传后不带前缀.

> 以上使用七牛云脚本必须先安装python3.6环境，然后安装七牛SDK Python版`pip install qiniu`



* 若要上传视频，会比较麻烦，有以下步骤。
  1. 对视频片段截图，作为视频封面，图片名和视频名相同
  2. 将封面图片作为普通照片压缩、上传、移动到/album
  3. 将视频上传
  4. 在/album/photo/中删除封面图片，将视频文件移动到此目录下
  5. 同步blog_album和blog_source仓库