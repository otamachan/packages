#!/bin/bash
set -x
sudo /bin/sh -c 'echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list'
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 9E3E53F19C7DE460
sudo apt-get update
sudo apt-get install aptly
aptly config show
aptly repo create trusty
wget https://github.com/otamachan/ros-indigo-gazebo7-deb/releases/download/debian%2F7.4.0-1/ros-indigo-gazebo7_7.4.0-1_amd64.deb
wget https://github.com/otamachan/ros-indigo-sdformat4-deb/releases/download/debian%2F4.2.0-0_trusty1/ros-indigo-sdformat4_4.2.0-0.trusty1_amd64.deb
aptly repo add trusty *.deb
aptly publish repo -component="main" -distribution="trusty" -label="ROS indigo" -origin="otamachan" -skip-signing=true trusty
cd ${HOME}/.aptly/public
git init
git config user.name "Travis CI"
git config user.email "otamachan@mail.com"
git add * --all
git commit -m "Publish repository"
git push --force --quiet "https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" master:gh-pages > /dev/null 2>&1
