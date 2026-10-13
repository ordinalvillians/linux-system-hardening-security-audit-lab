#!/usr/bin/env bash

# Day 5: Linux System Hardening and Security Audit
# Read-only checks for a Kali Linux lab.

set -u

REPORT="security_audit_report.txt"

{
    echo "========================================"
    echo " LINUX SECURITY AUDIT"
    echo "========================================"
    echo "Date: $(date)"
    echo "Host: $(hostname)"
    echo "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
    echo

    echo "1. APPARMOR"
    echo "----------------------------------------"
    systemctl is-active apparmor 2>&1 || true
    systemctl is-enabled apparmor 2>&1 || true
    cat /sys/module/apparmor/parameters/enabled 2>&1 || true
    echo

    echo "2. FIREWALL"
    echo "----------------------------------------"
    if command -v nft >/dev/null 2>&1; then
        sudo nft list ruleset 2>&1 || true
    else
        echo "nft command not found"
    fi
    echo

    echo "3. LISTENING NETWORK SOCKETS"
    echo "----------------------------------------"
    sudo ss -tulpn 2>&1 || true
    echo

    echo "4. SUDO GROUP"
    echo "----------------------------------------"
    getent group sudo || true
    echo

    echo "5. LOCAL USER ACCOUNTS"
    echo "----------------------------------------"
    awk -F: '$3 == 0 || $3 >= 1000 {
        print $1, "UID="$3, "HOME="$6, "SHELL="$7
    }' /etc/passwd
    echo

    echo "6. PASSWORD POLICY DEFAULTS"
    echo "----------------------------------------"
    grep -E '^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE)' \
        /etc/login.defs || true
    echo

    echo "7. SENSITIVE FILE PERMISSIONS"
    echo "----------------------------------------"
    stat -c '%a %U:%G %n' \
        /etc/passwd /etc/shadow /etc/group /etc/gshadow 2>&1
    echo

    echo "8. HOME DIRECTORY PERMISSIONS"
    echo "----------------------------------------"
    for home in /home/*; do
        if [ -d "$home" ]; then
            stat -c '%a %U:%G %n' "$home"
        fi
    done
    echo

    echo "9. AUTOMATIC UPDATE CONFIGURATION"
    echo "----------------------------------------"
    if dpkg-query -W -f='${Status}\n' unattended-upgrades \
        2>/dev/null | grep -q "install ok installed"; then
        echo "unattended-upgrades: installed"
    else
        echo "unattended-upgrades: not installed"
    fi
    systemctl list-timers --all --no-pager 2>&1 |
        grep -E 'apt-daily|upgrade' || true
    echo

    echo "========================================"
    echo " AUDIT COMPLETE"
    echo "========================================"

} 2>&1 | tee "$REPORT"

echo
echo "Report saved to: $PWD/$REPORT"
