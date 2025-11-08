# Post-Quantum Ready OpenSSH Builds for Debian LTS & ELTS

Some **Debian distributions** — including both **Long Term Support (LTS)** and **Extended Long Term Support (ELTS)** releases — still rely on **older versions of OpenSSH**.  

Starting with **OpenSSH 10**, the foundation introduced an **explicit banner** that notifies users when the server daemon lacks **post-quantum cryptography (PQC)** protection. The message is the following:
```** WARNING: connection is not using a post-quantum key exchange algorithm.
** This session may be vulnerable to "store now, decrypt later" attacks.
** The server may need to be upgraded. See https://openssh.com/pq.html
```

This repository provides **custom OpenSSH builds for Debian** that:
- **Avoid** displaying the new PQC warning banner.  
- **Maintain compatibility** with **LTS and ELTS** Debian releases.  
- **Include post-quantum cryptography support**, bringing modern protection to your old neighborhood friend. 🛠️💻

---
## 💭 A Thought

Here I can only remember that old cartoon *Animaniacs* with the segment: **“Good Idea, Bad Idea.”**

- **Good idea:** Encourage users to adopt stronger cryptographic algorithms.  
- **Bad idea:** Encourage attackers to target weak servers.  

I believe this is **not the best approach**, because vendors usually **backport security patches** to the older supported versions.  
By simply patching servers “for sport” or just to **comply with a policy without proper feedback**, you may end up giving **attackers a clear signal** about which servers are potentially vulnerable. 🚨  

But I think that strategy worked… **this repository is a proof of that.**

---
## 🧩 Features
- Built for **legacy Debian environments** (LTS and ELTS).  
- **No PQC banner**, for a cleaner login experience.  
- **Full PQC protection** integrated where possible.  
- Same configuration and service management as upstream OpenSSH.

---

## ⚙️ Supported Debian Versions
- Debian 9 “Stretch” (ELTS)  
- Debian 10 “Buster” (ELTS)  
- Debian 11 “Bullseye” (LTS)  
- (Additional support may be added later.)

---

## 📦 Installation

```bash
# Example for Debian 10 (Buster)
sudo apt install ./openssh${version}.deb
# Patch your systemd unit... you can find a script that do the same on the repository
sudo systemctl restart ssh
```
