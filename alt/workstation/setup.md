# Общий порядок конфигурации ALT Рабочая станция

> Актуально для версии 11.0 с окружением GNOME

## Действия при установке системы
Опции, применяемые в установщике ALT Workstation.

### Разметка диска
Базовая конфигурация разделов:
* `EFI`: 1024M - c точкой монтирования `/boot/efi`
* `swap`: RAM / 2
* `/`: 40% оставшегося места
* `/home`: 60% оставшегося места

**Шифрование разделов:**
* Необходимо создать раздел LVM с файловой системой типа `basic storage`
* Затем внутри LVM создать шифрованные разделы для `/`, `/home` и `swap` с необходимыми файловыми системами.
* Пароль для шифрования обычно устанавливается на более поздних этапах установки (после пароля администратора и основного пользователя).

### Установка загрузчика
В версии 11.0 с окружением GNOME, на некоторых компьютерах есть проблемы с установкой загрузчика инсталлятором (он зависает).
Рекомендуется выбрать опцию "Не устанавливать загрузчик", а затем, после окончания установки, установить загрузчик вручную (через Rescue режим, например).
> Если было использовано шифрование разделов - ручная установка загрузчика требует дополнительных манипуляций (расшифрование разделов при монтировании и прописывание "GRUB_ENABLE_CRYPTODISK=y" в /etc/default/grub)

### Дополнительные приложения
* GIMP
* Flatpak
* GNOME Tweaks
* GNOME Extensions

### После установки
* При первом входе необходимо сменить язык на английский (и согласиться на автоматическое переименование пользовательских директорий).
* Также нужно сразу настроить сеть.

## Конфигурация системы
Начальные действия по конфигурации пользовательского окружения.
* Настройка sudo для пользователя
* Кастомные конфигурации GNOME
  * Отключить автоподстройку яркости экрана (для ноутбуков)
  * Центрировать открывающиеся окна (без максимизации)
  * Установить формат показа времени на 24 часа и добавить дату

```bash
su -
curl -sL https://raw.githubusercontent.com/eppv/linux-setup/refs/heads/main/alt/workstation/initconf.sh | sh
```

## Установка приложений
Набор пользовательских приложений, которые нужно установить дополнительно после установки системы.

### Базовые
* git
* [Alacritty](https://github.com/alacritty/alacritty) - терминал с хорошими возможностями конфигурации, написанный на Rust
* Yandex Browser - для установки полноценной версии потребуется доступ к репозиторию [Aides](https://altlinux.space/aides-pkgs) и инструмент для сборки [ALR](https://gitea.plemya-x.ru/Plemya-x/ALR)
* Telegram Client (Telegram Desktop, либо [Auygram](https://github.com/AyuGram/AyuGramDesktop))
* [Syncthing](https://syncthing.net/) - синхронизация файлов между устройствами (p2p)
* [Obsidian](https://obsidian.md/)
* [Zed](https://zed.dev/) - редактор кода
* neofetch
* btop

```bash
sudo su -
curl -sL https://raw.githubusercontent.com/eppv/linux-setup/refs/heads/main/alt/workstation/install-apps.sh | sh
```

### Рабочие
* [openconnect](https://www.infradead.org/openconnect/) - альтернативный консольный клиент для разных VPN, либо:
  * [openfortivpn](https://github.com/adrienverge/openfortivpn) - альтернативный консольный клиент для Fortinet VPN
* [gnome-connections](https://gitlab.gnome.org/GNOME/gnome-connections) - базовый клиент для удаленного доступа в GNOME
* [Remmina](https://remmina.org/) - клиент для удаленного доступа к удаленным рабочим станциям


### Офисные
* OnlyOffice Desktop Editors - офисные приложения для работы с документами, таблицами и презентациями

### Медиа
* GIMP - графический редактор изображений
* [mpv](https://mpv.io/) - легковесный консольный медиаплеер

### Разработка
* [uv](https://github.com/astral-sh/uv) - менеджер пакетов для Python
* [rustup](https://rustup.rs/) - инструмент для установки и управления Rust
* [go](https://golang.org/) - язык программирования Google
* node.js - платформа для создания веб-приложений
* [Docker](https://www.docker.com/) - платформа для разработки, тестирования и запуска приложений в контейнерах
* [ALR](https://gitea.plemya-x.ru/Plemya-x/ALR)


### Прочее
* qBittorrent - клиент для скачивания торрентов
* Steam
* [PyCharm](https://www.jetbrains.com/pycharm/) - интегрированная среда разработки для Python
* [Grist](https://grist.com/) - платформа для работы с таблицами и документами
* [zellij](https://zellij.dev/) - мультиплексор терминалов
* [Flatseal] - инструмент для управления Flatpak-приложениями

### Конфигурация пользовательского окружения
* Установка шорткатов для клавиатуры
  * `Ctrl + Alt + T` - запуск терминала
  * `Ctrl + Alt + B` - запуск браузера
  * `Ctrl + Alt + O` - запуск Obsidian

#### Настройка zsh

Установка Oh My Zsh:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Настройка плагинов и темы **powerlevel10k**:
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Изменить ZSH_THEME="powerlevel10k/powerlevel10k" в ~/.zshrc

Установить плагины на автопредложения и подсветку синтаксиса:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
Добавить плагины в ~/.zshrc:
```bash
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
```
