#!/bin/bash

declare -a apps=('emma' 'noah' 'kaylee' 'lexie')
declare -a platforms=('android' 'ios')

echo '>>> copy update-rn-meta.yml to all android and ios repos'
for platform in "${platforms[@]}"; do
    for app in "${apps[@]}"; do
	repo="$app-$platform"
	cp workflow-templates/update-rn-meta.yml ../$repo/.github/workflows
    done
done

echo '>>> copy prepare-rn.gradle/sh to all android repos' 
    for app in "${apps[@]}"; do
        repo="$app-android"
	rm -rf ../$repo/.github/workflows
        mkdir -p ../$repo/.github/workflows
        cp android-build/prepare_rn.gradle ../$repo/
	cp workflow-templates/android-build.yml ../$repo/.github/workflows
	cp workflow-templates/android-build-manual.yml ../$repo/.github/workflows
	cp workflow-templates/update-bom-version.yml ../$repo/.github/workflows
	cp workflow-templates/update-rn-meta.yml ../$repo/.github/workflows
	mkdir -p ../$repo/script
	cp android-build/prepare_rn.sh ../$repo/script
	cp android-build/make_build_tag.sh ../$repo/script
	cp android-build/Makefile ../$repo
    done
