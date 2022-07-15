#!/bin/sh

# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

ROOT="../../"

# - Models
wget -O "${ROOT}/resources/models/balanced_model.pth" "https://diux.app.box.com/s/wmox6tcgj645f4k414s3e052xtc55xb1/file/976824791568"
wget -O "${ROOT}/resources/models/unbalanced_model.pth" "https://diux.app.box.com/s/wmox6tcgj645f4k414s3e052xtc55xb1/file/976822820361"
