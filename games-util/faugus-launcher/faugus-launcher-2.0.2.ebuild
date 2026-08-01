# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )

inherit python-single-r1 meson xdg

DESCRIPTION="Simple and lightweight app for running Windows games using UMU-Launcher"
HOMEPAGE="https://github.com/Faugus/faugus-launcher"
SRC_URI="https://github.com/Faugus/faugus-launcher/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/vdf[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	')
	gui-libs/gtk:4
	gui-libs/libadwaita:1
	dev-libs/libayatana-appindicator
	dev-libs/libmanette:0
	media-gfx/imagemagick
	media-libs/libcanberra
"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
"

src_configure() {
	local emesonargs=(
		-Dflatpak_build=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "You will need a Proton/Wine runner to play games."
	elog "Install one of the following:"
	elog "  - games-util/umu-launcher"
	elog "  - app-emulation/wine-ge-custom-bin"
	elog "  - app-emulation/wine-cachyos"
	elog ""
	elog "Or install Proton-GE from Steam compatibility tools."
}
