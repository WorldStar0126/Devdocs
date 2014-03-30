module Docs
  class Cpp < FileScraper
    self.name = 'C++'
    self.slug = 'cpp'
    self.type = 'c'
    self.dir = '/Users/Thibaut/DevDocs/Docs/C/en/cpp'
    self.base_url = 'http://en.cppreference.com/w/cpp/'
    self.root_path = 'header.html'

    html_filters.insert_before 'clean_html', 'c/fix_code'
    html_filters.push 'cpp/entries', 'c/clean_html', 'title'
    text_filters.push 'cpp/fix_urls'

    options[:container] = '#content'
    options[:title] = false
    options[:root_title] = 'C++ Programming Language'
    options[:skip] = %w(
      language/extending_std.html
      language/history.html
      regex/ecmascript.html
      regex/regex_token_iterator/operator_cmp.html
    )
    options[:only_patterns] = [/\.html\z/]

    options[:attribution] = <<-HTML
      &copy; cppreference.com<br>
      Licensed under the Creative Commons Attribution-ShareAlike Unported License v3.0.
    HTML
  end
end
