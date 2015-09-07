# vi: set ft=ruby: set syntax=ruby
require 'rubygems'
require 'bundler'

Bundler.require

require "./hello_world"

run App.freeze.app
