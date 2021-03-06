#--
# =============================================================================== 
# Copyright (c) 2005,2006,2007,2008 Christopher Kleckner
# All rights reserved
#
# This file is part of the Rio library for ruby.
#
# Rio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Rio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rio; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# =============================================================================== 
#++
#
# To create the documentation for Rio run the command
#  ruby build_doc.rb
# from the distribution directory.
#
# Suggested Reading
# * RIO::Doc::SYNOPSIS
# * RIO::Doc::INTRO
# * RIO::Doc::HOWTO
# * RIO::Doc::EXAMPLES
# * RIO::Rio
#


module RIO
  module HTTP #:nodoc: all
    RESET_STATE = 'HTTP::Stream::Open'
    
    require 'rio/rl/uri'
    class RL < RIO::RL::URIBase
      def self.splitrl(s) 
        sub,opq,whole = split_riorl(s)
        [whole] 
      end
      require 'open-uri'
      def open(*args)
        IOH::Stream.new(self.uri.open)
      end
    end

    module Stream

      require 'rio/stream/open'
      require 'rio/ops/path'
      class Open < RIO::Stream::Open
        include Ops::Path::Status
        include Ops::Path::URI
        include Ops::Path::Query
        def input() 
          self.rl.base = self.ioh.base_uri
          stream_state('HTTP::Stream::Input') 
        end
      end

      require 'rio/stream'
      class Input < RIO::Stream::Input
        include Ops::Path::Status
        include Ops::Path::URI
        include Ops::Path::Query
        extend Forwardable
        def_instance_delegators(:ioh,:meta,:status,:charset,:content_encoding,:content_type,:last_modified,:base_uri)
      end

    end
  end 
end # module RIO
