#
# This makefile defines the generation of the ${BADGES} items for use in the
# README.md file.
#
# NOTE: Here each target generates an SVG file in the img/ directory, currently
# this is accomplished via the shields.io webservice and the below url pattern. 
# ${BADGE_URL}/<LABEL>-<MESSAGE>-<COLOR>?link=<LEFT_LINK>&link=<RIGHT_LINK>&logo=<SIMPLE_ICONS_NAME>
#

badge_before_message:
	@echo "${YELLOW}Generating badges...${RESET}"

img/license.svg: badge_before_message
	@${DOWNLOAD} "${BADGE_URL}/License-${LICENSE}-informational?link=&link=${REPOSITORY}/LICENSE" > $@

img/release.svg: badge_before_message
	@${DOWNLOAD} "${BADGE_URL}/Release-${VERSION}-success?link=https://${GIT_DOMAIN}/${GIT_R_PATH}/-/releases&link=https://${GIT_DOMAIN}/${GIT_R_PATH}/-/releases/${VERSION}" > $@

img/version.svg: badge_before_message
	@${DOWNLOAD} "${BADGE_URL}/Version-$$(echo "${BUILD_V}" | sed 's/-/--/g')-informational?link=&link=${REPOSITORY}&logo=git" > $@

img/language.svg: badge_before_message
	@${DOWNLOAD} "${BADGE_URL}/Language-${STANDARD}-informational?link=&link=https://en.wikipedia.org/wiki/C_%28programming_language%29&logo=c" > $@

img/repository.svg: badge_before_message
	@${DOWNLOAD} "${BADGE_URL}/Repository-${GIT_BRANCH}-informational?link=&link=${REPOSITORY}&logo=gitlab" > $@

img/coverage.svg: badge_before_message
	@# NOTE: '%' symbol included in ${TEST_COVERAGE} macro, adding '25' will
	@# make the url contain '%25' which escapes an '%' sign.
	@${DOWNLOAD} "${BADGE_URL}/Coverage-~${TEST_COVERAGE}25-critical?link=&link=${REPOSITORY}/-/pipelines" > $@

.SILENT: ${BADGES:%=img/%.svg}

.PHONY: ${BADGES:%=img/%.svg} badge_before_message

