# wifi_rofi_polybar

Este es script fue realizado con la finalidad de gestionar la conexión a las redes wifi.

Este Script se estará ejecutando desde la polybar y usara rofi para visualizar los resultados, y las notificaciones.

Para usar se debe ejecutar el script directamente sin pasar ningún tipo de parámetros.  
Se listaran las redes wifi disponibles, seleccione una red e ingrese la contraseña si es solicitada.  
De estar almacenada la red ingresara directamente.

Actualizaciones pendientes, gestión de error si la contraseña fue modificada y conexión a redes sin contraseña.

## Modulo de Polybar
En el siguiente modulo podra observar una llamada a `toggle-wifi.sh` es un simple script que habilita y desabilita la targeta wifi.

```ini
[module/togglewifi]
type = custom/script
exec = ~/.config/polybar/hack/scripts/toggle-wifi.sh
tail = true
enable-click = true
click-right = ~/.config/polybar/hack/scripts/toggle-wifi.sh toggle
click-left = ~/.config/polybar/hack/scripts/wifi.sh
interval = 10
content = "%output%"
```

## Vista Previa

![List Password](https://github.com/Marco90v/wifi_rofi_polybar/blob/main/select_wifi.png)

![Insert Password](https://github.com/Marco90v/wifi_rofi_polybar/blob/main/password_wifi.png)
