This lets you create OS X dmg files.

Unlike other approaches, this does not uses apple script to layout the icons on the Finder window.  Instead it uses the excelent [DSStore library](http://www.hhhh.org/src/hg/dsstore) (*embeded inside*).


# Example

In this example we'll create a simple dmg image. It will contains an application that opens a web page. 

These command should be run at a OS X Terminal.

Lets go!

Start by getting make_dmg:

    hg clone https://bitbucket.org/rgl/make_dmg
    cd make_dmg

Get a sample background image:

    curl -O http://cdn.bitbucket.org/rgl/make_dmg/downloads/background.png

Create a simple Application Bundle:

    mkdir -p MyApp.app/Contents/MacOS
    printf '#!/bin/sh\nopen https://bitbucket.org/rgl/make_dmg\n' > MyApp.app/Contents/MacOS/MyApp
    chmod +x MyApp.app/Contents/MacOS/MyApp

Try it, it should open the web browser:

    open MyApp.app

Finally, create the dmg image:

    ./make_dmg \
        -image background.png \
        -file 144,144 MyApp.app \
        -symlink 416,144 /Applications \
        -convert UDBZ \
        MyApp.dmg

**NB** those numbers, e.g. `144,144`, are the coordinates for center of the icon.

And try it out:

    open MyApp.dmg

**NB** if you don't see the background image, try to recreate the dmg after changing the type of image with:

    sed -i -E 's,type => 5,type => 4,g' make_dmg

**NB** I'm still looking for a way to automatically set the correct dmg type.

**NB** I'm working on a script to automatically generate the `.png` file, `-file` and `-symlink` arguments from a [GIMP](http://gimp.org) xcf file.  You'll be able to layout everything in GIMP!
