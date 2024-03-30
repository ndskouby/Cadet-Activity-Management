# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap
pin "application", to: "application.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from "app/javascript/controllers", under: "controllers"
pin "mdb", to: "/vendor/mdb5-free-standard/js/mdb.umd.min.js", preload: true
pin "datatables", to: "/vendor/javascript/datatables/datatables.js"