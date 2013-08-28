# The PHPshow Environment

This repository contains almost everything you need to quickly get up and running with a virtual machine so you can follow along and experiment on your own.

## Requirements

The environment we're using is based on a [Vagrant](http://www.vagrantup.com/ "Vagrant") virtual machine that we've built, containing a working installation of [nginx](http://nginx.org/en/download.html "nginx"), [PHP 5.5.3](http://php.net/downloads.php), and [MySQL 5.6.13](http://dev.mysql.com/downloads/mysql/ "MySQL Server").

To run this environment you will only need the following installed on your computer:

* [Git](http://git-scm.com/downloads)
* [Vagrant](http://downloads.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Be sure to download and install the latest version of each.

You do not need to download and install nginx, PHP, or MySQL. However, if you'd prefer to build your own environment, or want to use a different web server, feel free to do so, but please remember that PHPshow content has only been tested using this standard setup.

## Setup

To watch me get my environment set up, [see this video](http://youtube.com/ "PHPshow: Setup your environment").

* Clone this repository, or download and extract the [zip file](https://github.com/3ft9/phpshow/archive/master.zip "The latest PHPshow Environment in a zip file"). Cloning is recommended so you can easily keep up to date.
* Open a terminal/command window in the resulting directory.
* Run "vagrant up" (without quotes).

Vagrant will now download the virtual machine image which is quite large (~400MB at the time of writing). It will only do this once. When the download has finished it will create and start the virtual machine, eventually telling you that it is ready for use.

While that's running add the following line to your /etc/hosts file, or on Windows the file is in C:\windows\system32\drivers\etc\hosts (note that you'll need to be an administrator to edit this file):

    127.0.0.1 phpshow.local

If you are unable to edit your hosts file you can also use local.phpshow.tv which we've configured to point to 127.0.0.1, but you may need internet access whenever you want to use your local site. If you need to do this simply replace phpshow.local with local.phpshow.tv whenever it's mentioned.

Open your browser and go to http://phpshow.local:8080/ and you should see the welcome page.

## Configuration

You don't need to do anything more to configure the environment.

The PHP configuration can be seen at http://phpshow.local:8080/info.php. It's set up to use the default production ini file from the PHP distribution, but overrides the settings for error reporting, display and logging to display all errors and disable logging.

## Chef Recipes

Just a quick note on the recipes: aside from build-essential, these are custom recipes that have not been built to be reusable and there's certainly room for improvement. Beneficial patches will be most welcome.

## Questions?

If you have any questions regarding this repository please use the contact form on http://phpshow.tv.

## What is PHPshow?

PHPshow is an series of screencasts produced by [3ft9 Ltd](http://3ft9.com/ "3ft9 Ltd") with the goal of promoting knowledge and best practices within the PHP community. Please see the [PHPshow website](http://phpshow.tv "The PHPshow Website") for more information.