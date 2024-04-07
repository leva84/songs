# frozen_string_literal: true

# Создание артистов
100.times do
  Artist.create(name: Faker::Music.band)
end

# Создание треков
Artist.find_each do |artist|
  rand(1..10).times do
    artist.songs.create(title: Faker::Music.album)
  end
end

# Создание скачиваний
Song.find_each do |song|
  rand(1..10).times do
    song.downloads.create(download_date: Faker::Date.backward(days: 30))
  end
end
