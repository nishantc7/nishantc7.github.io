require 'tmpdir'
require_relative 'add_reading'
Dir.mktmpdir do |dir|
  path = File.join(dir, 'reading.yml')
  File.write(path, "[]\n")
  add = ->(**args) { add_reading(path: path, title: 'An article', url: 'https://example.com/article', **args) }
  entry = add.call(note: "A note with: punctuation\nand a second line.")
  raise unless !entry.key?('source') && entry['date'] == Time.now.getlocal('+05:30').strftime('%Y-%m-%d')
  add.call(title: 'Updated title', date: '2026-10-02', discussion: 'https://news.ycombinator.com/item?id=123')
  entries = YAML.safe_load(File.read(path))
  raise unless entries.size == 1 && entries[0]['title'] == 'Updated title' && !entries[0].key?('note')
  bare = add_reading(path: path, url: 'https://example.com/bare')
  raise unless bare.keys.sort == ['date', 'url']
  blank = add.call(title: '  ', source: ' ', note: '', discussion: '')
  raise unless blank.keys.sort == ['date', 'url']
  explicit = add.call(source: 'Example publication')
  raise unless explicit['source'] == 'Example publication'
  [{url: 'javascript:alert(1)'}, {url: 'https://user:password@example.com'}, {date: '2026-02-30'}, {discussion: 'https://example.com/item?id=1'}, {title: 'x' * 301}].each do |args|
    before = File.read(path)
    rejected = false
    begin
      add.call(**args)
    rescue ArgumentError, RuntimeError, URI::InvalidURIError
      rejected = true
    end
    raise "Invalid input accepted: #{args}" unless rejected && File.read(path) == before
  end
end
puts 'Reading submission tests passed.'
