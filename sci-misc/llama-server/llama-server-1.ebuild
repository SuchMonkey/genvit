# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="systemd service and tooling to serve llama.cpp models (router mode) on the LAN"
HOMEPAGE="https://github.com/ggml-org/llama.cpp"
SRC_URI=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

RDEPEND="
	acct-user/llama
	sci-misc/llama-cpp
	net-misc/curl
	dev-libs/openssl
"

src_install() {
	systemd_dounit "${FILESDIR}/llama-server.service"

	insinto /etc/llama-server
	doins "${FILESDIR}/llama-server.env"
	doins "${FILESDIR}/models.ini"

	dobin "${FILESDIR}/llama-server-key"
	dobin "${FILESDIR}/llama-server-model"
}

pkg_postinst() {
	if [[ ! -f "${ROOT}/etc/llama-server/api-keys" ]]; then
		local key
		key="$(openssl rand -hex 32)"
		echo "${key}" > "${ROOT}/etc/llama-server/api-keys"
		chmod 0640 "${ROOT}/etc/llama-server/api-keys"
		chown root:llama "${ROOT}/etc/llama-server/api-keys"
		elog "Generated an API key for llama-server at /etc/llama-server/api-keys."
	fi

	elog ""
	elog "Setup:"
	elog "  systemctl enable --now llama-server"
	elog "  # read the key (or add another with: llama-server-key new)"
	elog "  cat /etc/llama-server/api-keys"
	elog "  # install a model (llama.cpp downloads it into the cache)"
	elog "  llama-server-model install ggml-org/gemma-3-4b-it-GGUF:Q4_K_M"
	elog "  # list models / check status"
	elog "  llama-server-model list"
	elog "  curl -H \"Authorization: Bearer \$(head -1 /etc/llama-server/api-keys)\" http://127.0.0.1:8033/v1/models"
	elog ""
	elog "Web UI (needs the API key):  http://<host>:8033/"
	elog "Per-model tuning: edit /etc/llama-server/models.ini (see the tutorial inside)."
}
