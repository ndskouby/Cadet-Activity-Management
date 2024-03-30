// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "datatables";
import "@hotwired/turbo-rails";

console.log("JavaScript is loaded and executed.");

document.addEventListener("turbo:load", () => {
  console.log("Loaded Flash Message");
  setTimeout(() => {
    document.querySelectorAll(".flash").forEach((flash) => flash.remove());
  }, 4000);
});

document.addEventListener("turbo:load", function () {
  // Query all elements with the dropdown-toggle class and re-initialize them
  var dropdowns = document.querySelectorAll(".dropdown-toggle");
  dropdowns.forEach(function (dropdown) {
    new mdb.Dropdown(dropdown); // Initialize each dropdown
  });
});

document.addEventListener("turbo:load", function () {
  var addButton = $("#addTrainingActivityButton").detach();
  $("#trainingActivitiesTable").DataTable({
    columnDefs: [
      { type: "string", targets: 0 },
      { type: "date", targets: 1 },
      { type: "string", targets: 2 },
      { type: "string", targets: 3 },
      { type: "string", targets: 4 },
      { type: "string", targets: 5 },
      { type: "string", targets: 6 },
      { type: "string", targets: 7 },
    ],
    search: {
      caseInsensitive: true,
    },
    autoWidth: false,
  });
  $(".dt-search").append(addButton);
});

document.addEventListener("turbo:load", function () {
  console.log("Loaded Modal");
  var myModal = new mdb.Modal(
    document.getElementById("addTrainingActivityModal")
  );
  document
    .getElementById("addTrainingActivityButton")
    .addEventListener("click", function () {
      myModal.show();
    });
});
