# jQuery Modal

Modal is a jQuery plugin for showing overlapping dialogue prompts.

## Installation

To install copy the *javascripts* and *stylesheets* directories into your project and add the following snippet to the header:

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js" type="text/javascript"></script>
    <script src="javascripts/jquery.modal.js" type="text/javascript"></script>
    <link href="stylesheets/jquery.modal.css" rel="stylesheet" type="text/css" />

This plugin is also registered under http://bower.io/ to simplify integration. Try:

    npm install -g bower
    bower install modal

## Examples

Setting up a modal is easy. The following snippet is a good start:

    <div class="modal fade">
      <div class="header">...</div>
      <div class="content">...</div>
      <div class="footer">...</div>
    </div>
    <script>
      $('.modal').modal()
    </script>

## Status

[![Status](https://travis-ci.org/ksylvest/jquery-modal.png)](https://travis-ci.org/ksylvest/jquery-modal)

## Copyright

Copyright (c) 2010 - 2013 Kevin Sylvestre. See LICENSE for details.
