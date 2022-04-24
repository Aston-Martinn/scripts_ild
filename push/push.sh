#!/bin/bash

BRANCH=twelve
echo "Pushing all the Repos"

cd device/tenx/sepolicy > /dev/null
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_device_tenx_sepolicy.git HEAD:$BRANCH > /dev/null
cd ../../..

cd device/qcom/sepolicy
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_device_qcom_sepolicy.git HEAD:$BRANCH > /dev/null
cd ../../..

cd device/qcom/sepolicy_vndr
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_device_qcom_sepolicy_vndr.git HEAD:$BRANCH > /dev/null
cd ../../..

cd device/qcom/sepolicy-legacy-um
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_device_qcom_sepolicy_vndr.git HEAD:$BRANCH > /dev/null
cd ../../..

cd vendor/tenx
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_vendor_tenx.git HEAD:$BRANCH > /dev/null
cd ../..

cd external/selinux
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_external_selinux.git HEAD:$BRANCH > /dev/null
cd ../..

cd frameworks/av
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_frameworks_av.git HEAD:$BRANCH > /dev/null
cd ../..

cd frameworks/native
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_frameworks_native.git HEAD:$BRANCH > /dev/null
cd ../..

cd hardware/interfaces
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_hardware_interfaces.git HEAD:$BRANCH > /dev/null
cd ../..

cd hardware/libhardware
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_hardware_libhardware.git HEAD:$BRANCH > /dev/null
cd ../..

cd system/vold
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_system_vold.git HEAD:$BRANCH > /dev/null
cd ../..

cd system/sepolicy
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_system_sepolicy.git HEAD:$BRANCH > /dev/null
cd ../..

cd system/security
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_system_security.git HEAD:$BRANCH > /dev/null
cd ../..

cd bootable/recovery
git checkout $BRANCH
git push --quiet -u https://github.com/tenx-tmp/android_bootable_recovery.git HEAD:$BRANCH > /dev/null
cd ../..

echo "Pushed succussfully"
