all: usage

usage:
	@echo "Usage:"
	@echo "make [flavor][build-type], like googleBeta, samsungBeta and etc."


googleBeta: 
	script/make_build_tag.sh -m app -c assembleGoogleBeta

bundleGoogleRelease:
	script/make_build_tag.sh -m app -c bundleGoogleRelease

samsungBeta: 
	script/make_build_tag.sh -m app -c assembleSamsungBeta

rnBeta: 
	script/make_build_tag.sh -m app -c assembleRnBeta

lintReport:
	script/prepare_build_workflow.sh app google beta true
