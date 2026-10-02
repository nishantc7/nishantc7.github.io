require 'yaml'
require 'date'
require 'uri'

def add_reading(path:, title: '', url:, source: '', note: '', discussion: '', date: '')
  title, url, source, note, discussion, date = [title, url, source, note, discussion, date].map { |v| v.to_s.strip }
  raise 'Title must be 300 characters or fewer.' if title.length > 300
  validate_url = lambda do |value|
    uri = URI.parse(value)
    raise 'Use a complete HTTPS URL without credentials.' unless uri.is_a?(URI::HTTPS) && uri.host && !uri.host.empty? && !uri.userinfo
    uri
  end
  validate_url.call(url)
  unless discussion.empty?
    hn = validate_url.call(discussion)
    raise 'Discussion must be a Hacker News item URL.' unless hn.host == 'news.ycombinator.com' && hn.path == '/item' && URI.decode_www_form(hn.query.to_s).any? { |k, v| k == 'id' && v.match?(/\A\d+\z/) }
  end
  date = Time.now.getlocal('+05:30').strftime('%Y-%m-%d') if date.empty?
  raise 'Date must use YYYY-MM-DD.' unless date.match?(/\A\d{4}-\d{2}-\d{2}\z/) && Date.iso8601(date).strftime('%Y-%m-%d') == date
  raise 'Note must be 4000 characters or fewer.' if note.length > 4000
  entries = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false) || []
  raise 'Reading data must be a list.' unless entries.is_a?(Array)
  entry = {'url' => url, 'date' => date}
  entry['title'] = title unless title.empty?
  entry['source'] = source unless source.empty?
  entry['note'] = note unless note.empty?
  entry['discussion'] = discussion unless discussion.empty?
  # Submitting an existing URL updates that entry instead of duplicating it.
  entries.reject! { |e| e['url'] == url }
  entries.unshift(entry)
  File.write(path, YAML.dump(entries))
  entry
end

if $PROGRAM_NAME == __FILE__
  add_reading(path: '_data/reading.yml', title: ENV['ARTICLE_TITLE'], url: ENV['ARTICLE_URL'], source: ENV['ARTICLE_SOURCE'], note: ENV['ARTICLE_NOTE'], discussion: ENV['ARTICLE_DISCUSSION'], date: ENV['ARTICLE_DATE'])
  puts 'Reading link saved.'
end
