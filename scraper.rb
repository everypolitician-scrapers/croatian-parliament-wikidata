#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en_2016 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2016–',
  after: '//span[@id="MPs_by_party"]',
  xpath: '//table[.//th[.="Name"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

en_2015 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2015–16',
  after: '//span[@id="MPs_by_party"]',
  xpath: '//table[.//th[.="Name"]]//td[position() = last() - 1]//a[not(@class="new")]/@title'
)

en_2011 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_Croatian_Parliament,_2011–15',
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

# Find all P39s of the 9th Sabor
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    VALUES ?membership { wd:Q18643511 }
    VALUES ?term { wd:Q29626082 }

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { hr: [], en: en_2011 | en_2015 | en_2016, sh: sh, sr: sr })
