#
# Cookbook Name:: helpers_express42
# Library:: mail
#
# Copyright 2014, LLC Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

module Express42
  # Chef Error Handler, use gem pony to send report by email
  class MailHandler < Chef::Handler
    def initialize(from_address, to_address)
      @from_address = from_address
      @to_address   = to_address
    end

    def report
      require 'pony'
      # The Node is available as +node+
      subject = "Chef run failed on #{node.name}"
      # +run_status+ is a value object with all of the run status data
      message = "#{run_status.formatted_exception}\n"
      # Join the backtrace lines. Coerce to an array just in case.
      message << Array(backtrace).join("\n")

      Pony.mail(
        to:      @to_address,
        from:    @from_address,
        subject: subject,
        body:    message)
    end
  end
end
