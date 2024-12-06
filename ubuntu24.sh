#!/bin/bash

# Habilita o modo superusuário
sudo -s

# Baixa o pacote de instalação do repositório Zabbix
echo "Baixando o pacote de instalação do repositório Zabbix..."
wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb

# Instala o pacote de repositório do Zabbix
echo "Instalando o pacote de repositório do Zabbix..."
dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb

# Atualiza os pacotes
echo "Atualizando os pacotes do sistema..."
apt update -y

# Instala o agente Zabbix e plugins
echo "Instalando o Zabbix Agent 2 e plugins..."
apt install -y zabbix-agent2 zabbix-agent2-plugin-*

# Altera a configuração do Zabbix Agent 2
CONFIG_FILE="/etc/zabbix/zabbix_agent2.conf"
SERVER_IP="104.243.40.39"

echo "Alterando o arquivo de configuração: $CONFIG_FILE"
if grep -q "^Server=" "$CONFIG_FILE"; then
    sudo sed -i "s/^Server=.*/Server=$SERVER_IP/" "$CONFIG_FILE"
else
    echo "Server=$SERVER_IP" | sudo tee -a "$CONFIG_FILE"
fi

# Reinicia o serviço Zabbix Agent 2
echo "Reiniciando o serviço Zabbix Agent 2..."
systemctl restart zabbix-agent2

# Habilita o serviço Zabbix Agent 2 para iniciar automaticamente
echo "Habilitando o Zabbix Agent 2 no boot..."
systemctl enable zabbix-agent2

echo "Instalação e configuração do Zabbix Agent 2 concluídas com sucesso!"
