#!/bin/bash
USER=$(whoami)
if [[ ${USER} == "root" ]]
then
	cat > /etc/systemd/system/sshd.service << EOF
[Unit]
Description=OpenBSD Secure Shell server
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/local/sbin/sshd -t
ExecStart=/usr/local/sbin/sshd -D $SSHD_OPTS
ExecReload=/usr/local/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
EOF
	/usr/bin/systemctl daemon-reload
	/usr/bin/systemctl restart sshd
else
	echo "You need administrator privileges or run this script as root"
fi
