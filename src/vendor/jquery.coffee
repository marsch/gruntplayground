'use strict'

require '../../vendor/js/jquery/jquery'

# Ensure we're working with an unmodified version of jQuery.
jQuery = window.jQuery.noConflict()

# Require any jQuery extensions here; attaching as neccessary.
# Example:
#   require 'bootstrap'

#require './vendor/jquery-ui-dropdrag.js'

#require '../components/js/bootstrap/bootstrap-dropdown.js'
#require '../components/js/bootstrap/bootstrap-modal.js'
#require '../components/js/bootstrap/bootstrap-button.js'
#require '../components/js/bootstrap/bootstrap-alert.js'


#require '../components/js/mockjax/index.js'


# Export the jQuery library.
module.exports = jQuery
