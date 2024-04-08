Вот переписанный и упорядоченный README.md:

---

# Тестовое задание: Разработка музыкального проекта на Ruby on Rails

## Задача

Спроектировать структуру базы данных и реализовать API для музыкального проекта, который включает артистов, песни и скачивания.

## Запросы

1. Вывести треки исполнителя, отсортированные по названию трека.
  - Метод объекта: `@artist.songs`

2. Вывести треки исполнителя, отсортированные по популярности (количеству скачиваний).
  - Метод объекта: `@artist.songs_top`

3. Вывести популярные треки (по скачиваниям) за день/неделю/месяц.
  - Метод: `Song.top(days, count)`

4. Вывести популярных артистов на букву (например, "A").
  - Метод: `Artist.top(letter, count)`

## Комментарии

- Один артист может иметь множество треков, трек принадлежит только одному артисту, трек можно скачать множество раз.
- Объемы данных и нагрузка: 100 000 артистов, 1 000 000 треков, 500 000 скачиваний в день.
- Отрисовывать выводимые данные не требуется.
- Модели и таблицы:
  - Artist: name (string)
  - Song: title (string)
  - Download: необходимые поля определяются самостоятельно исходя из задачи.

## Решение

### Структура базы данных

```ruby
ActiveRecord::Schema.define(version: 2024_04_06_155540) do
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "downloads", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.integer "count", default: 0, null: false
    t.date "download_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id", "download_date"], name: "index_downloads_on_song_id_and_download_date", unique: true
    t.index ["song_id"], name: "index_downloads_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_songs_on_artist_id"
  end

  add_foreign_key "downloads", "songs"
  add_foreign_key "songs", "artists"
end
```

### Модели

```ruby
class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy
end

class Song < ApplicationRecord
  belongs_to :artist
  has_many :downloads, dependent: :destroy
end

class Download < ApplicationRecord
  belongs_to :song
  validates :song, presence: true
  validates :download_date, uniqueness: { scope: :song_id }

  before_create :set_default_download_date

  private

  def set_default_download_date
    self.download_date ||= Date.today
  end
end
```

### API

API реализован на Ruby on Rails.

- Для запуска API требуется Docker и docker-compose.
- Сборка образов `docker-compose up`.
- Запуск API: `docker-compose up app`.
- Создание базы данных и выполнение миграций: `docker-compose run --rm app bin/rails db:create db:migrate db:seed`.
- Тестирование API с помощью спецификаций: `docker-compose run --rm test`.

### Методы API

#### Получение треков артиста, отсортированных по названию

```ruby
GET /artists/:id/songs_ordered_by_title
```

```bush
curl -X GET http://0.0.0.0:3000/artists/songs_ordered_by_title -d "id=5"
```

#### Получение треков артиста, отсортированных по популярности (количеству скачиваний)

```ruby
GET /artists/:id/songs_ordered_by_downloads_count
```

```bush
curl -X GET http://0.0.0.0:3000/artists/songs_ordered_by_downloads_count -d "id=5"
```

#### Получение популярных треков за указанный период времени

```ruby
GET /songs/top_downloads
```

```bush
curl -X GET http://0.0.0.0:3000/songs/top_downloads -d "period=week&limit=10"
```

#### Получение популярных артистов на определенную букву

```ruby
GET /artists/top_artists_by_letter
```

```bush
curl -X GET http://0.0.0.0:3000/artists/top_artists_by_letter -d "letter=A&limit=5"
```

## Решения при реализации проекта

- Агрегирование загрузок песен по дням, неделям и месяцам для уменьшения нагрузки на базу данных.
- Добавление необходимых индексов для оптимизации связанных запросов.
- Разработка методов API для получения данных в соответствии с требованиями.
