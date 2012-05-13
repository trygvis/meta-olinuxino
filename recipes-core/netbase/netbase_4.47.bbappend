FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PRINC := "${@int(PRINC) + 2}"

SRC_URI += "file://00-mac"

do_install_append() {
    install -m 0755 ${WORKDIR}/00-mac ${D}${sysconfdir}/network/if-pre-up.d
}
