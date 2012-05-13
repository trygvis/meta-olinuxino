# DESCRIPTION = ""
# HOMEPAGE = ""
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "http://kolev.info/olinuxino/${PN}-src-${PV}.tar.gz \
           file://01-bootlets.patch \
           "
SRC_URI[md5sum] = "523a284cd8e6456abe0d3c78cb190aec"
SRC_URI[sha256sum] = "55cd648e589d33c6aef5986957337a20632321a87304f833d25242447d4bb8a8"

S = "${WORKDIR}/${PN}-src-${PV}"

EXTRA_OEMAKE = "CROSS_COMPILE=arm-oe-linux-gnueabi-"

do_compile() {
    oe_runmake linux_prep boot_prep power_prep linux.db uboot.db linux_prebuilt.db uboot_prebuilt.db updater_prebuilt.db
}

do_install() {
    install -d ${STAGING_DATADIR}/imx-bootlets
    install ${S}/boot_prep/boot_prep ${STAGING_DATADIR}/imx-bootlets/
    install ${S}/power_prep/power_prep ${STAGING_DATADIR}/imx-bootlets/
    install ${S}/linux_prep/output-target/linux_prep ${STAGING_DATADIR}/imx-bootlets/
}
