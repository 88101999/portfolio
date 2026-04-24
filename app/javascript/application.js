// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

document.addEventListener('turbo:load', () => {
  const flashMessages = document.querySelectorAll('.alert');
  flashMessages.forEach((message) => {
    setTimeout(() => {
      message.style.transition = 'opacity 0.5s';
      message.style.opacity = '0';
      setTimeout(() => message.remove(), 500);
    }, 3000); // 3秒後に消える
  });
});