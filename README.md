	Copyright 2010 Fela Winkelmolen <fela.kde@gmail.com>
		
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 3 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA


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