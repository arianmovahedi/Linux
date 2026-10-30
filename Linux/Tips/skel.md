# Skel file and Directory
The `/etc/skel` directory hosts the values of the default `.profile`, `.bashrc` and the `.bash_logout` file that are added to the users home directory when they are created.

We can change the folder that the `useradd` command points to when creating the new users in the `/etc/default/adduser` config file. 

All the files in this directory is copied (not linked) to the users home directory when they are added with the `-m` flag in the `useradd` command.