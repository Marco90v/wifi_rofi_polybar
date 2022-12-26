#!/bin/bash

# https://github.com/zbaylin/rofi-wifi-menu/blob/master/rofi-wifi-menu.sh
# https://github.com/P3rf/rofi-network-manager/blob/master/rofi-network-manager.sh


INTERFACE=$(nmcli device | awk '/wifi/ && length($2) == 4 {print $1}')
FIELDS=SSID,BARS,SECURITY
LIST=$(nmcli --fields "$FIELDS" device wifi list | awk 'NR>1{ 
    if($NF != "--") { 
        {gsub("WPA1 WPA2","")} 
        {gsub("WPA1","")} 
        {gsub("WPA2","")} 
        print 
    } 
    else { 
        {gsub("--","")} 
        print 
    } 
}')
LINENUM=$(echo "$LIST" | wc -l)
RWIDTH=


if [[ $(echo "$LIST" | awk 'NR') < 1 ]]; then
    LIST="Red wifi no activada"
    RWIDTH=40
else
    RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
fi

LIST_WIFI(){
    SELECTION=$(echo "$LIST" | rofi -dmenu -width -"$RWIDTH" -lines "$LINENUM" -theme ~/.config/polybar/hack/scripts/rofi/networkmenu.rasi -p "Wifi - Interfaz: "$INTERFACE"")
    if [[ "$SELECTION" != "" ]]; then
        CONNECT
    fi
}

CONNECT(){
    INMEMORY=$(nmcli connection show | grep wifi | awk '{print $1}')
    colums=$(echo "$SELECTION" | awk '{print NF}')
    SSID=$(echo "$SELECTION" | awk -v start=1 -v end="$(($colums-2))" ' { for (i=start; i<=end; i++) printf("%s%s", $i, (i==end) ? "\n" : OFS) } ')

    # CHSSID=$(echo "$SELECTION" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
    # echo $CHSSID


    if [[ $(echo "$INMEMORY" | grep "$SSID") == "$SSID" ]]; then
        ACTIVE=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^sí/ {print $2}')
        if [[ "$ACTIVE" == "$SSID" ]]; then
            notify-send "Wifi - SSID: $SSID" "Conexión ya se encuentra activa"
        else
            REST=$(nmcli connection up "$SSID")
            if [[ "$REST" == *"activada"* ]]; then
                notify-send "Wifi - SSID: $SSID" "Conexión activada con éxito."
            else
                notify-send "Wifi - SSID: $SSID" "¡Error al conectar!" -u critical
            fi
        fi
    else
        TIPO=$(echo "$SELECTION" | awk '{print $NF}')
        if [[ "$TIPO" = "" ]]; then
            PASSWORD=""
            PASSWORD=$(rofi -dmenu -password -p "Contraseña:" -lines 0 -theme ~/.config/polybar/hack/scripts/rofi/inputPassword.rasi)
            if [[ "$PASSWORD" == "" ]]; then
                LIST_WIFI
            else
                REST=$(nmcli device wifi connect "$SSID" password "$PASSWORD")
                if [[ "$REST" == *"activada"* ]]; then
                    notify-send "Wifi - SSID: $SSID" "Conexión activada con éxito."
                else
                    notify-send "Wifi - SSID: $SSID" "¡Error al conectar, verifique la contraseña!" -u critical
                fi
            fi
        fi
    fi
}

LIST_WIFI

