# Переназначение клавиши для Copilot в Linux
Наиболее безопасный и легкий способ - использовать утилиту [keyd](https://github.com/rvaiya/keyd).

## Установка и конфигурация keyd
Для некоторых дистрибутивов (например, Arch) существуют поддерживаемые пакеты в репозиториях, но самый надёжный способ - собрать из исходников.

```bash
git clone https://github.com/rvaiya/keyd.git
cd keyd
make && sudo make install
sudo systemctl enable keyd --now
```

После установки и запуска keyd нужно создать файл конфигурации в `/etc/keyd/default.conf`:

```conf
[ids]

*

[main]
f23+leftshift+leftmeta = rightcontrol
```

В большинстве случаев, клавиша Copilot на аппаратном уровне посылает сигнал о нажатии трёх клавиш: F23, Shift и Meta, поэтому в keyd для её переназначения указывается эта комбинация.

## Решение проблемы с автоотключением тачпада
После запуска keyd часто перестает работать функция GNOME - Disable Touchpad While Typing.
Это решается добавлением ovverride-конфигурации libinput:
```
[keyd virtual keyboards]

MatchUdevType=keyboard
MatchName=keyd*keyboard
AttrKeyboardIntegration=internal
```
