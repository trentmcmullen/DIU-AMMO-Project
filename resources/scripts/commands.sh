#!/usr/bin/env bash

# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

# Global Commands (Debian, MacOS, and Busybox patches)
CMD_AWK=$(command -v /usr/bin/awk &> /dev/null && /bin/echo "/usr/bin/awk" || /bin/echo "/bin/awk")
CMD_BASH=$([ ${BASH_VERSINFO:-0} -ge 4 ] && /bin/echo "/bin/bash" || /bin/echo "/usr/local/bin/bash")
CMD_CHMOD=$(command -v /bin/chmod &> /dev/null && /bin/echo "/bin/chmod" || /bin/echo "/usr/bin/chmod")
CMD_CHOWN=$(command -v /bin/chown &> /dev/null && /bin/echo "/bin/chown" || /bin/echo "/usr/bin/chown")
CMD_DIRNAME=$(command -v /usr/bin/dirname &> /dev/null && /bin/echo "/usr/bin/dirname" || /bin/echo "/bin/dirname")
CMD_DOCKER=$(command -v /usr/bin/docker &> /dev/null && /bin/echo "/usr/bin/docker" || /bin/echo "/usr/local/bin/docker")
CMD_FIND=$(command -v /usr/bin/find &> /dev/null && /bin/echo "/usr/bin/find" || /bin/echo "/bin/find")
CMD_GREP=$(command -v /bin/grep &> /dev/null && /bin/echo "/bin/grep" || /bin/echo "/usr/bin/grep")
CMD_HOSTNAME=$(command -v /bin/hostname &> /dev/null && /bin/echo "/bin/hostname" || /bin/echo "/usr/bin/hostname")
CMD_NVIDIA_DOCKER=$(command -v /usr/bin/nvidia-docker &> /dev/null && /bin/echo "/usr/bin/nvidia-docker" || /bin/echo "/usr/local/bin/nvidia-docker")
CMD_REALPATH=$(command -v /usr/bin/realpath &> /dev/null && /bin/echo "/usr/bin/realpath" || /bin/echo "/bin/realpath")
CMD_SED=$(command -v /bin/sed &> /dev/null && /bin/echo "/bin/sed" || /bin/echo "/usr/bin/sed")
CMD_TOUCH=$(command -v /bin/touch &> /dev/null && /bin/echo "/bin/touch" || /bin/echo "/usr/bin/touch")
CMD_WGET=$(command -v /usr/bin/wget &> /dev/null && /bin/echo "/usr/bin/wget" || /bin/echo "/bin/wget")
CMD_XARGS=$(command -v /usr/bin/xargs &> /dev/null && /bin/echo "/usr/bin/xargs" || /bin/echo "/bin/xargs")

## - Debugging
#/bin/echo "Using System CMD_AWK=${CMD_AWK}";
#/bin/echo "Using System CMD_BASH=${CMD_BASH}";
#/bin/echo "Using System CMD_CHMOD=${CMD_CHMOD}";
#/bin/echo "Using System CMD_CHOWN=${CMD_CHOWN}";
#/bin/echo "Using System CMD_DIRNAME=${CMD_DIRNAME}";
#/bin/echo "Using System CMD_DOCKER=${CMD_DOCKER}";
#/bin/echo "Using System CMD_FIND=${CMD_FIND}";
#/bin/echo "Using System CMD_GREP=${CMD_GREP}";
#/bin/echo "Using System CMD_HOSTNAME=${CMD_HOSTNAME}";
#/bin/echo "Using System CMD_REALPATH=${CMD_REALPATH}";
#/bin/echo "Using System CMD_SED=${CMD_SED}";
#/bin/echo "Using System CMD_TOUCH=${CMD_TOUCH}";
#/bin/echo "Using System CMD_WGET=${CMD_WGET}";
#/bin/echo "Using System CMD_XARGS=${CMD_XARGS}";
