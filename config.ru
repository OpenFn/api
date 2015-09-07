# vi: set ft=ruby: set syntax=ruby
require 'rubygems'
require 'bundler'

Bundler.require

require "./lib/environment"
require "app"

run App.freeze.app
