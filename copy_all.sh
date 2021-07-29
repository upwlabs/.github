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
        cp android-build/prepare_rn.gradle ../$repo/
	cp android-build/prepare_rn.sh ../$repo/
    done
