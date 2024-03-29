// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("JavaScript is loaded and executed.");

document.addEventListener("turbo:load", () => {
  setTimeout(() => {
    document.querySelectorAll(".flash").forEach((flash) => flash.remove());
  }, 4000);
});
