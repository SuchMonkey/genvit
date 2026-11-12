# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo git-r3 systemd

DESCRIPTION="Temperature-controlled PWM fan service for Geekworm NasPi cases"
HOMEPAGE="https://github.com/SuchMonkey/naspi-control"
EGIT_REPO_URI="https://github.com/SuchMonkey/naspi-control.git"

LICENSE="MIT"
SLOT="0"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install
	systemd_dounit naspi-control.service
}

pkg_postinst() {
	elog "naspi-control is intended for Raspberry Pis in a Geekworm NasPi case."
	elog "Enable PWM channel 0 before starting the service by adding this line to"
	elog "/boot/config.txt (or /boot/firmware/config.txt on newer images):"
	elog ""
	elog "  dtoverlay=pwm"
	elog ""
	elog "Reboot and verify that /sys/class/pwm/pwmchip0 exists, then enable the service:"
	elog ""
	elog "  systemctl enable --now naspi-control.service"
}
