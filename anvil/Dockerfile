FROM ubuntu:latest

#####
# Constants
#####
# GLOBAL
ENV GET_JLINK_PACKAGE_SCRIPT_NAME="get_jlink_software_package.sh"
ENV ENTRYPOINT_SCRIPT_NAME="container_entrypoint.sh"
ENV USER_NAME="dev"

# BUILD CONSTANTS
ENV local_INSTALL_SCRIPTS_DIR="install_tools"
ENV local_DOT_FILES_DIR="container_dot_files"

# RESULTANT IMAGE CONSTANTS
ENV image_CUSTOM_PACKAGES_INSTALL_DIR="/opt"
ENV image_INSTALL_SCRIPTS_DIR="${image_CUSTOM_PACKAGES_INSTALL_DIR}/install_tools"
ENV image_JLINK_DIR="${image_CUSTOM_PACKAGES_INSTALL_DIR}"
ENV image_JLINK_VERSION="v7.62b"
ENV image_ENTRYPOINT_SCRIPT_DIR="/etc"

#####
# "Functions"
#####
# can use eval to resolve layered environment variables
ENV DOWNLOAD_JLINK_PACKAGE="${image_INSTALL_SCRIPTS_DIR}/${GET_JLINK_PACKAGE_SCRIPT_NAME} \
                            -o ${image_JLINK_DIR} \
                            -v ${image_JLINK_VERSION}"
ENV GET_JLINK_PACKAGE_FILENAME="${DOWNLOAD_JLINK_PACKAGE} --name-only"

#####
# IMAGE BUILD
#####
# Create Directories
#       not using WORKDIR b/c all paths are absolute; single RUN means only 1 layer instead of many
RUN mkdir -p \
    "${image_INSTALL_SCRIPTS_DIR}" \
    "${image_JLINK_DIR}" \
    "${image_ENTRYPOINT_SCRIPT_DIR}"

# Copy install scripts, local packages (if they exist), and entrypoint script
COPY ${local_INSTALL_SCRIPTS_DIR} ${image_INSTALL_SCRIPTS_DIR}
COPY ${ENTRYPOINT_SCRIPT_NAME} ${image_ENTRYPOINT_SCRIPT_DIR}

# Install packages
RUN apt-get update && apt-get install --no-install-recommends -y \
	git \
	vim \
	make \
	curl \
	ca-certificates \
	xz-utils 
RUN eval "${DOWNLOAD_JLINK_PACKAGE}" \
	&& tar -vxf $(eval "${GET_JLINK_PACKAGE_FILENAME}") -C ${image_JLINK_DIR} \
	&& rm -rf \
		$(eval "${GET_JLINK_PACKAGE_FILENAME}") \
		${image_INSTALL_SCRIPTS_DIR} \
	&& apt-get clean

# Add User
RUN groupadd -r ${USER_NAME} \
    && useradd -rlm -d /home/${USER_NAME} -g ${USER_NAME} ${USER_NAME}
USER ${USER_NAME}
COPY ${local_DOT_FILES_DIR} /home/${USER_NAME}

# Start Container in User Home dir
WORKDIR /home/${USER_NAME}

#####
# Constants Updates
#####
ENV image_INSTALL_SCRIPTS_DIR=""

#####
# "Function" Updates
#####
ENV GET_JLINK_PACKAGE_FILENAME="ls ${image_JLINK_DIR} | grep '^JLink_Linux_\S*_x86_64$'"
ENV DOWNLOAD_TOOLCHAIN=""

#####
# Entrypoint Setup
#####
ENTRYPOINT ["/bin/bash", "-c", "${image_ENTRYPOINT_SCRIPT_DIR}/${ENTRYPOINT_SCRIPT_NAME} \"${@}\"", "--"]
CMD ["echo", "the hammer goes ting ting"]
