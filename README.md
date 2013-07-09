Language Identification
=======================

This repository contains code to build multilingual text corpora, and to train
and to use various language identification algorithms. [thesis.pdf](/thesis.pdf)
describes the software in more detail. An online demo is available 
[here](http://fela.heroku.com/rlid).



Gem
===
I've created a gem that can be used to guess a language using the
Bayesian language guesser, just

    gem install rlid

and then use in the following way

```ruby
require 'rlid'

res = Rlid.guess_language('hello') #=> eng(28) : spa(11) : fin(11)
res.first           #=> :eng
res[:spa]           #=> 0.10825
res[:dut]           #=> 0.08647
a = res.to_a        #=> [{language: :eng, confidence: 0.28117},
                    #    {langauge: :spa, confidence: 0.10825},
                    #    {language: :eng, confidence: 0.10615},
                    #    ... ]
a[2][:language]     #=> :fin
a[2][:confidence]   #=> 0.10825
```

Limitations
===========
The current version is a proof of concept and recognises only 22
languages. Furthermore, the confidence values make sense as probabilities 
only under the assumption that the text is valid text in one of the recognised
languages.
