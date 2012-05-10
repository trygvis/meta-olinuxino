
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE_olinuxino = "olinuxino"

SRC_URI += "file://olinuxino.patch \
            file://linux_prebuilt.db \
           "

do_create_sb_stream() {
# TODO: Remove debugging
#    echo "pwd=`pwd`"
#    echo "D=${D}"
#    echo "S=${S}"
#    echo "WORKDIR=${WORKDIR}"
#    echo "STAGING_BINDIR=${STAGING_BINDIR}"
#    echo "STAGING_BINDIR_CROSS=${STAGING_BINDIR_CROSS}"
#    echo "STAGING_BINDIR_NATIVE=${STAGING_BINDIR_NATIVE}"
#    echo "STAGING_DATADIR=${STAGING_DATADIR}"
#    echo "STAGING=${STAGING}"
#    echo "STAGING_DIR=${STAGING_DIR}"
#    echo "STAGING_KERNEL_DIR=${STAGING_KERNEL_DIR}"

    cat ${WORKDIR}/linux_prebuilt.db | \
    sed -e "s,@STAGING_DATADIR@,${STAGING_DATADIR}," \
        -e "s,@STAGING_KERNEL_DIR@,${STAGING_KERNEL_DIR}," \
        > ${WORKDIR}/linux_prebuilt.db.out
    elftosb -z -c ${WORKDIR}/linux_prebuilt.db.out -o ${WORKDIR}/imx23_linux.sb
    dd if=/dev/zero of=${WORKDIR}/mx23.img bs=512 count=4
    dd if=${WORKDIR}/imx23_linux.sb of=${WORKDIR}/mx23.img ibs=512 seek=4 conv=sync,notrunc
}

addtask create_sb_stream after do_populate_sysroot before do_deploy

do_deploy_append() {
  install -d ${DEPLOY_DIR_IMAGE}
  install ${WORKDIR}/mx23.img ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.mx23.img
}
