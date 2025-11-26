Для настройки подключения к openconnect нужно:
1. Создать пароль в текстовом виде и зашифровать его с помошью утилиты `gpg`
```bash
echo "your_vpn_password" | gpg --symmetric --output /etc/vpn/pass.gpg
```
2. Адаптировать [скрипт](connect-vpn) под конкретное подключение и поместить его в `/usr/local/bin/`
3. Сделать скрипт исполняемым
