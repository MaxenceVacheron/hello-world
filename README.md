# hello-world
first try


now trying smtg new

## "**Code**" command not working


 was having the same issue and I am guessing the installation directory of VScode was moved during the VScode update (I think that's when it stopped working for me). Anyway, this is what I added to my .zshrc file to make it work:

 export PATH="/usr/share/code/bin:$PATH"

## Horizontal Scroll Fix Directions

### `xinput set-prop 12 373 -76, -76` 

Use xinput list to find the device id of your touchpad.

Use xinput list-props yourdeviceid. This will produce a long list of all the properties you can edit for that device. We're interested in a property to do with scrolling distance, on my system this is Synaptics Scrolling Distance (283). It should have two values, on my system (with natural scrolling enabled) these were -115, 115 (vertical distance, horizontal distance). Note the value in the parentheses, in my case 283, it's how we'll identify the property to change it.

Use xinput set-prop yourdeviceid 283 -115, -115, replacing 283 and the scrolling distance values with whatever is appropriate. (The change is to make both values negative, which gives the desired result of "natural" scrolling.)
