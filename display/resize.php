<?php
require 'vendor/autoload.php';
use Intervention\Image\ImageManager;

class Resize
{
    function __construct($file, $category, $size)
    {
        $manager = new ImageManager(array('driver' => 'imagick'));

        $path = "../img/" . $category . "/" . $file;

        if (is_file($path)) {
            echo $manager->make($path)->response();
            exit;
        }

        $image = $manager->make("../img/" . $file);

        $width = $image->width();
        $height = $image->height();

        if(max($width, $height) <= $size) {
            echo $image->response();
            exit();
        }

        $image->resize($width >= $height ? $size : null, $width < $height ? null : $size, function ($constraint) {
            $constraint->aspectRatio();
        });

        if(!is_dir("../img/" .$category)) {
            mkdir("../img/" .$category);
        }

        $image->save($path);

        echo $image->response();

    }
}

new Resize($_GET["img"], $_GET["cat"], $_GET["size"]);