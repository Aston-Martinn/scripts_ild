#!/bin/bash

# The Build Script by Advaith Bhat

# Copyright (C) 2021 github.com/Aston-martinn

# Licensed under the GNU General Public License, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# https://github.com/Aston-Martinn/Scripts//blob/master/LICENSE

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Colours
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
green='\033[32m'
nocol='\033[0m'

# Print Aston-martinn
echo -e "$red  █████╗ ███████╗████████╗ ██████╗ ███╗   ██╗      ███╗   ███╗ █████╗ ██████╗ ████████╗██╗███╗   ██╗███╗   ██╗$nocol"
echo -e "$red ██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║      ████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██║████╗  ██║████╗  ██║$nocol"
echo -e "$red ███████║███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗██╔████╔██║███████║██████╔╝   ██║   ██║██╔██╗ ██║██╔██╗ ██║$nocol"
echo -e "$red ██╔══██║╚════██║   ██║   ██║   ██║██║╚██╗██║╚════╝██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██║██║╚██╗██║██║╚██╗██║$nocol"
echo -e "$red ██║  ██║███████║   ██║   ╚██████╔╝██║ ╚████║      ██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ██║██║ ╚████║██║ ╚████║$nocol"
echo -e "$red ╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝$nocol"
# Simple bash script to compile TenX-OS

# Checks for Mega & Gdrive
echo -e "Checking for Google Drive ...."
if [[ -f /usr/local/bin/gdrive ]]; then
    echo -e "GDrive is installed"
else
    echo -e "GDrive is not installed"
    echo -e "Would you like to install GDrive?"
    select yn in "Yes" "No"; do
    case $yn in
    Yes)
       git clone --quiet https://github.com/usmanmughalji/gdriveupload > /dev/null
       chmod +x gdrive
       sudo install gdrive /usr/local/bin/gdrive
       break
       ;;
    No)
       break
       ;;
    *)
       break
       ;;
       esac
    done
fi

echo -e "Checking for Mega ..."
if [[ -f /usr/local/bin/rmega-up ]]; then
    echo -e "Mega is installed"
else
    echo -e "Mega is not installed"
    echo -e "Would you like to install Mega?"
    select yn in "Yes" "No";
    do
      case $yn in
      Yes)
       sudo apt-get install ruby gem
       sudo gem install rmega
       break
       ;;
    No)
       break
       ;;
    *)
       break
       ;;
       esac
    done
fi

# Host
if [[ -d /home/kuntao ]];
then
    echo -e "Enter the Host name: "
read host
fi

while true;
do
  case $host in
      AdvaithBhat)
      echo "Enter the BOT API Key"
      read -s -r key

      TG_BOT_API_KEY=$key
      TG_CHAT_ID=-1001519597877

      [[ -z "${TG_BOT_API_KEY}" ]] && echo "BOT_API_KEY not defined, exiting!" && exit 1
      function sendTG() {
              curl -s "https://api.telegram.org/bot${TG_BOT_API_KEY}/sendmessage" --data "text=${*}&chat_id=${TG_CHAT_ID}&parse_mode=Markdown" >/dev/null
      }

      sendTG "Initializing the Build Script"
      break
      ;;
      *)
      break
      ;;
  esac
done

cd ~

# Device name
function device_name() {
    echo -e "Enter your Device Name: "
    echo -e "NOTE: Device name should be in lower cases only!!"
    read device
    echo -e "Entered parameter was $device"
}

# Device codename
function device_codename() {
    echo -e "Enter your Device Codename: "
    echo -e "Available codenames are:"
    echo -e "\n 1. RMX2121 \n 2. kebab"
    read codename
    echo -e "Entered parameter was $codename"
}

function rom_name() {
    echo -e "Supported ROM's are "
    echo -e " \n 1. TenX-OS \n 2. PixelExperience \n 3. Lineage-OS \n"
    echo -e "Enter the ROM you would like to Compile?"
    echo -e "Format is: "
    echo -e "\n tenx \n pe \n los \n"
    read rom_name
    echo -e "Entered parameter was $rom_name"

    case $rom_name in
        tenx)
            mkdir tenx && cd tenx
            sendTG "Syncing TenX-OS"
            repo init -u git://github.com/TenX-OS/manifest_TenX -b eleven
            repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
            ;;
        pe)
            mkdir pe && cd pe
            sendTG "Syncing PixelExperience"
            repo init -u https://github.com/PixelExperience/manifest -b eleven
            repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
            ;;
        los)
            mkdir los && cd los
            sendTG "Syncing Lineage-OS"
            repo init -u git://github.com/LineageOS/android.git -b lineage-18.1
            repo sync
            ;;
        *)
            echo -e "Enter parameter is not available"
            exit 1
            ;;
    esac
}

# make build if Trees exists
if [[ -f /$rom_name/device/$device/$codename ]] && [[ -f /$rom_name/vendor/$device/$codename ]]; then
    build_type
fi

# Clone my private TenX sources
function check_tenx() {
    if [[ -d /home/kuntao ]];
    then
        if [ $codename == RMX2121 ] && [ $rom_name == tenx ]; then
            rm -rf frameworks/base
            rm -rf packages/apps/Settings
            rm -rf packages/apps/TenX
            rm -rf vendor/overlays/Elegance

            git clone --quiet git@github.com:TenX-OS-Beta/frameworks_base.git frameworks/base > /dev/null
            git clone --quiet git@github.com:TenX-OS-Beta/vendor_overlays_Elegance.git vendor/overlays/Elegance > /dev/null
            git clone --quiet git@github.com:TenX-OS-Beta/packages_apps_Settings.git packages/apps/Settings > /dev/null
            git clone --quiet git@github.com:TenX-OS-Beta/packes_apps_TenX.git packages/apps/TenX > /dev/null
        fi
    fi
}

# Clone device trees
function clone_trees() {
    if [ $device == realme ] && [ $codename == RMX2121 ]; then
        git clone https://github.com/Realme-X7-Pro-Developers/device_realme_RMX2121.git device/realme/RMX2121
        git clone https://github.com/Realme-X7-Pro-Developers/vendor_realme_RMX2121.git vendor/realme/RMX2121
    else
        if [ $device != realme ]; then
           if [ $device != oneplus ]; then
              if [ $codename != RMX2121 ]; then
                  if [ $codename != kebab ]; then
                    echo -e "Enter your Device Tree link: "
                    read device_tree
                    echo -e "Enter your Device Tree branch"
                    read device_tree_branch
                    echo -e "Enter your Vendor Tree link: "
                    read vendor_tree
                    echo -e "Enter your Vendor Tree branch"
                    read vendor_tree_branch
                    echo "Do you use prebuilt kernel?"
                    select yn in "Yes" "No";
                    do
                    case $yn in
                    Yes)
                       break
                       ;;
                    No)
                       echo -e "Enter your Kernel Tree link: "
                       read kernel_tree
                       echo -e "Enter your Kernel Tree branch"
                       read kernel_tree_branch
                       break
                       ;;
                      esac
                    done

                    echo -e "Cloning Device Tree"
                    git clone --quiet $device_tree -b $device_tree_branch device/$device/$codename > /dev/null
                    echo -e "Kernel path uses platform or codename?"
                    select yn in "Yes" "No";
                    do
                      case $yn in
                      Yes)
                         echo -e "Enter device platform"
                         read platform
                         git clone --quiet $kernel_tree -b kernel/$device/$platform
                         break
                         ;;
                      No)
                         git clone --quiet $kernel_tree -b kernel/$device/$codename > /dev/null
                         break
                         ;;
                      esac
                    done

                    echo -e "Has common vendor?"
                    select yn in "Yes" "No";
                    do
                      case $yn in
                      Yes)
                         git clone --quiet $vendor_tree -b $vendor/$device/
                         break
                         ;;
                      No)
                         git clone --quiet $vendor_tree -b $vendor/$device/$codename > /dev/null
                         break
                         ;;
                      esac
                    done
                 fi
              fi
           fi
        fi
    fi
}

# Clean build
function build_type() {
    echo -e "Do you want to make a Clean build?"
    echo -e "Typing Yes would make a Clean Build"
    echo -e "Typing No would make a Dirty Build"
    select yn in "Yes" "No";
    do
      case $yn in
      Yes)
         echo -e "Making a Clean build..."
         . build/envsetup.sh
         make clean
         make clobber
         break
         ;;
      No)
         . build/envsetup.sh
         make installclean
         echo -e "Making a Dirty build"
         break
         ;;
      *)
         break
         ;;
       esac
    done
}

# Compile
function compile() {
    if [ $rom_name == tenx ]; then
       sendTG "Compiling TenX-OS for
       ▪️️️Device: \`Realme X7 Pro\`
       ▪️Codename: \`RMX2121\`
       ▪️Host: \`Advaith Bhat\`
       ▪️Host-Machine: \`Kuntao-server\`"
       . build/envsetup.sh
       if [ $host == AdvaithBhat ] && [ $codename == RMX2121 ]; then
          export CUSTOM_BUILD_TYPE=Official
       fi
       lunch aosp_$codename-userdebug
       export USE_CCACHE=1
       ccache -M 30G
       brunch $codename
    elif [ $rom_name == pe ]; then
       sendTG "Compiling PixelExperience for
       ▪️️️Device: \`Realme X7 Pro\`
       ▪️Codename: \`RMX2121\`
       ▪️Host: \`Advaith Bhat\`
       ▪️Host-Machine: \`Kuntao-server\`"
       . build/envsetup.sh
       lunch aosp_$codename-userdebug
       export USE_CCACHE=1
       ccache -M 30G
       brunch $codename
    else
       sendTG "Compiling Lineage-OS for
       ▪️️️Device: \`Realme X7 Pro\`
       ▪️Codename: \`RMX2121\`
       ▪️Host: \`Advaith Bhat\`
       ▪️Host-Machine: \`Kuntao-server\`"
       . build/envsetup.sh
       lunch lineage_$codename-userdebug
       export USE_CCACHE=1
       ccache -M 30G
       brunch $codename
    fi
}

# Upload
function upload() {
    cd out/target/product/$codename
    echo -e "Where would you like to upload? "
    echo -e "Available options are: "
    echo -e " \n 1. GDrive \n 2. Mega"
    echo -e " Format is: "
    echo -e " \n gdrive \n mega"
    read upload

    case $upload in
        gdrive)
        if [ $rom_name == tenx ]; then
            gdrive upload *.zip
        elif [ $rom_name == pe ]; then
            gdrive upload *.zip
        else
            gdrive upload *.zip
        fi
        ;;
        mega)
        echo -e "Enter you email associated with Mega"
        read email
        if [ $rom_name == tenx ]; then
            rmega-up *.zip -u $email
        elif [ $rom_name == pe [; then
            rmega-up *.zip -u $email
        else
            rmega-up *.zip -u $email
        fi
    esac
}

device_name
device_codename
rom_name
check_tenx
clone_trees
build_type
compile
upload
