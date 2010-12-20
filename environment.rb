require 'rubygems'
require 'bundler'

Bundler.require

require 'logger'

CFG = YAML.load(File.read('config.yml'))