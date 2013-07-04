Language Identification
=======================

Code to build multilingual text corpora, to train and to use various language
identification algorithms is provided.

thesis.pdf contains an overview of the workings of this software, and of the
theory behind it

*Note* that scripts should be run from the lib directory


Gem
========
I've created a simple gem that can be used to guess a language using the
Bayesian language guesser, just

    gem install rlid


and can be used as follows:

```ruby
require 'rlid'

res = Rlid.guess_language("hello") #=> eng(28) : spa(11) : fin(11)
res.first           #=> :eng
res[:spa]           #=> 0.10825
res[:dut]           #=> 0.08647
a = res.to_a        #=> [{language: :eng, confidence: 0.28117},
                    #    {langauge: :spa, confidence: 0.10825},
                    #    {language: :eng, confidence: 0.10615},
                    #    ... ]
a[2][:language]     #=> :fin
a[2][:confidence]   #=> 0.10825```



