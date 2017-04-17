#!/bin/bash -e 

# Version 1.1
clear

echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "Do you want to create WordPress MultiSite installation? (y/n)"
read -e multisite
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"

#download wordpress
echo "Downloading WordPress..."
wp core download

#Create wp-config.php file
echo "Creating a wp-config.php file with given credentials..."
wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass"

#Create Database
echo "Creating a database..."
wp db create

echo "Site URL: "
read -e url

echo "Site Title: "
read -e title

echo "Admin User: "
read -e adminUser

echo "Admin Password: "
read -s adminPassword

echo "Admin Email: "
read -e email

# Install WordPress
if [ "$multisite" == y ] ; then
    wp core multisite-install --url="$url" --title="$title" --admin_user="$adminUser" --admin_password="$adminPassword" --admin_email="$email"
else
    wp core install --url="$url" --title="$title" --admin_user="$adminUser" --admin_password="$adminPassword" --admin_email="$email"
fi    

# Install & Activate Plugins
declare -a plugins=("temporary-login-without-password" "icegram")
for i in "${plugins[@]}"
do
   echo "installing $i"
   wp plugin install "$i" --activate
done

# Install & Activate Themes
declare -a themes=("")
for i in "${themes[@]}"
do
   echo "installing $i" 
   wp theme install "$i" --activate
done

echo "========================="
echo "Installation is complete."
echo "========================="
fi