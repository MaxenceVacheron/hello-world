touch /usr/share/hal/fdi/information/20thirdparty/30-keymap-private.fdi
echo '?xml version="1.0" encoding="ISO-8859-1"?> <!-- -*- SGML -*- -->

<deviceinfo version="0.2">
  <device>

    <match key="@input.originating_device:info.linux.driver" string="atkbd">
      <match key="/org/freedesktop/Hal/devices/computer:system.hardware.vendor" prefix="Hewlett-Packard">
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.product" contains="6530b">
          <!-- HP Compaq 6530b -->
          <append key="input.keymap.data" type="strlist">e012:brightnessdown</append>
          <append key="input.keymap.data" type="strlist">e017:brightnessup</append>
        </match>
      </match>
    </match>
  </device>
</deviceinfo>' >> /usr/share/hal/fdi/information/20thirdparty/30-keymap-private.fdi

xrandr --output LVDS --set BACKLIGHT_CONTROL native

