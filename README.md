WebImageResizer
===============

Simple tool to automatically resize uploaded images when demanded.

Made with the power of [Intervention Image](/Intervention/image).


## Requirements ##
* Apache 2
* mod_php5 or mod_php7.0
* mod_rewrite
* imagick


## Setup ##
Install the dependencies using composer:

```bash
cd ./display && php composer.phar install
```

Other then that, there is no setup needed. Just make the main folder of this repository accessible via HTTP or HTTPS.


## Using ##
Upload images to `./img/`.


## Example ##
Let's say, you upload an image named `foo_bar.png`.

You can access the original image, unscaled under `./foo_bar.png`.

If you want to a resized version, open `./[size]/foo_bar.png`.
Replace `[size]` with one of the following options:

| Size category  | Length of the longer side |
|---------|---------------------------|
|`thumb`  | 200px                     |
|`small`  | 500px                     |
|`medium` | 700px                     |
|`large`  | 1000px                    |

The resized images will be saved in `./img/[size]/foo_bar.png`.

To regenerate an image, add the force parameter in your URL like this: `./[size]/foo_bar.png?force`

## Configuring ##
At the moment there is no real way to configure this tool. You can change the size categories in `./.htaccess`, but keep in mind, that this file will be overwritten, if you update using *git* (which the update script does).

A more convenient way to configure this is planned.


## Updating ##
Just run `./update.sh`. Make sure to make it executable before running it for the first time.

**Note**: Running the update script will reset everything in the directory to the last commit in this repository#master, except for the `./img/` directory.