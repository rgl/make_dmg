This lets you create OS X dmg files.

This is normally used to create a dmg image that installs an application.

You can:

* include files
* include directories
* include symbolic links
* set the volume icon
* set the volume name
* set a background image
    * from a gimp xcf file (recommended)
    * from a png or jpeg file
* set the icon size
* set the window location

Its recommended to use [gimp](http://www.gimp.org) to create the background image and set the icon positions.

Unlike other approaches, this does not uses apple script to layout the icons on the Finder window.  Instead it uses the excelent [DSStore library](http://www.hhhh.org/src/hg/dsstore) (*embeded inside*).


# Example

In this example we'll create a simple dmg image. It will contains an application that opens a web page. 

These commands should be run on a OS X Terminal.

Lets go!

Start by getting `make_dmg`:

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

**NB** those numbers, e.g. `144,144`, are the coordinates for center of the corresponding file or symlink icon.

**NB** its recommended that you use gimp to layout the icons, see the gimp section bellow.

And try it out:

    open MyApp.dmg

**NB** if you don't see the background image, try to recreate the dmg after changing its type:

    sed -i '' -e 's,type => 5,type => 4,g' make_dmg

**NB** I'm still looking for a way to automatically set the correct dmg type.


# gimp

Instead of manually setting the icon positions on the command line, you should use gimp to create a xcf file.  The file will contain the icon positions *and* the background image.

The creation of a dmg image is now much simplier:

    ./make_dmg \
        `./make_dmg_image_from_xcf example.xcf` \
        -convert UDBZ \
        MyApp.dmg

Have a look at the included `example.xcf` file.

## gimp layers

Gimp layers are used to position the icons.  The layer name is interpreted.  If the name ends with:

* `-hide`

    the layer is hidden from the rendered output file.

* `-file`

    a make_dmg `-file` parameter is generated.  for example, if the layer name is:

        MyApp.app -file

    the following make_dmg paramenters are generated:

        -file <layer_center_x_coordinate>,<layer_center_y_coordinate> MyApp.app
        -icon-size <layer_width>

    **NB** the `-iconsize` will be set to the layer width.

* `-symlink`

    same as `-file` argument described above, but with `-symlink` text.
