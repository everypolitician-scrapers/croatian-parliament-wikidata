#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'

def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read) 
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

EveryPolitician::Wikidata.scrape_wikidata(names: { 
  hr: [],
  en: en_wikinames('https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament'),
  sh: sh_wikinames('https://sh.wikipedia.org/wiki/Sedmi_saziv_Hrvatskog_sabora'),
  sr: sr_wikinames('https://sr.wikipedia.org/wiki/Седми_сазив_Хрватског_сабора'),
}, output: false)

warn EveryPolitician::Wikidata.notify_rebuilder

