require 'rubygems'
require 'bundler'

ENV['ENV'] ||= "development"
Bundler.require(:default, :test)

$:.unshift File.dirname(__FILE__)
