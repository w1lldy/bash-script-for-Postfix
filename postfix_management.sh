#!/bin/bash

# Переменные
LOG_FILE="/var/log/maillog"  # Стандартный путь к лог-файлу

# Функция для отображения основного меню
show_menu() {
    clear
    echo "=========================="
    echo " Postfix Management Menu "
    echo "=========================="
    echo "1) Узнать количество писем в очереди"
    echo "2) Очистить очередь"
    echo "3) Перезапустить Postfix"
    echo "4) Настройки Postfix"
    echo "5) Работа с логами"
    echo "6) Выход"
    echo "=========================="
    echo -n "Выберите действие: "
}

# Функция для отображения меню логов
logs_menu() {
    clear
    echo "======================================"
    echo "1) Просмотр неудачных попыток авторизации"
    echo "2) Поиск логов по email"
    echo "3) Изменить путь к лог-файлу (текущий: $LOG_FILE)"
    echo "4) Вернуться в главное меню"
    echo "======================================"
    echo -n "Выберите действие: "
}

# Функция для отображения меню настроек
conf_menu() {
    clear
    echo "======================================"
    echo "1) Показать настройки, отличающиеся от дефолтных"
    echo "2) Сохранить эти настройки (сохраняется в текущую директорию)"
    echo "3) Применить настройки, имеющиеся в текущей директории"
    echo "4) Вернуться в главное меню"
    echo "======================================"
    echo -n "Выберите действие: "
}

# Функция для обработки выбора в основном меню
read_choice() {
    read -n 1 -s choice
    case $choice in
        1)
            show_queue_count
            ;;
        2)
            confirm_action "Вы уверены, что хотите очистить очередь писем? Это действие необратимо." && clear_queue
            ;;
        3)
            confirm_action "Вы уверены, что хотите перезапустить Postfix?" && restart_postfix
            ;;
        4)
            configure_postfix
            ;;
        5)
            logs_management
            ;;
        6)
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный выбор, попробуйте снова."
            ;;
    esac
}

# Функция для обработки выбора в меню настроек
configure_postfix() {
    while true; do
        conf_menu
        read -n 1 -s conf_choice
        case $conf_choice in
            1)
                show_non_default_settings
                ;;
            2)
                save_settings
                ;;
            3)
                confirm_action "Вы уверены, что хотите применить настройки из файла?" && apply_settings
                ;;
            4)
                break
                ;;
            *)
                echo "Неверный выбор, попробуйте снова."
                ;;
        esac
    done
}

# Функция для подтверждения действия
confirm_action() {
    echo "$1 (y/n):"
    read -n 1 -s confirm_choice
    if [[ $confirm_choice == "y" || $confirm_choice == "Y" ]]; then
        return 0
    else
        echo "Действие отменено."
        pause
        return 1
    fi
}

# Функция для отображения количества писем в очереди
show_queue_count() {
    clear
    echo "Количество писем в очереди:"
    mailq | grep -c '^[A-F0-9]'
    pause
}

# Функция для очистки очереди
clear_queue() {
    clear
    echo "Очистка очереди..."
    postsuper -d ALL
    echo "Очередь очищена."
    pause
}

# Функция для перезапуска Postfix
restart_postfix() {
    clear
    echo "Перезапуск Postfix..."
    service postfix restart
    echo "Postfix перезапущен."
    pause
}

# Функция для показа настроек, отличающихся от дефолтных
show_non_default_settings() {
    clear
    echo "Настройки, отличающиеся от дефолтных:"
    postconf -n
    pause
}

# Функция для сохранения настроек в текущую директорию
save_settings() {
    clear
    echo "Сохранение текущих настроек..."
    postconf -n > postfix_settings_backup.txt
    echo "Настройки сохранены в файл postfix_settings_backup.txt"
    pause
}

# Функция для применения настроек из файла в текущей директории
apply_settings() {
    clear
    if [[ -f postfix_settings_backup.txt ]]; then
        echo "Применение настроек из postfix_settings_backup.txt..."
        while IFS= read -r line; do
            postconf -e "$line"
        done < postfix_settings_backup.txt
        echo "Настройки применены."
    else
        echo "Файл postfix_settings_backup.txt не найден."
    fi
    pause
}

# Функция для обработки выбора в меню логов
logs_management() {
    while true; do
        logs_menu
        read -n 1 -s log_choice
        case $log_choice in
            1)
                show_failed_auth_attempts
                ;;
            2)
                search_logs_by_email
                ;;
            3)
                change_log_file_path
                ;;
            4)
                break
                ;;
            *)
                echo "Неверный выбор, попробуйте снова."
                ;;
        esac
    done
}

# Функция для показа неудачных попыток авторизации
show_failed_auth_attempts() {
    clear
    echo "Неудачные попытки авторизации:"
    grep "SASL LOGIN authentication failed" "$LOG_FILE" | awk '{print $1, $2, $3, $7, "пытался авторизоваться, но провалился"}' | sort | uniq
    pause
}

# Функция для поиска по email
search_logs_by_email() {
    clear
    echo -n "Введите адрес или часть адреса для поиска: "
    read email
    echo "Результаты поиска:"
    grep -i "$email" "$LOG_FILE"

    echo -n "Хотите сохранить результаты поиска в файл? (y/n): "
    read -n 1 -s save_choice
    if [[ $save_choice == "y" || $save_choice == "Y" ]]; then
        echo
        echo "Сохранение результатов..."
        grep -i "$email" "$LOG_FILE" > search_results.txt
        echo "Результаты сохранены в файл search_results.txt"
    fi
    pause
}

# Функция для изменения пути к лог-файлу
change_log_file_path() {
    clear
    echo -n "Введите новый путь к лог-файлу (текущий: $LOG_FILE): "
    read new_log_file
    if [[ -f "$new_log_file" ]]; then
        LOG_FILE="$new_log_file"
        echo "Путь к лог-файлу изменен на: $LOG_FILE"
    else
        echo "Ошибка: файл $new_log_file не существует."
    fi
    pause
}

# Функция для паузы и ожидания ввода пользователем
pause() {
    echo "Нажмите любую клавишу для продолжения..."
    read -n 1 -s
}

# Главный цикл меню
while true; do
    show_menu
    read_choice
done
