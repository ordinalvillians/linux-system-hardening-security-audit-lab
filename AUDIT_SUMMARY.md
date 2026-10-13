# Day 5: Linux System Hardening and Security Audit

## Assessment Summary

This lab performs a read-only security audit of a Kali Linux virtual machine.

The audit examines AppArmor, firewall rules, listening network sockets, sudo group membership, local accounts, password policy defaults, sensitive file permissions, home directory permissions, and automatic update configuration.

## Findings

| Area | Status | Evidence |
|---|---|---|
| AppArmor | REVIEW | Kernel module loaded; one enforcing profile (`docker-default`); service disabled |
| Firewall | REVIEW | Docker-managed nftables rules found; host inbound filtering not independently verified |
| Listening sockets | REVIEW | Earlier snapshot recorded UDP port 59363 and a loopback TCP socket; later UDP check showed no UDP listeners |
| Sudo access | PASS | Only `kali` listed in the sudo group |
| Local accounts | REVIEW | Four additional user accounts found; authorization and business need not yet verified |
| Password policy | REVIEW | `PASS_MAX_DAYS` is 99999 and `PASS_MIN_DAYS` is 0 |
| Sensitive file permissions | PASS | `/etc/passwd` and `/etc/group` are mode 644; `/etc/shadow` and `/etc/gshadow` are mode 640 |
| Home directory permissions | PASS | Four inspected user home directories are mode 700 |
| Automatic updates | REVIEW | `unattended-upgrades` is not installed; APT daily timers are scheduled |

## Important Limitations

- These findings describe the observed configuration, not a complete security certification.
- Docker-managed firewall rules do not independently prove that host inbound traffic is adequately filtered.
- A scheduled APT timer does not prove that updates were successfully installed.
- Account presence alone does not establish whether an account is unnecessary or unauthorized.
- The earlier UDP socket observation was not reproduced in the later check.
- PASS means the specific observed check met its stated criterion; it does not mean the entire system is secure.

## Method

The audit uses standard Linux tools and reads system configuration and runtime status. No firewall rules, accounts, passwords, or security services were intentionally changed during evidence collection.

## Conclusion

The audit identified several areas requiring further review, particularly AppArmor service configuration, host firewall filtering, account necessity, password aging, and update automation. Findings should be validated and remediated only after their operational impact is understood.
