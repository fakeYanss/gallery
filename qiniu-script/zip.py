import zipfile
import os

startdir = 'album'
file_news = startdir + '.zip'
z = zipfile.ZipFile(file_news, 'w', zipfile.ZIP_DEFLATED)
for dirpath, dirnames, filenames in os.walk(startdir):
    fpath = dirpath.replace(startdir, '')
    fpath = fpath and fpath + os.sep or ''
    for filename in filenames:
        z.write(os.path.join(dirpath, filename),fpath+filename)
        print ('压缩成功' + filename)
z.close()
