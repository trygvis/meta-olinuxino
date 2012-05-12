FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE_olinuxino = "olinuxino"

DEPENDS += "imx-bootlets"

SRC_URI += "file://olinuxino.patch \
            file://linux_prebuilt.db \
           "

do_create_sb_stream() {
    cat ${WORKDIR}/linux_prebuilt.db | \
    sed -e "s,@STAGING_DATADIR@,${STAGING_DATADIR}," \
        > ${WORKDIR}/linux_prebuilt.db.out
    (cd ${WORKDIR} && elftosb -z -c linux_prebuilt.db.out -o imx23_linux.sb)
    dd if=/dev/zero of=${WORKDIR}/mx23.img bs=512 count=4
    dd if=${WORKDIR}/imx23_linux.sb of=${WORKDIR}/mx23.img ibs=512 seek=4 conv=sync,notrunc
}

addtask create_sb_stream after do_install before do_deploy

do_deploy_append() {
    install -d ${DEPLOY_DIR_IMAGE}
    install ${WORKDIR}/mx23.img ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.mx23.img
}
