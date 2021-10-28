# hello-world
# This repo was made in order achieve a fast setup of my work environment. There is a bit of troublehsooting too. Feel free to copy, use, modify.

#Troubleshooting

## "**Code**" command not working


> I was having the same issue and I am guessing the installation directory of VScode was moved during the VScode update (I think that's when it stopped working for me). Anyway, this is what I added to my .zshrc file to make it work:

 `export PATH="/usr/share/code/bin:$PATH"`

## Horizontal Scroll Fix Directions

`xinput set-prop 12 373 -76, -76` 

> Use xinput list to find the device id of your touchpad.

> Use xinput list-props yourdeviceid. This will produce a long list of all the properties you can edit for that device. We're interested in a property to do with scrolling distance, on my system this is Synaptics Scrolling Distance (283). It should have two values, on my system (with natural scrolling enabled) these were -115, 115 (vertical distance, horizontal distance). Note the value in the parentheses, in my case 283, it's how we'll identify the property to change it.

> Use xinput set-prop yourdeviceid 283 -115, -115, replacing 283 and the scrolling distance values with whatever is appropriate. (The change is to make both values negative, which gives the desired result of "natural" scrolling.)

## Ignore Laptop Lid Closing

> To make Ubuntu do nothing when laptop lid is closed:

Open the /etc/systemd/logind.conf file in a text editor as root, for example,

```sudo -H gedit /etc/systemd/logind.conf```

If HandleLidSwitch is not set to ignore then change it:

``` HandleLidSwitch=ignore```

Make sure it's not commented out (it is commented out if it is preceded by the symbol #) or add it if it is missing,

Restart the systemd daemon (be aware that this will log you off) with this command:

```sudo systemctl restart systemd-logind```
or, from 15.04 onwards:

```sudo service systemd-logind restart```


## Video Issue
in 
```sudo vim /etc/X11/xorg.conf.d/20-intel.conf ```          
```
Section "Device"
   Identifier "Intel Graphics"
   Option "SwapbuffersWait" "true"
   Option "AccelMethod"  "sna"
   Option "TearFree" "true"
EndSection
```


## Super + Num conf

in ```dconf-editor /org/gnome/shell/keybindings```

Put ```['<Super>1']```



