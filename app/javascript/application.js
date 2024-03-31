// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "/assets/jquery/dist/jquery.min.js"
import "/assets/mdb-ui-kit/js/mdb.umd.min.js"
import "/assets/datatables.net/js/dataTables.js"
import "/assets/datatables.net-dt/js/dataTables.dataTables.min.js"
import "/assets/fontawesome-free/js/all.min.js"
import "controllers"
import "chartkick"
import "Chart.bundle"

console.log("JavaScript is loaded and executed.");


document.addEventListener("turbo:load", () => {
  console.log("Loaded Flash Message");
  setTimeout(() => {
    document.querySelectorAll(".flash").forEach((flash) => flash.remove());
  }, 4000);
});

/*
 * TRAINING ACTIVITY PAGE
 */
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
  const modalElement = document.getElementById("addTrainingActivityModal");
  if (modalElement) {
    console.log("Initializing Modal");
    const myModal = new mdb.Modal(modalElement);
  }
});

document.addEventListener("turbo:load", function () {
  if (document.getElementById("addTrainingActivityButton") == null) return;
  var myModal = new mdb.Modal(
    document.getElementById("addTrainingActivityModal")
  );
  document
    .getElementById("addTrainingActivityButton")
    .addEventListener("click", function () {
      myModal.show();
    });
});

document.addEventListener("turbo:load", function () {
  const formOutlines = document.querySelectorAll(".form-outline");
  formOutlines.forEach((formOutline) => {
    new mdb.Input(formOutline).init();
  });
});

/*
 * AUDIT ACTIVITY PAGE
 */
document.addEventListener("turbo:load", () => {
  const rejectModalButton = document.getElementById("rejectModalButton");
  if (rejectModalButton) {
    rejectModalButton.addEventListener("click", (event) => {
      event.preventDefault();
      const modal = new mdb.Modal(
        document.querySelector(
          rejectModalButton.getAttribute("data-mdb-target")
        )
      );
      modal.show();
    });
  }
});
document.addEventListener("turbo:load", () => {
  const requestModalButton = document.getElementById("requestModalButton");
  if (requestModalButton) {
    requestModalButton.addEventListener("click", (event) => {
      event.preventDefault();
      const modal = new mdb.Modal(
        document.querySelector(
          requestModalButton.getAttribute("data-mdb-target")
        )
      );
      modal.show();
    });
  }
});
document.addEventListener("turbo:load", () => {
  const resubmitModalButton = document.getElementById("resubmitModalButton");
  if (resubmitModalButton) {
    resubmitModalButton.addEventListener("click", (event) => {
      event.preventDefault();
      const modal = new mdb.Modal(
        document.querySelector(
          resubmitModalButton.getAttribute("data-mdb-target")
        )
      );
      modal.show();
    });
  }
});
document.addEventListener("turbo:load", () => {
  const cancelModalButton = document.getElementById("cancelModalButton");
  if (cancelModalButton) {
    cancelModalButton.addEventListener("click", (event) => {
      event.preventDefault();
      const modal = new mdb.Modal(
        document.querySelector(
          cancelModalButton.getAttribute("data-mdb-target")
        )
      );
      modal.show();
    });
  }
});
