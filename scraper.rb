#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en_2016 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2016%E2%80%93',
  after: '//span[@id="MPs_by_party"]',
  xpath: '//table[.//th[.="Name"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

en_2015 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2015%E2%80%93',
  after: '//span[@id="MPs_by_party"]',
  xpath: '//table[.//th[.="Name"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

en_2011 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2011%E2%80%9315',
  after: '//span[@id="MPs_by_party"]',
  xpath: '//table[.//th[.="Name"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

sh = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://sh.wikipedia.org/wiki/Sedmi_saziv_Hrvatskog_sabora',
  after: '//span[@id="Spisak_poslanika_po_strankama"]',
  xpath: '//table[.//th[.="Poslanik"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

sr = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://sr.wikipedia.org/wiki/Седми_сазив_Хрватског_сабора',
  after: '//span[.="Списак посланика по странкама"]',
  xpath: '//table[.//th[.="Посланик"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

EveryPolitician::Wikidata.scrape_wikidata(names: { hr: [], en: en_2011 | en_2015 | en_2016, sh: sh, sr: sr })
