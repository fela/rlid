== Language Identification ==

Code to build multilingual text corpora, to train and to use various language
identification algorithms is provided.

thesis.pdf contains an overview of the workings of this software, and of the
theory behind it

_NOTE_ that scripts should be run from the lib directory


== Ruby Gem ==
the rubygem can be obtained by executing:

    gem install rlid


and can be used as follows:

    > require 'rlid'
    Naive Bayes: loading models.. Done!
    => true
    > Rlid.guess_language("hello")
    => eng(28) : spa(11) : fin(11)
