#!/bin/bash


function fixperms() {

#made this to quickly fix file permissions

sudo -v;

# Files
chmod -R 777 /nas/files/*;
chown nobody:nobody /nas/files/*;

# Media
chmod -R 777 /nas/media/*;
chown nobody:nobody /nas/media/*;

#Media2
chmod -R 777 /nas/media2/*;
chown nobody:nobody /nas/media2/*;

}
