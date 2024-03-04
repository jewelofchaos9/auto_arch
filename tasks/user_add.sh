useradd defkit;
mkdir /home/defkit/;
mkdir /home/defkit/.config;
usermod --shell /bin/fish defkit;
chown -R defkit /home/defkit;
chown -R defkit /home/defkit/.config;
echo "exec i3" >> /home/defkit/.xinitrc

groupadd -f docker;
usermod -aG docker defkit;
systemctl enable docker;
