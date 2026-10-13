# Linux System Hardening and Security Auditing Lab

A beginner-friendly cybersecurity portfolio project demonstrating Linux security auditing, configuration inspection, and evidence-based risk assessment in Kali Linux.

## Objectives

- Inspect AppArmor status and profile enforcement.
- Review nftables firewall rules without modifying Docker-managed rules.
- Identify listening network sockets.
- Review sudo group membership and local accounts.
- Inspect password aging defaults.
- Verify permissions on sensitive system files and user home directories.
- Check unattended-upgrades package status and APT timer configuration.

## Environment

- **Operating system:** Kali Linux Rolling 2026.3
- **Environment:** VMware virtual machine
- **Shell:** Bash
- **Tools:** `systemctl`, `aa-status`, `nft`, `ss`, `getent`, `awk`, `stat`, `dpkg-query`, and `journalctl`

## Project Files

- `security_audit.sh` — read-only audit script.
- `security_audit_report_public.txt` — sanitized audit output for publication.
- `AUDIT_SUMMARY.md` — findings and assessment limitations.

## How to Run

Clone the repository and enter the project directory:

```bash
git clone https://github.com/ordinalvillians/linux-system-hardening-security-audit-lab.git
cd linux-system-hardening-security-audit-lab
```

Inspect the script before executing it:

```bash
less security_audit.sh
```

Check Bash syntax:

```bash
bash -n security_audit.sh
```

Run the audit:

```bash
bash security_audit.sh
```

Some checks use `sudo` to read privileged system information. Run the script only on a machine you own or are authorized to assess.

## Key Findings

The initial audit identified several areas for review:

- AppArmor's kernel support was loaded, but the service was disabled.
- Docker-managed nftables rules were present; host inbound filtering was not independently verified.
- The account inventory included four additional user accounts.
- The default maximum password age was 99,999 days.
- The `unattended-upgrades` package was not installed, although APT daily timers were scheduled.
- The inspected sensitive file and user home directory permissions matched the recorded values in the audit summary.

See [`AUDIT_SUMMARY.md`](AUDIT_SUMMARY.md) for the detailed findings and limitations.

## Safety and Scope

This project is intended for defensive learning and portfolio demonstration. The audit script gathers configuration and runtime evidence; it does not intentionally change firewall rules, accounts, passwords, or security service settings.

The results represent one point in time and do not constitute a complete penetration test or security certification. Findings require context and validation before remediation.

## Skills Demonstrated

Linux administration, Bash scripting, security auditing, access control review, file permission analysis, network socket inspection, firewall rule review, and technical documentation.

### Report privacy

Running the script generates `security_audit_report.txt`, which may contain machine-specific details such as host information, account names, network information, and service configuration. Review and redact the report before sharing it. The public example in this repository is sanitized.
