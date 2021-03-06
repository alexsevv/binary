if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Подключаем нужные библиотеки
require 'net/http'
require 'rexml/document'

URL = 'http://www.cbr.ru/scripts/XML_daily.asp'.freeze
# Достаем данные с сайта Центробанка и записываем их в XML
response = Net::HTTP.get_response(URI.parse(URL))
doc = REXML::Document.new(response.body)

# Для того, чтобы найти курс валюты, необходимо знать её ID в XML-файле
# R01235 — Доллар США

# Найдём в документе соответствующий элемент
value = ''
doc.each_element('//Valute[@ID="R01235"]') do |currency_tag|
  # Достаём курс доллара
  value = currency_tag.get_text('Value')
end
value = value.to_s.sub(',', '.').to_f
puts "Сколько у вас рублей?"
ruble = gets.to_f

puts "Сколько у вас долларов?"
dollar = gets.to_f

dollars = (dollar * value)
puts difference = (((dollars + ruble) / 2 - ruble) / value).round(2)

if difference.abs < 1
  puts "Все на месте, Спи спокойно! Яйца в разниц корзинах - поровну!"
elsif ruble > dollars
  puts "Вам нужно купить долларов: #{difference.abs} $."
else
  puts "Вам нужно продать долларов: #{difference.abs} $."
end
