# hello-world
first try


now trying smtg new

## Code command not working


 was having the same issue and I am guessing the installation directory of VScode was moved during the VScode update (I think that's when it stopped working for me). Anyway, this is what I added to my .zshrc file to make it work:

 export PATH="/usr/share/code/bin:$PATH"

## Horizontal Scroll Fix Directions

I also encountered this issue upon upgrading to 18.04, this was my solution:

Use xinput list to find the device id of your touchpad.

Use xinput list-props yourdeviceid. This will produce a long list of all the properties you can edit for that device. We're interested in a property to do with scrolling distance, on my system this is Synaptics Scrolling Distance (283). It should have two values, on my system (with natural scrolling enabled) these were -115, 115 (vertical distance, horizontal distance). Note the value in the parentheses, in my case 283, it's how we'll identify the property to change it.

Use xinput set-prop yourdeviceid 283 -115, -115, replacing 283 and the scrolling distance values with whatever is appropriate. (The change is to make both values negative, which gives the desired result of "natural" scrolling.)

Notes:
This setting will not persist across system restarts, which is an issue all on its own. I use a .xsessionrc file in my home directory to execute the xinput command on startup.
This will probably not work in 17.10, since Wayland does strange things to xinput.
