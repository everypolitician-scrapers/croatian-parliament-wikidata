#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'set'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'


def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def en_wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[3][.="Constituency"]]//tr[td]').map { |tr|
    tds = tr.css('td')
    tds[-2].xpath('.//a[not(@class="new")]/@title')
  }.reject(&:empty?).map(&:text)
end

def sh_wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[3][.="Napomena"]]//tr[td]').map { |tr|
    tds = tr.css('td')
    tds[-2].xpath('.//a[not(@class="new")]/@title')
  }.reject(&:empty?).map(&:text)
end

def sr_wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[3][.="Напомена"]]//tr[td]').map { |tr|
    tds = tr.css('td')
    tds[-2].xpath('.//a[not(@class="new")]/@title')
  }.reject(&:empty?).map(&:text)
end


enids = WikiData.ids_from_pages('en', en_wikinames('https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament')).map(&:last) 
shids = WikiData.ids_from_pages('sh', sh_wikinames('https://sh.wikipedia.org/wiki/Sedmi_saziv_Hrvatskog_sabora')).map(&:last)
srids = WikiData.ids_from_pages('sr', sr_wikinames('https://sr.wikipedia.org/wiki/%D0%A1%D0%B5%D0%B4%D0%BC%D0%B8_%D1%81%D0%B0%D0%B7%D0%B8%D0%B2_%D0%A5%D1%80%D0%B2%D0%B0%D1%82%D1%81%D0%BA%D0%BE%D0%B3_%D1%81%D0%B0%D0%B1%D0%BE%D1%80%D0%B0')).map(&:last)

ids = (enids + shids + srids).uniq

ids.each do |id|
  data = WikiData::Fetcher.new(id: id).data rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  ScraperWiki.save_sqlite([:id], data)
end
