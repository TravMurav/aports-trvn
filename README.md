# repo.trvn.ru/alpine/custom

This is a custom Alpine repo for random experiments of mine.
It mostly uses [pmbootstrap]() as a nice Alpine build toolkit wrapper
since that's what I have on hand right now.

Quality of those packages is not guaranteed, the repo is provided AS IS.

## Installing:

Add `travmurav@trvn.ru.rsa.pub` to your apk keychain:
```
sudo cp travmurav@trvn.ru.rsa.pub /etc/apk/keys/
```

Add the repo url to `repositories`:
```
sudoedit /etc/apk/repositories
# add http://repo.trvn.ru/alpine/custom
```



