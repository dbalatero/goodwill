#!/usr/bin/env ruby

require 'time'
require 'rubygems'
require 'bundler'
require 'cgi'
require 'open-uri'

Bundler.require

terms = %w[
  reverb
  tremolo
  precision\ bass
  preamp
  roland
  moog
  dave\ smith
  akai
  kurzweil
  oberheim
  analog
  drum\ machine
  yamaha
]

def fetch_page(search)
  url = "http://www.shopgoodwill.com/search/SearchKey.asp?"\
    "itemtitle=#{CGI.escape(search)}&showthumbs=on&sortBy=itemEndTime"\
    "&sortOrder=a&closed=&sellerid=all&srchdesc=&month=&day=&year=&days=0"

  Nokogiri::HTML(open(url).read)
end

def extract_links(page)
  page.css('th[scope="row"] a').map do |link|
    ends_at = link.parent.parent.css('th').last.text

    {
      name: link.text,
      url: link.attributes['href'],
      ends_at: ends_at
    }
  end
end

terms.each do |term|
  puts "==> Searching for #{term}".green

  extract_links(fetch_page(term)).each do |link|
    print "- "
    puts "#{link[:name]}".light_yellow
    puts "  #{link[:url]}".light_blue
    puts "  #{link[:ends_at]}".light_blue
  end

  puts "[press any key to continue]".green
  gets
  puts
  puts
end
