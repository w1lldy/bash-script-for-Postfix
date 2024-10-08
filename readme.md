# Postfix Management Script

## Описание

Этот скрипт на bash предоставляет меню для управления сервером Postfix. Он позволяет пользователю выполнять основные задачи, такие как просмотр количества писем в очереди, очистка очереди, перезапуск службы Postfix, работа с логами и конфигурациями, а также сохранение и восстановление настроек Postfix.

## Возможности

- *Узнать количество писем в очереди*: отображает текущее количество писем, ожидающих в очереди.
- *Очистить очередь*: позволяет очистить очередь писем (требуется подтверждение действия).
- *Перезапустить Postfix*: позволяет перезапустить службу Postfix (требуется подтверждение действия).
- *Настройки Postfix*:
  - Просмотр настроек, отличающихся от дефолтных.
  - Сохранение текущих настроек в файл.
  - Применение настроек из файла (требуется подтверждение действия).
- *Работа с логами*:
  - Просмотр неудачных попыток авторизации.
  - Поиск логов по email с возможностью сохранения результатов.
  - Изменение пути к лог-файлу.


## Примечания

- Для работы скрипта необходимы права администратора, так как большинство операций требует доступа к системным файлам и службам.
- Скрипт взаимодействует с логами, расположенными в /var/log/maillog. Убедитесь, что у вас есть доступ к этому файлу.


## Запуск

Сделайте скрипт исполняемым и запустите его:

```bash
chmod +x postfix_management.sh
sudo ./postfix_management.sh
```

## Лицензия
 
Скрипт предоставляется "как есть", без каких-либо гарантий. Использование скрипта осуществляется на ваш страх и риск.

p.s. первые шаги в познании скриптов и postfix