# Тестовое задание

  > Задача 2 (Rails): Задание: спроектировать таблицы для муз проекта (артист-песни-скачивания) под следующие запросы:
  >> вывод треков исполнителя, отсортированных по названию трека / вызовом метода объекта @artist.songs 
  > 
  >> вывод треков исполнителя, отсортированных по популярности (скачиваниям) /
  > 
  >> вызовом метода объекта @artist.songs_top - популярные треки (по скачиваниям) за день/нед/месяц / 
  > 
  >> метод Song.top(days, count) - популярные артисты на букву (напр "A") / метод Artist.top(letter, count)
  > 
  >> Комментарии: 
  >> * один артист имеет множество треков; трек принадлежит только одному артисту; трек можно скачать множество раз
  >> * надо создать миграции (с необходимыми индексами), модели со взаимосвязями и методами для получения описанной выборки данных
  >> * порядок объемов данных и нагрузки: 100тыс артистов, 1млн треков, 500тыс скачиваний в день * отрисовывать выводимые данные не нужно
  >> * Модели/таблицы: * Artist - name (string) * Song - title (string) * Download - необходимые поля определить самостоятельно исходя из задачи
  >> * Поля таблиц можно дополнять на свое усмотрение. В качестве решения задачи необходимо выслать файл schema.rb и файлы созданных моделей.

# Решение
  Решение организованно в виде рельсовго апи.

* Клонировать репозиторий.
  ```.bush
    git clone git@github.com:leva84/songs.git
  ```

* Перейти в директорию проекта.
  ```.bush
    cd songs
  ```

* Установить необходимые образы.
  ```.bush
    docker-compose up
  ```

* Прогнать миграции и создать данные в БД.
  ```.bush
    docker-compose run --rm app bin/rails db:create db:migrate db:seed
  ```

* Запустить API.
  ```.bush
    docker-compose up app
  ```

* Протестировать работу эндпоинтов с помощью `curl`, например:
  ```.bush
  GET /artists/top_artists_by_letter
  Этот эндпоинт возвращает список популярных артистов на основе первой буквы их имени.
  curl -X GET http://0.0.0.0:3000/artists/top_artists_by_letter -d "letter=A&count=5"

  GET /artists/songs_ordered_by_title
  Этот эндпоинт возвращает список песен конкретного артиста, отсортированный по названию.
  curl -X GET http://0.0.0.0:3000/artists/songs_ordered_by_title -d "id=5"

  GET /artists/:id/songs_ordered_by_downloads_count
  Этот эндпоинт возвращает список песен конкретного артиста, отсортированный по количеству загрузок.
  curl -X GET http://0.0.0.0:3000/artists/songs_ordered_by_downloads_count -d "id=5"

  GET /songs/top_downloads
  Этот эндпоинт возвращает список песен с наибольшим числом загрузок за указанный период времени.
  curl -X GET http://0.0.0.0:3000/songs/top_downloads -d "period=week&limit=10"
  ```

* Протестировать работу API с помощью спецификаций.
  ```.bush
    docker-compose run --rm test
  ```
