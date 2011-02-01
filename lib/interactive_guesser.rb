#!/usr/bin/env ruby

$: << File.dirname( __FILE__)

require 'rlid'


loop do
  print "> "
  puts Rlid.guess_language(gets).to_s
end

