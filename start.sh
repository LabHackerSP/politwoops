#!/bin/bash

source ~/.bash_profile
cd /home/rails/politwoops
unicorn -D -c ./config/unicorn.rb & echo $! >./unicorn.pid
