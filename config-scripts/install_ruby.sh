#!/bin/bash
sudo apt update
sudo apt install -y ruby-full
sudo apt install -y ruby-bundler
sudo apt install -y build-essential
ruby -v
bundler -v
