#!/bin/bash

# Library required for LCD Address: 0x21
pip install Adafruit_BBIO

# Patch required for DHT11 (Add RPi 4 support to adafruit library)
patch << EOF
--- platform_detect.py	2020-09-16 13:23:46.609992081 -0400
+++ /usr/local/lib/python3.7/dist-packages/Adafruit_DHT-1.4.0-py3.7-linux-armv7l.egg/Adafruit_DHT/platform_detect.py	2020-09-16 13:24:17.939870559 -0400
@@ -108,6 +108,9 @@
     elif match.group(1) == 'BCM2837':
         # Pi 3b+
         return 3
+    elif match.group(1) == 'BCM2711':
+        # Pi 4b
+        return 3
     else:
         # Something else, not a pi.
         return None
EOF

# Patch required for LED_Matrix
patch << EOF
--- serial.py	2020-09-16 13:27:54.358925663 -0400
+++ /usr/local/lib/python2.7/dist-packages/luma.core-1.12.0-py2.7.egg/luma/core/interface/serial.py	2020-09-16 13:27:16.119104294 -0400
@@ -278,7 +278,7 @@
         try:
             self._spi = spi or self.__spidev__()
             self._spi.open(port, device)
-            self._spi.cshigh = cs_high
+#            self._spi.cshigh = cs_high
         except (IOError, OSError) as e:
             if e.errno == errno.ENOENT:
                 raise luma.core.error.DeviceNotFoundError('SPI device not found')
EOF
