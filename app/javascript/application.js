// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "diagnoses"
window.bootstrap = bootstrap

console.log('application.js が読み込まれました');   