#!/bin/bash
cd /Users/yanss/Documents/Blog/Blog_Album
rm -f -v photo/pic/README.md
rm -f -v photo/min_pic/README.md
rm -f -v game/pic/README.md
rm -f -v game/min_pic/README.md
python compress.py
python upload-files-to-qiniu.py photo/pic
python upload-files-to-qiniu.py min_photos/ photo/min_pic
python upload-files-to-qiniu.py game/pic
python upload-files-to-qiniu.py min_photos/ game/min_pic

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
python make-json.py
python zip.py
python upload-files-to-qiniu.py album.zip
echo "这是一个占位文件！" > photo/pic/README.md
echo "这是一个占位文件！" > photo/min_pic/README.md
echo "这是一个占位文件！" > game/pic/README.md
echo "这是一个占位文件！" > game/min_pic/README.md
git add .
git commit -m "add photos"
git push origin master
