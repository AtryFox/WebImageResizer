<?php
require 'vendor/autoload.php';
use Intervention\Image\ImageManager;

class Resize
{
    function __construct($file, $category, $size)
    {
        function err($status) {
            header("HTTP/1.0 " . $status);
            echo "<h1>" . $status . "</h1>";
            exit;
        }

        $manager = new ImageManager(array('driver' => 'imagick'));

        $categoryPath = "../img/" . $category . "/" . $file;
        $fullPath = "../img/" . $file;

        if (!is_file($fullPath)) {
            err("404 Not Found");
        }

        if (is_file($categoryPath)) {
            try {
                echo $manager->make($categoryPath)->response();
                exit;
            } catch (Exception $exception) {
                err("415 Unsupported Media Type");
            }
        }

        try {
            $image = $manager->make($fullPath);
        } catch (Exception $exception) {
            err("415 Unsupported Media Type");
        }

        $width = $image->width();
        $height = $image->height();

        if (max($width, $height) <= $size) {
            echo $image->response();
            exit();
        }

        $image->resize($width >= $height ? $size : null, $width >= $height ? null : $size, function ($constraint) {
            $constraint->aspectRatio();
        });

        if (!is_dir("../img/" . $category)) {
            mkdir("../img/" . $category);
        }


        try {
            $image->save($categoryPath);
        } catch (Exception $exception) {
        }

        echo $image->response();

    }
}

new Resize($_GET["img"], $_GET["cat"], $_GET["size"]);