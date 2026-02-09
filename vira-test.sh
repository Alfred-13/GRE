#!/bin/bash
# ============================================================
#  VIRA TUNNEL v1.0 - Professional GRE Tunnel Manager
#  Nuclear Uninstall | SSH-Safe | Auto Private IP
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'
G1='\033[38;5;220m'
G2='\033[38;5;221m'
G3='\033[38;5;178m'
G4='\033[38;5;172m'
G5='\033[38;5;136m'
G6='\033[38;5;214m'
G7='\033[38;5;208m'
G8='\033[38;5;179m'
BG_GOLD='\033[48;5;136m'

CONFIG_DIR="/etc/vira-tunnel"
CONFIG_FILE="${CONFIG_DIR}/config"
TUNNEL_SCRIPT="/usr/local/sbin/vira-gre.sh"
SERVICE_FILE="/etc/systemd/system/vira-gre.service"
TUNNEL_NAME="viraGRE"
VIRA_PRE="VIRA_PRE"
VIRA_POST="VIRA_POST"

IRAN_IP=""
KHAREJ_IP=""
IRAN_PRIVATE_IP=""
KHAREJ_PRIVATE_IP=""

show_logo() {
    clear
    echo ""
    echo -e "${G1}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${G1}    ║${NC}                                                              ${G1}║${NC}"
    echo -e "${G1}    ║${G2}    ██╗   ██╗ ██╗ ██████╗   █████╗                             ${G1}║${NC}"
    echo -e "${G1}    ║${G2}    ██║   ██║ ██║ ██╔══██╗ ██╔══██╗                            ${G1}║${NC}"
    echo -e "${G2}    ║${G3}    ██║   ██║ ██║ ██████╔╝ ███████║                            ${G2}║${NC}"
    echo -e "${G2}    ║${G3}    ╚██╗ ██╔╝ ██║ ██╔══██╗ ██╔══██║                            ${G2}║${NC}"
    echo -e "${G3}    ║${G4}     ╚████╔╝  ██║ ██║  ██║ ██║  ██║                            ${G3}║${NC}"
    echo -e "${G3}    ║${G4}      ╚═══╝   ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝                            ${G3}║${NC}"
    echo -e "${G4}    ║${NC}                                                              ${G4}║${NC}"
    echo -e "${G4}    ║${G5}   ████████╗██╗   ██╗███╗   ██╗███╗   ██╗███████╗██╗          ${G4}║${NC}"
    echo -e "${G5}    ║${G6}   ╚══██╔══╝██║   ██║████╗  ██║████╗  ██║██╔════╝██║          ${G5}║${NC}"
    echo -e "${G5}    ║${G6}      ██║   ██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██║          ${G5}║${NC}"
    echo -e "${G6}    ║${G7}      ██║   ██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║          ${G6}║${NC}"
    echo -e "${G6}    ║${G7}      ██║   ╚██████╔╝██║ ╚████║██║ ╚████║███████╗███████╗     ${G6}║${NC}"
    echo -e "${G7}    ║${G8}      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚══════╝     ${G7}║${NC}"
    echo -e "${G7}    ║${NC}                                                              ${G7}║${NC}"
    echo -e "${G8}    ╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${G8}    ║${NC}  ${G2}★${NC} ${WHITE}Professional GRE Tunnel Manager${NC}        ${DIM}Version 1.0${NC}     ${G8}  ║${NC}"
    echo -e "${G8}    ║${NC}  ${G3}★${NC} ${DIM}SSH-Safe • Auto-IP • Nuclear Uninstall${NC}                  ${G8}  ║${NC}"
    echo -e "${G8}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

ok()   { echo -e "    ${GREEN}  ✔  ${NC}$1"; }
err()  { echo -e "    ${RED}  ✘  ${NC}$1"; }
warn() { echo -e "    ${YELLOW}  ⚠  ${NC}$1"; }
info() { echo -e "    ${CYAN}  ℹ  ${NC}$1"; }
step() { echo -e "    ${G2}[Step $1]${NC} ${WHITE}$2${NC}"; }

check_root() { [[ $EUID -ne 0 ]] && { err "Run as root: sudo bash $0"; exit 1; }; }

validate_ip() {
    local ip="$1"
    [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || return 1
    IFS='.' read -ra O <<< "$ip"
    for o in "${O[@]}"; do ((o>255)) && return 1; done
    return 0
}

detect_local_ip() { ip -4 route get 8.8.8.8 2>/dev/null | grep -oP 'src \K[0-9.]+' | head -1; }

ensure_gre_module() {
    modprobe gre 2>/dev/null || true
    modprobe ip_gre 2>/dev/null || true
    [[ ! -f /etc/modules-load.d/gre.conf ]] && printf "gre\nip_gre\n" > /etc/modules-load.d/gre.conf
}

save_config() {
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_FILE" << EOF
ROLE=$1
IRAN_IP=${IRAN_IP}
KHAREJ_IP=${KHAREJ_IP}
IRAN_PRIVATE_IP=${IRAN_PRIVATE_IP}
KHAREJ_PRIVATE_IP=${KHAREJ_PRIVATE_IP}
INSTALL_DATE=$(date '+%Y-%m-%d %H:%M:%S')
EOF
    chmod 600 "$CONFIG_FILE"
}

load_config() { [[ -f "$CONFIG_FILE" ]] && { source "$CONFIG_FILE"; return 0; } || return 1; }

progress_bar() {
    local w=40
    echo -ne "    ${DIM}$2${NC} ["
    for ((i=0; i<=w; i++)); do
        echo -ne "${G2}█${NC}"
        sleep "$(awk "BEGIN{printf \"%.3f\",$1/$w}" 2>/dev/null || echo 0.03)"
    done
    echo -e "] ${GREEN}Done!${NC}"
}

get_server_ips() {
    local role="$1"
    local auto_ip; auto_ip=$(detect_local_ip)
    IRAN_PRIVATE_IP="10.10.10.1"
    KHAREJ_PRIVATE_IP="10.10.10.2"

    echo ""
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}🔧${NC} ${WHITE}${BOLD}IP CONFIGURATION${NC}                                            ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    if [[ "$role" == "IRAN" ]]; then
        echo -ne "    ${G2}❯${NC} IRAN Public IP [${CYAN}${auto_ip}${NC}]: "
        read input; IRAN_IP=${input:-$auto_ip}
        while ! validate_ip "$IRAN_IP"; do err "Invalid!"; echo -ne "    ${G2}❯${NC} IRAN IP: "; read IRAN_IP; done
        ok "IRAN: ${CYAN}$IRAN_IP${NC}"; echo ""
        echo -ne "    ${G2}❯${NC} KHAREJ Public IP: "
        read KHAREJ_IP
        while ! validate_ip "$KHAREJ_IP"; do err "Invalid!"; echo -ne "    ${G2}❯${NC} KHAREJ IP: "; read KHAREJ_IP; done
        ok "KHAREJ: ${CYAN}$KHAREJ_IP${NC}"
    else
        echo -ne "    ${G2}❯${NC} KHAREJ Public IP [${CYAN}${auto_ip}${NC}]: "
        read input; KHAREJ_IP=${input:-$auto_ip}
        while ! validate_ip "$KHAREJ_IP"; do err "Invalid!"; echo -ne "    ${G2}❯${NC} KHAREJ IP: "; read KHAREJ_IP; done
        ok "KHAREJ: ${CYAN}$KHAREJ_IP${NC}"; echo ""
        echo -ne "    ${G2}❯${NC} IRAN Public IP: "
        read IRAN_IP
        while ! validate_ip "$IRAN_IP"; do err "Invalid!"; echo -ne "    ${G2}❯${NC} IRAN IP: "; read IRAN_IP; done
        ok "IRAN: ${CYAN}$IRAN_IP${NC}"
    fi

    echo ""
    echo -e "${G3}    ┌────────────────────────────────────────────────────────┐${NC}"
    printf "    ${G3}│${NC}  IRAN Public   : ${CYAN}%-36s${NC}${G3}│${NC}\n" "$IRAN_IP"
    printf "    ${G3}│${NC}  KHAREJ Public : ${CYAN}%-36s${NC}${G3}│${NC}\n" "$KHAREJ_IP"
    printf "    ${G3}│${NC}  IRAN Private  : ${CYAN}%-36s${NC}${G3}│${NC}\n" "10.10.10.1/30 (auto)"
    printf "    ${G3}│${NC}  KHAREJ Private: ${CYAN}%-36s${NC}${G3}│${NC}\n" "10.10.10.2/30 (auto)"
    echo -e "${G3}    └────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -ne "    ${G2}❯${NC} Confirm? [${GREEN}Y${NC}/n]: "
    read c; [[ "$c" == "n" || "$c" == "N" ]] && return 1
    return 0
}

# ──────────────────── IPTABLES SETUP ────────────────────

clean_old_iptables() {
    # Remove VIRA chains hooks
    local i
    for i in $(seq 1 10); do
        iptables -t nat -D PREROUTING -j ${VIRA_PRE} 2>/dev/null || true
        iptables -t nat -D POSTROUTING -j ${VIRA_POST} 2>/dev/null || true
        iptables -t nat -D PREROUTING -j VIRA_NAT 2>/dev/null || true
        iptables -t nat -D POSTROUTING -j VIRA_NAT 2>/dev/null || true
    done
    for chain in ${VIRA_PRE} ${VIRA_POST} VIRA_NAT; do
        iptables -t nat -F "$chain" 2>/dev/null || true
        iptables -t nat -X "$chain" 2>/dev/null || true
    done
}

setup_iran_iptables() {
    local iran_priv="$1" kharej_priv="$2"
    clean_old_iptables

    iptables -t nat -N ${VIRA_PRE} 2>/dev/null || { iptables -t nat -F ${VIRA_PRE}; }
    iptables -t nat -A ${VIRA_PRE} -p tcp --dport 22 -j RETURN
    ok "SSH (22) → SAFE"
    iptables -t nat -A ${VIRA_PRE} -p gre -j RETURN
    ok "GRE → SAFE"
    iptables -t nat -A ${VIRA_PRE} -p icmp -j RETURN
    ok "ICMP → SAFE"
    iptables -t nat -A ${VIRA_PRE} -p udp --dport 53 -j RETURN
    iptables -t nat -A ${VIRA_PRE} -p tcp --dport 53 -j RETURN
    ok "DNS → SAFE"
    iptables -t nat -A ${VIRA_PRE} -s ${iran_priv}/30 -j RETURN
    ok "Tunnel subnet → SAFE"
    iptables -t nat -A ${VIRA_PRE} -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
    ok "Established → SAFE"
    iptables -t nat -A ${VIRA_PRE} -p tcp -j DNAT --to-destination ${kharej_priv}
    iptables -t nat -A ${VIRA_PRE} -p udp -j DNAT --to-destination ${kharej_priv}
    ok "TCP/UDP → DNAT ${CYAN}${kharej_priv}${NC}"
    iptables -t nat -A PREROUTING -j ${VIRA_PRE}
    ok "PREROUTING hooked"

    iptables -t nat -N ${VIRA_POST} 2>/dev/null || { iptables -t nat -F ${VIRA_POST}; }
    iptables -t nat -A ${VIRA_POST} -o ${TUNNEL_NAME} -j MASQUERADE
    iptables -t nat -A ${VIRA_POST} -s ${iran_priv}/30 -j MASQUERADE
    iptables -t nat -A POSTROUTING -j ${VIRA_POST}
    ok "POSTROUTING MASQUERADE"
}

setup_kharej_iptables() {
    clean_old_iptables
    iptables -t nat -N ${VIRA_POST} 2>/dev/null || { iptables -t nat -F ${VIRA_POST}; }
    iptables -t nat -A ${VIRA_POST} -j MASQUERADE
    iptables -t nat -A POSTROUTING -j ${VIRA_POST}
    ok "MASQUERADE set"
}

# ──────────────────── ANIMATED PING ────────────────────

animated_ping() {
    local target="$1" label="$2"
    local count=4 success=0 fail=0 times=()

    echo -e "    ${G6}╭───────────────────────────────────────────────────────────╮${NC}"
    echo -e "    ${G6}│${NC}  ${G2}🏓${NC} ${WHITE}${BOLD}${label}${NC}"
    echo -e "    ${G6}│${NC}  ${DIM}Target: ${CYAN}${target}${NC}"
    echo -e "    ${G6}├───────────────────────────────────────────────────────────┤${NC}"

    for ((i=1; i<=count; i++)); do
        echo -ne "    ${G6}│${NC}  ${DIM}Packet ${i}/${count}...${NC}"
        local res; res=$(ping -c 1 -W 3 "$target" 2>&1)
        if [[ $? -eq 0 ]]; then
            local rtt; rtt=$(echo "$res" | grep -oP 'time=\K[0-9.]+' || echo "")
            success=$((success+1))
            if [[ -n "$rtt" ]]; then
                times+=("$rtt")
                local ri=${rtt%.*}; ri=${ri:-0}
                local clr="${GREEN}"; ((ri>100)) && clr="${YELLOW}"; ((ri>300)) && clr="${RED}"
                echo -e "\r    ${G6}│${NC}  ${GREEN}✔${NC} Packet ${i}: ${clr}${rtt} ms${NC}                              "
            else
                echo -e "\r    ${G6}│${NC}  ${GREEN}✔${NC} Packet ${i}: ${GREEN}OK${NC}                                    "
            fi
        else
            fail=$((fail+1))
            echo -e "\r    ${G6}│${NC}  ${RED}✘${NC} Packet ${i}: ${RED}Timeout${NC}                                "
        fi
        sleep 0.2
    done

    echo -e "    ${G6}├───────────────────────────────────────────────────────────┤${NC}"
    local loss=$((fail*100/count))

    if ((success > 0)); then
        local min_t="999999" max_t="0" sum_t="0"
        for t in "${times[@]}"; do
            sum_t=$(awk "BEGIN{printf \"%.2f\",$sum_t+$t}")
            local ti=${t%.*}; ti=${ti:-0}
            local mi=${min_t%.*}; mi=${mi:-999999}
            local mx=${max_t%.*}; mx=${mx:-0}
            ((ti<mi)) && min_t="$t"; ((ti>mx)) && max_t="$t"
        done
        local avg_t; avg_t=$(awk "BEGIN{printf \"%.2f\",$sum_t/${#times[@]}}")
        local lc="${GREEN}"; ((loss>0)) && lc="${YELLOW}"
        echo -e "    ${G6}│${NC}  ${GREEN}✅ CONNECTED${NC}  ${success}/${count} ok  ${lc}(${loss}% loss)${NC}"
        if [[ ${#times[@]} -gt 0 ]]; then
            echo -e "    ${G6}│${NC}  ${G2}⏱${NC}  min=${CYAN}${min_t}ms${NC} avg=${CYAN}${avg_t}ms${NC} max=${CYAN}${max_t}ms${NC}"
            local ai=${avg_t%.*}; ai=${ai:-0}; local q="" qb=""
            if   ((ai<=30));  then q="${GREEN}${BOLD}EXCELLENT${NC}"; qb="${GREEN}██████████${NC}"
            elif ((ai<=80));  then q="${GREEN}VERY GOOD${NC}";       qb="${GREEN}████████${NC}${DIM}██${NC}"
            elif ((ai<=150)); then q="${YELLOW}GOOD${NC}";           qb="${YELLOW}██████${NC}${DIM}████${NC}"
            elif ((ai<=300)); then q="${YELLOW}FAIR${NC}";           qb="${YELLOW}████${NC}${DIM}██████${NC}"
            else                   q="${RED}POOR${NC}";             qb="${RED}██${NC}${DIM}████████${NC}"
            fi
            echo -e "    ${G6}│${NC}  ${G2}📶${NC}  Quality: [${qb}] ${q}"
        fi
    else
        echo -e "    ${G6}│${NC}  ${RED}❌ DISCONNECTED${NC}  ${RED}100% loss${NC}"
    fi
    echo -e "    ${G6}╰───────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

# ──────────────────── SETUP IRAN ────────────────────

setup_iran() {
    show_logo
    echo -e "    ${BG_GOLD}${WHITE}${BOLD}  ⚡ IRAN Server 🇮🇷  ${NC}"
    get_server_ips "IRAN" || return

    echo ""
    step "1/8" "GRE module..."
    ensure_gre_module
    lsmod | grep -q "ip_gre" && ok "Loaded" || err "Failed"

    step "2/8" "Tunnel script..."
    cat > "$TUNNEL_SCRIPT" << TUNEOF
#!/bin/bash
set -e
modprobe ip_gre 2>/dev/null || true
sleep 2
ip tunnel del ${TUNNEL_NAME} 2>/dev/null || true
ip link del ${TUNNEL_NAME} 2>/dev/null || true
ip tunnel add ${TUNNEL_NAME} mode gre remote ${KHAREJ_IP} local ${IRAN_IP} ttl 255
ip link set ${TUNNEL_NAME} mtu 1476
ip addr add ${IRAN_PRIVATE_IP}/30 dev ${TUNNEL_NAME}
ip link set ${TUNNEL_NAME} up
TUNEOF
    chmod +x "$TUNNEL_SCRIPT"; ok "Created"

    step "3/8" "Config..."; save_config "IRAN"; ok "Saved"

    step "4/8" "IP forward..."
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1; ok "ON"

    step "5/8" "iptables-persistent..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq >/dev/null 2>&1
    apt-get install -y -qq iptables-persistent netfilter-persistent >/dev/null 2>&1; ok "Done"

    step "6/8" "SAFE iptables..."; echo ""
    setup_iran_iptables "$IRAN_PRIVATE_IP" "$KHAREJ_PRIVATE_IP"

    step "7/8" "Save rules..."; netfilter-persistent save >/dev/null 2>&1; ok "Saved"

    step "8/8" "Starting..."
    cat > "$SERVICE_FILE" << SVCEOF
[Unit]
Description=VIRA TUNNEL GRE (IRAN)
After=network-online.target
Wants=network-online.target
[Service]
Type=oneshot
ExecStart=${TUNNEL_SCRIPT}
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
SVCEOF
    systemctl daemon-reload
    systemctl enable vira-gre.service >/dev/null 2>&1
    bash "$TUNNEL_SCRIPT" >/dev/null 2>&1 || true
    systemctl restart vira-gre.service >/dev/null 2>&1 || true
    sleep 1

    if ip link show ${TUNNEL_NAME} 2>/dev/null | grep -qE "UP|UNKNOWN"; then
        local tip; tip=$(ip addr show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'inet \K[0-9.]+')
        ok "${GREEN}${BOLD}Tunnel UP!${NC} IP: ${CYAN}${tip}${NC}"
    else err "Tunnel issue"; fi

    echo ""; progress_bar 1 "Done"; echo ""
    animated_ping "$IRAN_PRIVATE_IP" "Local Self-Ping (${IRAN_PRIVATE_IP})"
    echo -e "    ${GREEN}${BOLD}✅ IRAN READY!${NC} Now setup KHAREJ (option 2)"
    echo ""; echo -ne "    ${G2}❯${NC} Enter..."; read
}

# ──────────────────── SETUP KHAREJ ────────────────────

setup_kharej() {
    show_logo
    echo -e "    ${BG_GOLD}${WHITE}${BOLD}  ⚡ KHAREJ Server 🌍  ${NC}"
    get_server_ips "KHAREJ" || return

    echo ""
    step "1/7" "GRE module..."
    ensure_gre_module
    lsmod | grep -q "ip_gre" && ok "Loaded" || err "Failed"

    step "2/7" "Tunnel script..."
    cat > "$TUNNEL_SCRIPT" << TUNEOF
#!/bin/bash
set -e
modprobe ip_gre 2>/dev/null || true
sleep 2
ip tunnel del ${TUNNEL_NAME} 2>/dev/null || true
ip link del ${TUNNEL_NAME} 2>/dev/null || true
ip tunnel add ${TUNNEL_NAME} mode gre remote ${IRAN_IP} local ${KHAREJ_IP} ttl 255
ip link set ${TUNNEL_NAME} mtu 1476
ip addr add ${KHAREJ_PRIVATE_IP}/30 dev ${TUNNEL_NAME}
ip link set ${TUNNEL_NAME} up
TUNEOF
    chmod +x "$TUNNEL_SCRIPT"; ok "Created"

    step "3/7" "Config..."; save_config "KHAREJ"; ok "Saved"

    step "4/7" "IP forward..."
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1; ok "ON"

    step "5/7" "iptables-persistent..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq >/dev/null 2>&1
    apt-get install -y -qq iptables-persistent netfilter-persistent >/dev/null 2>&1; ok "Done"

    step "6/7" "iptables..."
    setup_kharej_iptables
    netfilter-persistent save >/dev/null 2>&1; ok "Saved"

    step "7/7" "Starting..."
    cat > "$SERVICE_FILE" << SVCEOF
[Unit]
Description=VIRA TUNNEL GRE (KHAREJ)
After=network-online.target
Wants=network-online.target
[Service]
Type=oneshot
ExecStart=${TUNNEL_SCRIPT}
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
SVCEOF
    systemctl daemon-reload
    systemctl enable vira-gre.service >/dev/null 2>&1
    bash "$TUNNEL_SCRIPT" >/dev/null 2>&1 || true
    systemctl restart vira-gre.service >/dev/null 2>&1 || true
    sleep 1

    if ip link show ${TUNNEL_NAME} 2>/dev/null | grep -qE "UP|UNKNOWN"; then
        local tip; tip=$(ip addr show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'inet \K[0-9.]+')
        ok "${GREEN}${BOLD}Tunnel UP!${NC} IP: ${CYAN}${tip}${NC}"
    else err "Tunnel issue"; fi

    echo ""; progress_bar 1 "Done"; echo ""
    animated_ping "$KHAREJ_PRIVATE_IP" "Local Self-Ping (${KHAREJ_PRIVATE_IP})"
    echo -e "    ${GREEN}${BOLD}✅ KHAREJ READY!${NC}"
    echo ""; echo -ne "    ${G2}❯${NC} Enter..."; read
}

# ════════════════════════════════════════════════════════
#  NUCLEAR UNINSTALL - حذف کامل و قطعی همه چیز
# ════════════════════════════════════════════════════════

uninstall_tunnel() {
    show_logo

    echo -e "${RED}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}    ║${NC}  ${RED}💣${NC} ${WHITE}${BOLD}NUCLEAR UNINSTALL - COMPLETE REMOVAL${NC}                       ${RED}║${NC}"
    echo -e "${RED}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    warn "This will COMPLETELY remove:"
    echo -e "    ${RED}  •${NC} All GRE tunnel interfaces"
    echo -e "    ${RED}  •${NC} All systemd services"
    echo -e "    ${RED}  •${NC} All tunnel scripts"
    echo -e "    ${RED}  •${NC} All VIRA config files"
    echo -e "    ${RED}  •${NC} ALL iptables NAT rules (full reset)"
    echo -e "    ${RED}  •${NC} IP forwarding settings"
    echo -e "    ${RED}  •${NC} GRE kernel module config"
    echo ""
    info "${GREEN}SSH will remain working${NC}"
    echo ""
    echo -ne "    ${RED}❯${NC} Type '${RED}YES${NC}': "
    read c
    [[ "$c" != "YES" ]] && { info "Cancelled."; echo -ne "\n    Enter..."; read; return; }

    echo ""
    echo -e "    ${RED}${BOLD}━━━ NUCLEAR UNINSTALL STARTED ━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # ═══ 1. STOP ALL SERVICES ═══
    step "1/9" "Stopping ALL tunnel services..."
    for svc in vira-gre greKH greIR; do
        if systemctl is-active --quiet "${svc}.service" 2>/dev/null; then
            systemctl stop "${svc}.service" 2>/dev/null
            ok "Stopped: ${svc}"
        fi
        systemctl disable "${svc}.service" 2>/dev/null || true
    done
    ok "All services stopped"

    # ═══ 2. REMOVE ALL TUNNEL INTERFACES ═══
    step "2/9" "Removing ALL tunnel interfaces..."
    # Get list of all GRE tunnels
    local tunnels
    tunnels=$(ip tunnel show 2>/dev/null | grep -v "^tunl0\|^sit0" | awk -F: '{print $1}' | tr -d ' ')
    if [[ -n "$tunnels" ]]; then
        echo "$tunnels" | while read tun; do
            [[ -z "$tun" ]] && continue
            ip tunnel del "$tun" 2>/dev/null && ok "Deleted tunnel: ${CYAN}${tun}${NC}" || true
            ip link del "$tun" 2>/dev/null || true
        done
    fi
    # Also try known names
    for tun in viraGRE greKH greIR gre1 gre2; do
        ip tunnel del "$tun" 2>/dev/null || true
        ip link del "$tun" 2>/dev/null || true
    done
    ok "All tunnels removed"

    # ═══ 3. COMPLETE IPTABLES RESET ═══
    step "3/9" "FULL iptables NAT reset..."

    # First: remove all custom chain hooks
    for chain in ${VIRA_PRE} ${VIRA_POST} VIRA_NAT; do
        for i in $(seq 1 20); do
            iptables -t nat -D PREROUTING -j "$chain" 2>/dev/null || break
        done
        for i in $(seq 1 20); do
            iptables -t nat -D POSTROUTING -j "$chain" 2>/dev/null || break
        done
        iptables -t nat -F "$chain" 2>/dev/null || true
        iptables -t nat -X "$chain" 2>/dev/null || true
    done
    ok "Custom chains removed"

    # Second: FULL FLUSH of nat table
    iptables -t nat -F 2>/dev/null || true
    ok "NAT table flushed (all rules)"

    # Third: delete any remaining custom chains
    iptables -t nat -X 2>/dev/null || true
    ok "All custom chains deleted"

    # Fourth: reset policy
    iptables -t nat -P PREROUTING ACCEPT 2>/dev/null || true
    iptables -t nat -P INPUT ACCEPT 2>/dev/null || true
    iptables -t nat -P OUTPUT ACCEPT 2>/dev/null || true
    iptables -t nat -P POSTROUTING ACCEPT 2>/dev/null || true
    ok "NAT policies reset to ACCEPT"

    # Fifth: also clean filter table of any tunnel rules
    iptables -D FORWARD -i ${TUNNEL_NAME} -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -o ${TUNNEL_NAME} -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -i greKH -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -o greKH -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -i greIR -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -o greIR -j ACCEPT 2>/dev/null || true
    ok "Filter table cleaned"

    # Sixth: also do ip6tables
    ip6tables -t nat -F 2>/dev/null || true
    ip6tables -t nat -X 2>/dev/null || true
    ok "IPv6 NAT cleaned"

    # ═══ 4. SAVE CLEAN IPTABLES ═══
    step "4/9" "Saving clean iptables..."
    netfilter-persistent save >/dev/null 2>&1 || true
    # Also overwrite saved rules directly
    echo "*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT" > /etc/iptables/rules.v4 2>/dev/null || true

    echo "*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT" > /etc/iptables/rules.v6 2>/dev/null || true
    ok "Clean rules saved to disk"

    # ═══ 5. REMOVE ALL SERVICE FILES ═══
    step "5/9" "Removing service files..."
    for svc in vira-gre greKH greIR; do
        rm -f "/etc/systemd/system/${svc}.service"
    done
    systemctl daemon-reload 2>/dev/null
    ok "All service files removed"

    # ═══ 6. REMOVE ALL SCRIPTS ═══
    step "6/9" "Removing scripts..."
    rm -f /usr/local/sbin/vira-gre.sh
    rm -f /usr/local/sbin/greKH.sh
    rm -f /usr/local/sbin/greIR.sh
    ok "All scripts removed"

    # ═══ 7. REMOVE CONFIG ═══
    step "7/9" "Removing config..."
    rm -rf "$CONFIG_DIR"
    rm -f /etc/modules-load.d/gre.conf
    ok "Config removed"

    # ═══ 8. DISABLE IP FORWARDING ═══
    step "8/9" "Disabling IP forwarding..."
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1 || true
    ok "IP forwarding disabled"

    # ═══ 9. VERIFY EVERYTHING ═══
    step "9/9" "Verifying complete removal..."
    echo ""

    local problems=0

    # Check tunnels
    local remaining_tun
    remaining_tun=$(ip tunnel show 2>/dev/null | grep -v "^tunl0\|^sit0" | grep -c "" || echo 0)
    if ((remaining_tun > 0)); then
        err "Still ${remaining_tun} tunnel(s) found:"
        ip tunnel show 2>/dev/null | grep -v "^tunl0\|^sit0" | while read l; do echo -e "    ${RED}      $l${NC}"; done
        problems=$((problems+1))
    else
        ok "Tunnels: ${GREEN}CLEAN${NC} (none found)"
    fi

    # Check services
    local svc_found=false
    for svc in vira-gre greKH greIR; do
        if [[ -f "/etc/systemd/system/${svc}.service" ]]; then
            err "Service file exists: ${svc}.service"
            svc_found=true; problems=$((problems+1))
        fi
    done
    $svc_found || ok "Services: ${GREEN}CLEAN${NC}"

    # Check scripts
    local scr_found=false
    for s in /usr/local/sbin/vira-gre.sh /usr/local/sbin/greKH.sh /usr/local/sbin/greIR.sh; do
        if [[ -f "$s" ]]; then
            err "Script exists: $s"
            scr_found=true; problems=$((problems+1))
        fi
    done
    $scr_found || ok "Scripts: ${GREEN}CLEAN${NC}"

    # Check config
    [[ -d "$CONFIG_DIR" ]] && { err "Config dir exists"; problems=$((problems+1)); } || ok "Config: ${GREEN}CLEAN${NC}"

    # Check iptables
    local nat_rules
    nat_rules=$(iptables -t nat -L -n 2>/dev/null | grep -v "^Chain\|^target\|^$" | wc -l)
    if ((nat_rules > 0)); then
        warn "Found ${nat_rules} NAT rules remaining (may be from other software)"
        iptables -t nat -L -n 2>/dev/null | grep -v "^Chain\|^target\|^$" | head -5 | while read l; do
            echo -e "    ${YELLOW}      $l${NC}"
        done
    else
        ok "iptables NAT: ${GREEN}COMPLETELY CLEAN${NC}"
    fi

    # Check IP forward
    local fwd
    fwd=$(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null)
    [[ "$fwd" == "0" ]] && ok "IP Forward: ${GREEN}OFF${NC}" || warn "IP Forward still ON (may be needed by other software)"

    # Check kernel module
    if lsmod | grep -q "ip_gre"; then
        info "ip_gre module still loaded (will unload on reboot)"
    else
        ok "GRE module: ${GREEN}UNLOADED${NC}"
    fi

    echo ""

    if ((problems == 0)); then
        echo -e "    ${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${GREEN}${BOLD}║                                                          ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   ✅ NUCLEAR UNINSTALL COMPLETE!                         ║${NC}"
        echo -e "    ${GREEN}${BOLD}║                                                          ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • All tunnels removed                                  ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • All iptables rules wiped                             ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • All services removed                                 ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • All config files removed                             ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • IP forwarding disabled                               ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   • SSH is working ✔                                     ║${NC}"
        echo -e "    ${GREEN}${BOLD}║                                                          ║${NC}"
        echo -e "    ${GREEN}${BOLD}║   Server is back to factory state!                       ║${NC}"
        echo -e "    ${GREEN}${BOLD}║                                                          ║${NC}"
        echo -e "    ${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    else
        echo -e "    ${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${YELLOW}║  ⚠  ${problems} item(s) may need manual attention              ║${NC}"
        echo -e "    ${YELLOW}║  Try running uninstall again or reboot the server       ║${NC}"
        echo -e "    ${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
    fi

    echo ""
    info "Recommended: ${WHITE}reboot${NC} the server to ensure clean state"
    echo ""
    echo -ne "    ${G2}❯${NC} Press Enter..."
    read
}

# ──────────────────── STATUS ────────────────────

check_status() {
    show_logo
    echo -e "${G3}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${G3}    ║${NC}  ${G1}📊${NC} ${WHITE}${BOLD}FULL DIAGNOSTICS${NC}                                            ${G3}║${NC}"
    echo -e "${G3}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local cfg=false sr="" sii="" ski="" sip="" skp="" sd=""
    if load_config; then
        cfg=true; sr="$ROLE"; sii="$IRAN_IP"; ski="$KHAREJ_IP"
        sip="$IRAN_PRIVATE_IP"; skp="$KHAREJ_PRIVATE_IP"; sd="$INSTALL_DATE"
    fi

    echo -e "    ${G2}━━━ 1. SERVER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    if $cfg; then
        local ri="🌍"; [[ "$sr" == "IRAN" ]] && ri="🇮🇷"
        printf "    Role: ${CYAN}${BOLD}%-8s${NC} %s  Date: ${DIM}%s${NC}\n" "$sr" "$ri" "$sd"
        printf "    IRAN:   ${CYAN}%-16s${NC} Priv: ${CYAN}%s${NC}\n" "$sii" "$sip"
        printf "    KHAREJ: ${CYAN}%-16s${NC} Priv: ${CYAN}%s${NC}\n" "$ski" "$skp"
    else warn "No config"; fi
    echo ""

    echo -e "    ${G2}━━━ 2. GRE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    lsmod | grep -q "ip_gre" && ok "ip_gre: ${GREEN}LOADED${NC}" || err "ip_gre: ${RED}NOT LOADED${NC}"
    echo ""

    echo -e "    ${G2}━━━ 3. TUNNEL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    local tun_ok=false
    if ip tunnel show 2>/dev/null | grep -q "${TUNNEL_NAME}"; then
        tun_ok=true
        ok "$(ip tunnel show ${TUNNEL_NAME} 2>/dev/null)"
        local tip; tip=$(ip addr show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'inet \K[0-9./]+')
        [[ -n "$tip" ]] && ok "IP: ${CYAN}${tip}${NC}" || warn "No IP"
        local ls; ls=$(ip link show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'state \K\w+')
        [[ "$ls" == "UP" || "$ls" == "UNKNOWN" ]] && ok "State: ${GREEN}UP${NC}" || err "State: ${RED}${ls}${NC}"
    else err "NOT FOUND"; fi
    echo ""

    echo -e "    ${G2}━━━ 4. SERVICE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    if [[ -f "$SERVICE_FILE" ]]; then
        systemctl is-active --quiet vira-gre.service 2>/dev/null && ok "${GREEN}● ACTIVE${NC}" || err "${RED}● INACTIVE${NC}"
        systemctl is-enabled --quiet vira-gre.service 2>/dev/null && ok "Boot: ${GREEN}ON${NC}" || warn "Boot: OFF"
    else err "Not installed"; fi
    echo ""

    echo -e "    ${G2}━━━ 5. NETWORK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    [[ "$(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null)" == "1" ]] && ok "Forward: ${GREEN}ON${NC}" || err "Forward: ${RED}OFF${NC}"
    iptables -t nat -L ${VIRA_PRE} -n >/dev/null 2>&1 && ok "VIRA_PRE: ${GREEN}OK${NC}" || info "No VIRA_PRE"
    iptables -t nat -L ${VIRA_POST} -n >/dev/null 2>&1 && ok "VIRA_POST: ${GREEN}OK${NC}" || info "No VIRA_POST"
    echo ""

    echo -e "    ${G2}━━━ 6. PING TESTS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    local lp="" rp="" cr=""
    if $cfg; then
        cr="$sr"
        [[ "$sr" == "IRAN" ]] && { lp="$sip"; rp="$skp"; } || { lp="$skp"; rp="$sip"; }
    fi
    if [[ -n "$lp" ]]; then
        animated_ping "$lp" "TEST 1: Local (${cr}) → ${lp}"
        animated_ping "$rp" "TEST 2: Remote → ${rp}"
        $cfg && { local rpub; [[ "$sr" == "IRAN" ]] && rpub="$ski" || rpub="$sii"; animated_ping "$rpub" "TEST 3: Public → ${rpub}"; }
        animated_ping "8.8.8.8" "TEST 4: Internet"
    else animated_ping "8.8.8.8" "Internet"; fi

    echo -e "    ${G2}━━━ 7. HEALTH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    local tot=0 pass=0
    tot=$((tot+1)); lsmod | grep -q "ip_gre" && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} GRE      ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} GRE      ${RED}FAIL${NC}"
    tot=$((tot+1)); $tun_ok && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} Tunnel   ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} Tunnel   ${RED}FAIL${NC}"
    tot=$((tot+1)); systemctl is-active --quiet vira-gre.service 2>/dev/null && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} Service  ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} Service  ${RED}FAIL${NC}"
    tot=$((tot+1)); [[ "$(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null)" == "1" ]] && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} Forward  ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} Forward  ${RED}FAIL${NC}"
    tot=$((tot+1)); [[ -n "$lp" ]] && ping -c1 -W2 "$lp" >/dev/null 2>&1 && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} Local    ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} Local    ${RED}FAIL${NC}"
    tot=$((tot+1)); [[ -n "$rp" ]] && ping -c1 -W3 "$rp" >/dev/null 2>&1 && { pass=$((pass+1)); echo -e "    ${GREEN}✔${NC} Remote   ${GREEN}PASS${NC}"; } || echo -e "    ${RED}✘${NC} Remote   ${RED}FAIL${NC}"

    echo ""
    local pct=$((pass*100/tot))
    local hc="${RED}" ht="CRITICAL"
    ((pct>=100)) && { hc="${GREEN}"; ht="PERFECT"; }
    ((pct>=80 && pct<100)) && { hc="${GREEN}"; ht="HEALTHY"; }
    ((pct>=60 && pct<80)) && { hc="${YELLOW}"; ht="GOOD"; }
    ((pct>=40 && pct<60)) && { hc="${YELLOW}"; ht="DEGRADED"; }

    echo -e "    ${G3}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "    ${G3}║${NC}  ${hc}${BOLD}${pass}/${tot}${NC} (${hc}${pct}%${NC})  ${hc}${BOLD}⬤ ${ht}${NC}                              ${G3}║${NC}"
    echo -e "    ${G3}╚════════════════════════════════════════════════════╝${NC}"
    echo ""; echo -ne "    ${G2}❯${NC} Enter..."; read
}

# ──────────────────── RESTART ────────────────────

restart_tunnel() {
    show_logo
    echo -e "    ${G1}🔄${NC} ${WHITE}${BOLD}RESTARTING TUNNEL${NC}"
    echo ""
    [[ ! -f "$TUNNEL_SCRIPT" ]] && { err "Not installed"; echo -ne "\n    Enter..."; read; return; }

    step "1/4" "GRE..."; ensure_gre_module; ok "OK"
    step "2/4" "Stop..."
    systemctl stop vira-gre.service 2>/dev/null || true
    ip tunnel del ${TUNNEL_NAME} 2>/dev/null || true
    sleep 1; ok "Stopped"
    step "3/4" "Start..."
    bash "$TUNNEL_SCRIPT" 2>&1 || true
    systemctl restart vira-gre.service 2>/dev/null || true; sleep 1
    step "4/4" "Check..."
    if ip link show ${TUNNEL_NAME} 2>/dev/null | grep -qE "UP|UNKNOWN"; then
        local tip; tip=$(ip addr show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'inet \K[0-9.]+')
        ok "${GREEN}${BOLD}UP!${NC} IP: ${CYAN}${tip}${NC}"
    else err "Not up"; fi
    echo ""
    if load_config; then
        local my="" rem=""
        [[ "$ROLE" == "IRAN" ]] && { my="$IRAN_PRIVATE_IP"; rem="$KHAREJ_PRIVATE_IP"; } || { my="$KHAREJ_PRIVATE_IP"; rem="$IRAN_PRIVATE_IP"; }
        [[ -n "$my" ]] && animated_ping "$my" "Local → ${my}"
        [[ -n "$rem" ]] && animated_ping "$rem" "Remote → ${rem}"
    fi
    echo -ne "    ${G2}❯${NC} Enter..."; read
}

# ──────────────────── MENU ────────────────────

show_main_menu() {
    show_logo
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE" 2>/dev/null
        local ri="🌍"; [[ "$ROLE" == "IRAN" ]] && ri="🇮🇷"
        local ss="${RED}OFF${NC}"; systemctl is-active --quiet vira-gre.service 2>/dev/null && ss="${GREEN}ON${NC}"
        local tip; tip=$(ip addr show ${TUNNEL_NAME} 2>/dev/null | grep -oP 'inet \K[0-9.]+' || echo "N/A")
        echo -e "    ${DIM}Server: ${WHITE}${ROLE}${NC} ${ri}  Service: ${ss}  IP: ${CYAN}${tip}${NC}"
        echo ""
    fi
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}⚙${NC}  ${WHITE}${BOLD}MAIN MENU${NC}                                                 ${G3}│${NC}"
    echo -e "${G3}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${G3}    │${NC}   ${G2}[1]${NC} ➤ Setup IRAN       ${DIM}(Private: 10.10.10.1)${NC}               ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[2]${NC} ➤ Setup KHAREJ     ${DIM}(Private: 10.10.10.2)${NC}               ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[3]${NC} ➤ Status & Ping    ${DIM}(Full Diagnostics)${NC}                  ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[4]${NC} ➤ Restart Tunnel   ${DIM}(Restart + Test)${NC}                    ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[5]${NC} ➤ ${RED}Nuclear Uninstall${NC} ${DIM}(Complete Factory Reset)${NC}        ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${RED}[0]${NC} ➤ Exit                                                   ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -ne "    ${G2}❯${NC} Choice: "
}

main() {
    check_root
    while true; do
        show_main_menu; read ch
        case $ch in
            1) setup_iran ;; 2) setup_kharej ;; 3) check_status ;;
            4) restart_tunnel ;; 5) uninstall_tunnel ;;
            0) echo -e "\n    ${G2}★${NC} Thank you for using ${G1}VIRA TUNNEL${NC}!\n"; exit 0 ;;
            *) err "Invalid!"; sleep 1 ;;
        esac
    done
}

main "$@"
