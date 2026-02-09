#!/bin/bash
# ============================================================
#  VIRA TUNNEL - Professional GRE Tunnel Setup Script
#  Version : 2.0
#  Author  : Vira Network Team
#  License : Free / Open Source
# ============================================================

# ──────────────────── COLORS & STYLES ────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Golden Gradient Colors (256-color)
G1='\033[38;5;220m'
G2='\033[38;5;221m'
G3='\033[38;5;178m'
G4='\033[38;5;172m'
G5='\033[38;5;136m'
G6='\033[38;5;214m'
G7='\033[38;5;208m'
G8='\033[38;5;179m'
BG_DARK='\033[48;5;233m'
BG_GOLD='\033[48;5;136m'

# ──────────────────── FUNCTIONS ────────────────────

clear_screen() {
    clear
    echo ""
}

print_separator() {
    echo -e "${G5}    ╔══════════════════════════════════════════════════════════════╗${NC}"
}

print_separator_bottom() {
    echo -e "${G5}    ╚══════════════════════════════════════════════════════════════╝${NC}"
}

print_line() {
    echo -e "${G5}    ║${NC} $1 ${G5}║${NC}"
}

print_empty_line() {
    echo -e "${G5}    ║                                                              ║${NC}"
}

show_logo() {
    echo ""
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
    echo -e "${G8}    ║${NC}  ${G2}★${NC} ${WHITE}Professional GRE Tunnel Manager${NC}          ${DIM}Version 2.0${NC}   ${G8}    ║${NC}"
    echo -e "${G8}    ║${NC}  ${G3}★${NC} ${DIM}Secure${NC} ${WHITE}•${NC} ${DIM}Fast${NC} ${WHITE}•${NC} ${DIM}Reliable${NC} ${WHITE}•${NC} ${DIM}Persistent${NC}                    ${G8}  ║${NC}"
    echo -e "${G8}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_status_bar() {
    local role="$1"
    local status_color="${GREEN}"
    local role_icon=""
    
    if [[ "$role" == "IRAN" ]]; then
        role_icon="🇮🇷"
    elif [[ "$role" == "KHAREJ" ]]; then
        role_icon="🌍"
    fi
    
    echo -e "    ${BG_GOLD}${WHITE}${BOLD}  ⚡ Server Role: ${role} ${role_icon}  ${NC}"
    echo ""
}

show_main_menu() {
    clear_screen
    show_logo
    
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}⚙${NC}  ${WHITE}${BOLD}MAIN MENU${NC}                                                 ${G3}│${NC}"
    echo -e "${G3}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[1]${NC} ${WHITE}➤  Setup IRAN Server${NC}       ${DIM}(Local / Inside Server)${NC}      ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[2]${NC} ${WHITE}➤  Setup KHAREJ Server${NC}     ${DIM}(Remote / Outside Server)${NC}    ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[3]${NC} ${WHITE}➤  Check Tunnel Status${NC}     ${DIM}(Both Servers)${NC}              ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[4]${NC} ${WHITE}➤  Restart Tunnel${NC}          ${DIM}(Restart GRE Service)${NC}       ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}[5]${NC} ${WHITE}➤  Uninstall Tunnel${NC}        ${DIM}(Remove Everything)${NC}         ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${RED}[0]${NC} ${WHITE}➤  Exit${NC}                                                 ${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -ne "    ${G2}❯${NC} ${WHITE}Enter your choice: ${NC}"
}

print_step() {
    local step_num="$1"
    local step_msg="$2"
    echo -e "    ${G2}[Step ${step_num}]${NC} ${WHITE}${step_msg}${NC}"
}

print_success() {
    echo -e "    ${GREEN}  ✔  $1${NC}"
}

print_error() {
    echo -e "    ${RED}  ✘  $1${NC}"
}

print_warning() {
    echo -e "    ${YELLOW}  ⚠  $1${NC}"
}

print_info() {
    echo -e "    ${CYAN}  ℹ  $1${NC}"
}

progress_bar() {
    local duration=$1
    local msg="$2"
    local width=40
    echo -ne "    ${DIM}${msg}${NC} ["
    for ((i=0; i<=width; i++)); do
        local percent=$((i * 100 / width))
        echo -ne "${G2}█${NC}"
        sleep $(echo "scale=3; $duration/$width" | bc 2>/dev/null || echo "0.05")
    done
    echo -e "] ${GREEN}Done!${NC}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo ""
        print_error "This script must be run as root!"
        echo -e "    ${YELLOW}  ➤  Please run: ${WHITE}sudo bash $0${NC}"
        echo ""
        exit 1
    fi
}

validate_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            if ((i > 255)); then
                return 1
            fi
        done
        return 0
    fi
    return 1
}

get_server_ips() {
    local role="$1"
    
    echo ""
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}🔧${NC} ${WHITE}${BOLD}IP ADDRESS CONFIGURATION${NC}                                    ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Get IRAN Server IP
    while true; do
        echo -ne "    ${G2}❯${NC} ${WHITE}Enter IRAN Server Public IP: ${NC}"
        read IRAN_IP
        if validate_ip "$IRAN_IP"; then
            print_success "IRAN IP validated: ${CYAN}$IRAN_IP${NC}"
            break
        else
            print_error "Invalid IP address! Please try again."
        fi
    done
    
    echo ""
    
    # Get KHAREJ Server IP
    while true; do
        echo -ne "    ${G2}❯${NC} ${WHITE}Enter KHAREJ Server Public IP: ${NC}"
        read KHAREJ_IP
        if validate_ip "$KHAREJ_IP"; then
            print_success "KHAREJ IP validated: ${CYAN}$KHAREJ_IP${NC}"
            break
        else
            print_error "Invalid IP address! Please try again."
        fi
    done
    
    echo ""
    
    # Get Tunnel Private IPs (with defaults)
    echo -e "    ${DIM}Press Enter for default private IPs (10.10.10.1/30 & 10.10.10.2/30)${NC}"
    echo ""
    
    echo -ne "    ${G2}❯${NC} ${WHITE}IRAN Tunnel Private IP [${CYAN}10.10.10.1${NC}]: ${NC}"
    read IRAN_PRIVATE_IP
    IRAN_PRIVATE_IP=${IRAN_PRIVATE_IP:-10.10.10.1}
    if ! validate_ip "$IRAN_PRIVATE_IP"; then
        print_warning "Invalid IP, using default: 10.10.10.1"
        IRAN_PRIVATE_IP="10.10.10.1"
    fi
    
    echo -ne "    ${G2}❯${NC} ${WHITE}KHAREJ Tunnel Private IP [${CYAN}10.10.10.2${NC}]: ${NC}"
    read KHAREJ_PRIVATE_IP
    KHAREJ_PRIVATE_IP=${KHAREJ_PRIVATE_IP:-10.10.10.2}
    if ! validate_ip "$KHAREJ_PRIVATE_IP"; then
        print_warning "Invalid IP, using default: 10.10.10.2"
        KHAREJ_PRIVATE_IP="10.10.10.2"
    fi
    
    echo ""
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}📋${NC} ${WHITE}${BOLD}CONFIGURATION SUMMARY${NC}                                       ${G3}│${NC}"
    echo -e "${G3}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}IRAN Server IP${NC}        :  ${CYAN}${IRAN_IP}${NC}$(printf '%*s' $((30 - ${#IRAN_IP})) '')${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}KHAREJ Server IP${NC}      :  ${CYAN}${KHAREJ_IP}${NC}$(printf '%*s' $((30 - ${#KHAREJ_IP})) '')${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}IRAN Private IP${NC}       :  ${CYAN}${IRAN_PRIVATE_IP}/30${NC}$(printf '%*s' $((27 - ${#IRAN_PRIVATE_IP})) '')${G3}│${NC}"
    echo -e "${G3}    │${NC}   ${G2}KHAREJ Private IP${NC}     :  ${CYAN}${KHAREJ_PRIVATE_IP}/30${NC}$(printf '%*s' $((27 - ${#KHAREJ_PRIVATE_IP})) '')${G3}│${NC}"
    echo -e "${G3}    │${NC}                                                              ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    echo -ne "    ${G2}❯${NC} ${WHITE}Confirm and proceed? ${GREEN}[y]${NC}/${RED}[n]${NC}: "
    read confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" && "$confirm" != "" ]]; then
        print_warning "Aborted by user."
        return 1
    fi
    
    return 0
}

# ──────────────────── SETUP IRAN SERVER ────────────────────

setup_iran() {
    clear_screen
    show_logo
    show_status_bar "IRAN"
    
    get_server_ips "IRAN" || return
    
    echo ""
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}🚀${NC} ${WHITE}${BOLD}INSTALLING IRAN SERVER (GRE TUNNEL)${NC}                         ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Step 1: Create GRE Tunnel Script
    print_step "1/7" "Creating GRE tunnel script..."
    
    cat > /usr/local/sbin/vira-gre.sh << EOFSCRIPT
#!/bin/bash
set -e

# VIRA TUNNEL - GRE Tunnel Script (IRAN Side)
# Auto-generated by VIRA TUNNEL Manager

ip tunnel del viraGRE 2>/dev/null || true

ip tunnel add viraGRE mode gre remote ${KHAREJ_IP} local ${IRAN_IP} ttl 255
ip link set viraGRE mtu 1476
ip addr add ${IRAN_PRIVATE_IP}/30 dev viraGRE
ip link set viraGRE up
EOFSCRIPT
    
    chmod +x /usr/local/sbin/vira-gre.sh
    print_success "Tunnel script created at /usr/local/sbin/vira-gre.sh"
    sleep 0.5
    
    # Step 2: Enable IP Forwarding
    print_step "2/7" "Enabling IP forwarding..."
    
    # Remove duplicate entries
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p > /dev/null 2>&1
    print_success "IP forwarding enabled permanently"
    sleep 0.5
    
    # Step 3: Install iptables-persistent
    print_step "3/7" "Installing iptables-persistent..."
    
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections 2>/dev/null || true
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections 2>/dev/null || true
    apt-get update -qq > /dev/null 2>&1
    apt-get install -y -qq iptables-persistent > /dev/null 2>&1
    print_success "iptables-persistent installed"
    sleep 0.5
    
    # Step 4: Configure NAT Rules
    print_step "4/7" "Configuring NAT/iptables rules..."
    
    # Flush existing VIRA rules to avoid duplicates
    iptables -t nat -D PREROUTING -p tcp --dport 22 -j DNAT --to-destination ${IRAN_PRIVATE_IP} 2>/dev/null || true
    iptables -t nat -D PREROUTING -j DNAT --to-destination ${KHAREJ_PRIVATE_IP} 2>/dev/null || true
    
    # Add NAT rules
    iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to-destination ${IRAN_PRIVATE_IP}
    iptables -t nat -A PREROUTING -j DNAT --to-destination ${KHAREJ_PRIVATE_IP}
    
    # Check if MASQUERADE already exists
    if ! iptables -t nat -C POSTROUTING -j MASQUERADE 2>/dev/null; then
        iptables -t nat -A POSTROUTING -j MASQUERADE
    fi
    
    print_success "NAT rules configured"
    sleep 0.5
    
    # Step 5: Save iptables rules
    print_step "5/7" "Saving iptables rules..."
    netfilter-persistent save > /dev/null 2>&1
    print_success "Rules saved permanently"
    sleep 0.5
    
    # Step 6: Create Systemd Service
    print_step "6/7" "Creating systemd service..."
    
    cat > /etc/systemd/system/vira-gre.service << 'EOFSERVICE'
[Unit]
Description=VIRA TUNNEL - GRE Tunnel (IRAN)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/vira-gre.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOFSERVICE
    
    print_success "Systemd service created"
    sleep 0.5
    
    # Step 7: Enable and Start Service
    print_step "7/7" "Enabling and starting tunnel service..."
    
    systemctl daemon-reload
    systemctl enable --now vira-gre.service > /dev/null 2>&1
    print_success "Tunnel service enabled and started"
    sleep 0.5
    
    echo ""
    progress_bar 2 "Finalizing setup"
    echo ""
    
    # Final Status
    echo -e "${G3}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${G3}    ║${NC}  ${GREEN}${BOLD}✅ IRAN SERVER SETUP COMPLETED SUCCESSFULLY!${NC}                  ${G3}║${NC}"
    echo -e "${G3}    ╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${YELLOW}📌 Next Steps:${NC}                                              ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  1. Run this script on the KHAREJ server${NC}                    ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  2. Reboot both servers${NC}                                     ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  3. Check tunnel status from the menu${NC}                       ${G3}║${NC}"
    echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
    echo -e "${G3}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
    read
}

# ──────────────────── SETUP KHAREJ SERVER ────────────────────

setup_kharej() {
    clear_screen
    show_logo
    show_status_bar "KHAREJ"
    
    get_server_ips "KHAREJ" || return
    
    echo ""
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}🚀${NC} ${WHITE}${BOLD}INSTALLING KHAREJ SERVER (GRE TUNNEL)${NC}                       ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Step 1: Create GRE Tunnel Script
    print_step "1/6" "Creating GRE tunnel script..."
    
    cat > /usr/local/sbin/vira-gre.sh << EOFSCRIPT
#!/bin/bash
set -e

# VIRA TUNNEL - GRE Tunnel Script (KHAREJ Side)
# Auto-generated by VIRA TUNNEL Manager

ip tunnel del viraGRE 2>/dev/null || true

ip tunnel add viraGRE mode gre remote ${IRAN_IP} local ${KHAREJ_IP} ttl 255
ip link set viraGRE mtu 1476
ip addr add ${KHAREJ_PRIVATE_IP}/30 dev viraGRE
ip link set viraGRE up
EOFSCRIPT
    
    chmod +x /usr/local/sbin/vira-gre.sh
    print_success "Tunnel script created at /usr/local/sbin/vira-gre.sh"
    sleep 0.5
    
    # Step 2: Enable IP Forwarding
    print_step "2/6" "Enabling IP forwarding..."
    
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p > /dev/null 2>&1
    print_success "IP forwarding enabled permanently"
    sleep 0.5
    
    # Step 3: Install iptables-persistent
    print_step "3/6" "Installing iptables-persistent..."
    
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections 2>/dev/null || true
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections 2>/dev/null || true
    apt-get update -qq > /dev/null 2>&1
    apt-get install -y -qq iptables-persistent > /dev/null 2>&1
    print_success "iptables-persistent installed"
    sleep 0.5
    
    # Step 4: Configure NAT Rules
    print_step "4/6" "Configuring MASQUERADE rule..."
    
    if ! iptables -t nat -C POSTROUTING -j MASQUERADE 2>/dev/null; then
        iptables -t nat -A POSTROUTING -j MASQUERADE
    fi
    
    print_success "MASQUERADE rule configured"
    sleep 0.5
    
    # Step 5: Save iptables rules
    print_step "5/6" "Saving iptables rules..."
    netfilter-persistent save > /dev/null 2>&1
    print_success "Rules saved permanently"
    sleep 0.5
    
    # Step 6: Create and Enable Systemd Service
    print_step "6/6" "Creating and enabling systemd service..."
    
    cat > /etc/systemd/system/vira-gre.service << 'EOFSERVICE'
[Unit]
Description=VIRA TUNNEL - GRE Tunnel (KHAREJ)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/vira-gre.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOFSERVICE
    
    systemctl daemon-reload
    systemctl enable --now vira-gre.service > /dev/null 2>&1
    print_success "Tunnel service enabled and started"
    sleep 0.5
    
    echo ""
    progress_bar 2 "Finalizing setup"
    echo ""
    
    echo -e "${G3}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${G3}    ║${NC}  ${GREEN}${BOLD}✅ KHAREJ SERVER SETUP COMPLETED SUCCESSFULLY!${NC}                ${G3}║${NC}"
    echo -e "${G3}    ╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${YELLOW}📌 Next Steps:${NC}                                              ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  1. Make sure IRAN server is also configured${NC}                ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  2. Reboot both servers${NC}                                     ${G3}║${NC}"
    echo -e "${G3}    ║${NC}  ${WHITE}  3. Check tunnel status from the menu${NC}                       ${G3}║${NC}"
    echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
    echo -e "${G3}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
    read
}

# ──────────────────── CHECK STATUS ────────────────────

check_status() {
    clear_screen
    show_logo
    
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}📊${NC} ${WHITE}${BOLD}TUNNEL STATUS CHECK${NC}                                         ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Check if tunnel interface exists
    echo -e "    ${G2}━━━ Tunnel Interface ━━━${NC}"
    echo ""
    if ip tunnel show 2>/dev/null | grep -q "viraGRE"; then
        ip tunnel show viraGRE 2>/dev/null | while read line; do
            echo -e "    ${GREEN}  ✔${NC}  ${WHITE}$line${NC}"
        done
    else
        print_warning "No VIRA tunnel interface found"
    fi
    
    echo ""
    echo -e "    ${G2}━━━ Tunnel IP Address ━━━${NC}"
    echo ""
    if ip addr show viraGRE 2>/dev/null | grep -q "inet"; then
        ip addr show viraGRE 2>/dev/null | grep "inet" | while read line; do
            echo -e "    ${GREEN}  ✔${NC}  ${WHITE}$line${NC}"
        done
    else
        print_warning "No IP assigned to tunnel"
    fi
    
    echo ""
    echo -e "    ${G2}━━━ Service Status ━━━${NC}"
    echo ""
    if systemctl is-active --quiet vira-gre.service 2>/dev/null; then
        print_success "vira-gre.service is ${GREEN}ACTIVE${NC}"
    else
        print_error "vira-gre.service is ${RED}INACTIVE${NC}"
    fi
    
    if systemctl is-enabled --quiet vira-gre.service 2>/dev/null; then
        print_success "vira-gre.service is ${GREEN}ENABLED${NC} (starts on boot)"
    else
        print_warning "vira-gre.service is ${YELLOW}DISABLED${NC}"
    fi
    
    echo ""
    echo -e "    ${G2}━━━ IP Forwarding ━━━${NC}"
    echo ""
    local fwd=$(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null)
    if [[ "$fwd" == "1" ]]; then
        print_success "IP Forwarding is ${GREEN}ENABLED${NC}"
    else
        print_error "IP Forwarding is ${RED}DISABLED${NC}"
    fi
    
    echo ""
    echo -e "    ${G2}━━━ NAT Rules (iptables) ━━━${NC}"
    echo ""
    iptables -t nat -L -n -v 2>/dev/null | head -30 | while read line; do
        echo -e "    ${DIM}  $line${NC}"
    done
    
    echo ""
    echo -e "    ${G2}━━━ Ping Test ━━━${NC}"
    echo ""
    
    # Try to detect private IPs from the tunnel script
    if [[ -f /usr/local/sbin/vira-gre.sh ]]; then
        local local_ip=$(grep "ip addr add" /usr/local/sbin/vira-gre.sh | awk '{print $4}' | cut -d'/' -f1)
        
        # Determine remote IP
        local net_prefix=$(echo "$local_ip" | cut -d'.' -f1-3)
        local last_octet=$(echo "$local_ip" | cut -d'.' -f4)
        
        if [[ "$last_octet" == "1" ]]; then
            remote_private="$net_prefix.2"
        else
            remote_private="$net_prefix.1"
        fi
        
        print_info "Pinging remote tunnel endpoint: ${CYAN}$remote_private${NC}"
        if ping -c 3 -W 2 "$remote_private" > /dev/null 2>&1; then
            print_success "Tunnel is ${GREEN}WORKING${NC} - Ping successful!"
        else
            print_error "Tunnel is ${RED}DOWN${NC} - Ping failed!"
            print_warning "Make sure the other server is configured and running"
        fi
    else
        print_warning "Tunnel script not found, skipping ping test"
    fi
    
    echo ""
    echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
    read
}

# ──────────────────── RESTART TUNNEL ────────────────────

restart_tunnel() {
    clear_screen
    show_logo
    
    echo -e "${G3}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${G3}    │${NC}  ${G1}🔄${NC} ${WHITE}${BOLD}RESTARTING TUNNEL${NC}                                           ${G3}│${NC}"
    echo -e "${G3}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    if [[ -f /etc/systemd/system/vira-gre.service ]]; then
        print_step "1/2" "Stopping tunnel service..."
        systemctl stop vira-gre.service 2>/dev/null || true
        print_success "Service stopped"
        sleep 1
        
        print_step "2/2" "Starting tunnel service..."
        systemctl start vira-gre.service 2>/dev/null
        
        if systemctl is-active --quiet vira-gre.service; then
            print_success "Tunnel restarted successfully!"
        else
            print_error "Failed to restart tunnel!"
            echo ""
            print_info "Service logs:"
            journalctl -u vira-gre.service --no-pager -n 10 2>/dev/null | while read line; do
                echo -e "    ${DIM}  $line${NC}"
            done
        fi
    else
        print_error "No VIRA tunnel service found!"
        print_info "Please install the tunnel first"
    fi
    
    echo ""
    echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
    read
}

# ──────────────────── UNINSTALL ────────────────────

uninstall_tunnel() {
    clear_screen
    show_logo
    
    echo -e "${RED}    ┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}    │${NC}  ${RED}⚠${NC}  ${WHITE}${BOLD}UNINSTALL VIRA TUNNEL${NC}                                      ${RED}│${NC}"
    echo -e "${RED}    └──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    print_warning "This will remove all VIRA tunnel configurations!"
    echo ""
    echo -ne "    ${RED}❯${NC} ${WHITE}Are you sure? Type '${RED}YES${NC}' to confirm: ${NC}"
    read confirm
    
    if [[ "$confirm" != "YES" ]]; then
        print_info "Uninstall cancelled."
        echo ""
        echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
        read
        return
    fi
    
    echo ""
    
    # Stop and disable service
    print_step "1/5" "Stopping tunnel service..."
    systemctl stop vira-gre.service 2>/dev/null || true
    systemctl disable vira-gre.service 2>/dev/null || true
    print_success "Service stopped and disabled"
    
    # Remove tunnel interface
    print_step "2/5" "Removing tunnel interface..."
    ip tunnel del viraGRE 2>/dev/null || true
    print_success "Tunnel interface removed"
    
    # Remove files
    print_step "3/5" "Removing configuration files..."
    rm -f /usr/local/sbin/vira-gre.sh
    rm -f /etc/systemd/system/vira-gre.service
    systemctl daemon-reload
    print_success "Configuration files removed"
    
    # Clean iptables (optional)
    print_step "4/5" "Cleaning NAT rules..."
    iptables -t nat -F PREROUTING 2>/dev/null || true
    iptables -t nat -F POSTROUTING 2>/dev/null || true
    iptables -t nat -A POSTROUTING -j MASQUERADE 2>/dev/null || true
    netfilter-persistent save > /dev/null 2>&1 || true
    print_success "NAT rules cleaned"
    
    # Note about IP forwarding
    print_step "5/5" "Cleanup complete"
    print_info "IP forwarding setting left unchanged"
    
    echo ""
    echo -e "${GREEN}    ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}    ║${NC}  ${GREEN}✅${NC} ${WHITE}VIRA TUNNEL has been successfully uninstalled!${NC}               ${GREEN}║${NC}"
    echo -e "${GREEN}    ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -ne "    ${G2}❯${NC} ${WHITE}Press Enter to return to menu...${NC}"
    read
}

# ──────────────────── MAIN LOOP ────────────────────

main() {
    check_root
    
    while true; do
        show_main_menu
        read choice
        
        case $choice in
            1)
                setup_iran
                ;;
            2)
                setup_kharej
                ;;
            3)
                check_status
                ;;
            4)
                restart_tunnel
                ;;
            5)
                uninstall_tunnel
                ;;
            0)
                clear_screen
                echo ""
                echo -e "${G3}    ╔══════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
                echo -e "${G3}    ║${NC}  ${G2}★${NC} ${WHITE}Thank you for using ${G1}VIRA TUNNEL${NC}${WHITE}!${NC}                          ${G3}║${NC}"
                echo -e "${G3}    ║${NC}  ${DIM}  Secure connections, powered by VIRA.${NC}                      ${G3}║${NC}"
                echo -e "${G3}    ║${NC}                                                              ${G3}║${NC}"
                echo -e "${G3}    ╚══════════════════════════════════════════════════════════════╝${NC}"
                echo ""
                exit 0
                ;;
            *)
                print_error "Invalid option! Please try again."
                sleep 1
                ;;
        esac
    done
}

# ──────────────────── RUN ────────────────────
main "$@"
