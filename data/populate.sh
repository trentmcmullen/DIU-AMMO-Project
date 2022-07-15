#!/bin/sh

# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

ROOT="../"
# - Data
wget -O "${ROOT}/data/balanced_training_validation_set.zip" "https://diux.app.box.com/s/wmox6tcgj645f4k414s3e052xtc55xb1/folder/166082188229"
wget -O "${ROOT}/data/test_set.zip" "https://diux.app.box.com/s/wmox6tcgj645f4k414s3e052xtc55xb1/folder/166081903025"
wget -O "${ROOT}/data/unbalanced_training_validation_set.zip" "https://diux.app.box.com/s/wmox6tcgj645f4k414s3e052xtc55xb1/folder/166080908821"