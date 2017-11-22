# Copyright (C) 2017, Pavel Dubrova <pashadubrova@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 and
# only version 2 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

#!/bin/bash

#############
# VAR BLOCK #
#############
committer="Pavel Dubrova"

google_revision="android-8.0.0_r30"
our_branch="android-8.0"

repos="platform_bionic\
		platform_build\
		platform_build_soong\
		platform_external_tinyalsa\
		platform_external_tinycompress\
		platform_external_toybox\
		platform_external_wpa_supplicant_8\
		platform_frameworks_av\
		platform_frameworks_base\
		platform_frameworks_native\
		platform_frameworks_support\
		platform_hardware_interfaces\
		platform_hardware_qcom_audio\
		platform_hardware_qcom_bt\
		platform_hardware_qcom_display\
		platform_hardware_qcom_gps\
		platform_hardware_qcom_keymaster\
		platform_hardware_qcom_media\
		platform_packages_apps_Nfc\
		platform_packages_apps_Settings\
		platform_packages_providers_DownloadProvider\
		platform_packages_providers_MediaProvider\
		platform_packages_services_Telephony\
		platform_system_core\
		platform_system_extras\
		platform_system_vold"

##############
# MAIN BLOCK #
##############
for repo in ${repos}
do
	cd ${repo}
	git reset --hard
	git remote add google https://android.googlesource.com/${repo//_//}
	git remote update
	git checkout origin/$our_branch
	total_commits_number=$(($(git log --format=%H --committer="$committer" | wc -l)-1))
	last_hash=$(git log --format=%H -1)
	first_hash=$(git log --format=%H --committer="$committer" HEAD~${total_commits_number})
	commit_list=$(git log --format=%s ${first_hash}^..${last_hash})
	git checkout tags/$google_revision
	git branch -D $our_branch
	git checkout -b $our_branch
	git cherry-pick ${first_hash}^..${last_hash}
	git push origin $our_branch -f

	cd ../
done
}
