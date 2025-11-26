# Secrets-AppImage 🐧

WIP

## Known issue
- It doesn't launch on Alpine due to some `libusb` error from yubikey python module. Works fine in every `glibc` distro, no matter old or new:
```
📦[gidro@my-alpine Преузимања]$ ./Secrets-12.0-1-anylinux-x86_64.AppImage
SUID fusermount not found in PATH, trying to unshare...
Setting $XDG_DATA_HOME to "/home/gidro/Преузимања/Secrets-12.0-1-anylinux-x86_64.AppImage.share"
Setting $XDG_CONFIG_HOME to "/home/gidro/Преузимања/Secrets-12.0-1-anylinux-x86_64.AppImage.config"
Setting $XDG_CACHE_HOME to "/home/gidro/Преузимања/Secrets-12.0-1-anylinux-x86_64.AppImage.cache"
Setting $HOME to "/home/gidro/Преузимања/Secrets-12.0-1-anylinux-x86_64.AppImage.home"
 [anylinux.so] LOCALEFIX >> Failed to set locale, falling back to C locale.
Traceback (most recent call last):
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/application.py", line 133, in do_activate
    window = self.new_window()
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/application.py", line 79, in new_window
    window = Window(application=self)
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/widgets/window.py", line 49, in __init__
    self.key_providers = Providers(self)
                         ~~~~~~~~~^^^^^^
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/provider/providers.py", line 27, in __init__
    self.providers.append(key_provider(window))
                          ~~~~~~~~~~~~^^^^^^^^
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/provider/yubikey_provider.py", line 70, in __init__
    self.yubikeys = self.get_all_yubikeys(False)
                    ~~~~~~~~~~~~~~~~~~~~~^^^^^^^
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/gsecrets/provider/yubikey_provider.py", line 82, in get_all_yubikeys
    yubikey = yubico.find_yubikey(debug=debug, skip=_idx)
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/yubico/yubikey.py", line 53, in find_key
    hid_device = YubiKeyHIDDevice(debug, skip)
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/yubico/yubikey_usb_hid.py", line 123, in __init__
    if not self._open(skip):
           ~~~~~~~~~~^^^^^^
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/yubico/yubikey_usb_hid.py", line 317, in _open
    usb_device = self._get_usb_device(skip)
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/yubico/yubikey_usb_hid.py", line 366, in _get_usb_device
    devices = [usb.legacy.Device(d) for d in usb.core.find(
                                             ~~~~~~~~~~~~~^
        find_all=True, idVendor=YUBICO_VID)]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/tmp/.mount_Secreremp14104849546142800604/lib/python3.13/site-packages/usb/core.py", line 1321, in find
    raise NoBackendError('No backend available')
usb.core.NoBackendError: No backend available
```
