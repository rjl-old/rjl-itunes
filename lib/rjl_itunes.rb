# coding: utf-8

#--
# rjl_itunes.rb
#
# Created by Richard Lyon on 2005-04-26.
# Copyright 2005 Richard Lyon. All rights reserved.
#
# See Rjl_itunes for documentation.
#
# This is Free Software.  See LICENSE and COPYING for details.

require "rjl_itunes/rjl_itunes"
require "rjl_itunes/version"

class Itunes

  ITUNES_PATH = '/Users/richlyon/Music/iTunes/iTunes Music Library.xml'

  attr_reader :itunes_path

  def initialize( itunes_path = ITUNES_PATH )
    @itunes_path = itunes_path
  end
end
