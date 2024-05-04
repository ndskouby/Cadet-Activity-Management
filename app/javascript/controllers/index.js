// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

async function waitForTuiCalendar() {
  return new Promise((resolve) => {
    const checkTuiCalendar = () => {
      if (window.tui && window.tui.Calendar) {
        resolve(window.tui.Calendar);
      } else {
        window.setTimeout(checkTuiCalendar, 100); // Check again in 100ms
      }
    };
    checkTuiCalendar();
  });
}
function isElementPresent(selector) {
  const element = document.querySelector(selector);
  return element !== null;
}
document.addEventListener('turbo:load', async () => {
  const isCalendarPresent = isElementPresent('#calendar');
  if (isCalendarPresent){
    const Calendar = await waitForTuiCalendar();
    
    function createCalendar(Calendar) {
      const calendar = new Calendar('#calendar', {
        usageStatistics: false,
        defaultView: 'month',
        calendars: [
          {
            id: 'cal1',
            backgroundColor: '#03bd9e',
          },
        ],
      });
    
      calendar.setOptions({
        useDetailPopup: true,
        gridSelection: false,
      });
    
      function getEventColor(activity) {
        switch (activity.status) {
          case 'approved':
            return '#28a745'; // Green
          case 'cancelled':
            return '#dc3545'; // Red
          case 'pending_minor_unit_approval':
          case 'pending_major_unit_approval':
          case 'pending_commandant_approval':
            return '#ffc107'; // Yellow
          case 'revision_required_by_submitter':
          case 'revision_required_by_minor_unit':
          case 'revision_required_by_major_unit':
            return '#e08e0b'; // Orange
          default:
            return '#ccc';
        }
      }
    
      function createCalendarEvents(activities) {
        return activities.map((activity) => {
          const activityDate = new Date(activity.date);
          activityDate.setHours(activityDate.getHours()+6);
          const startDate = activityDate;
          const endDate = activityDate; // Assuming events are not all-day
          return {
            id: activity.id,
            calendarId: 'cal1',
            title: activity.name,
            start: startDate.toISOString(),
            end: endDate.toISOString(),
            location: activity.location,
            body: `Status: ${activity.status}`,
            attendees: [allUnits.find((u) => u.id === activity.unit_id)],
            isReadOnly: true,
            isAllDay: false,
            backgroundColor: getEventColor(activity),
          };
        });
      }
    
      const trainingActivities = window.trainingActivities || [];
      const allUnits = window.units || [];
    
      console.log(trainingActivities, allUnits)
    
      const calendarEvents = createCalendarEvents(trainingActivities);
    
      function getAllChildUnits(unit, allUnits) {
        const childUnits = allUnits.filter((u) => u.parent_id === unit.id);
        return [unit, ...childUnits.flatMap((u) => getAllChildUnits(u, allUnits))];
      }

      function filterEventsByUnit(unit) {
        const currUnit = allUnits.find((u) => u.id === unit.id);
        const currUnitTree = getAllChildUnits(currUnit, allUnits)
        return calendarEvents.filter((event) => {
          const activity = trainingActivities.find((a) => a.id === event.id);
          if (activity) {
            return currUnitTree.some((u) => u.id === activity.unit_id);
          }
          return false;
        });
      }
    
      function handleUnitButtonClick(unit) {
        const filteredEvents = filterEventsByUnit(unit);
        calendar.clear();
        calendar.createEvents(filteredEvents);
      }
    
      const unitButtonsContainer = document.getElementById('unitButtonsContainer');
      if (unitButtonsContainer && allUnits.length) {
        const buttonGroup = document.createElement('div');
        buttonGroup.classList.add('btn-group');

        const filterLabel = document.createElement('span');
        filterLabel.classList.add('me-2');
        filterLabel.textContent = 'Unit Filters:';
        unitButtonsContainer.appendChild(filterLabel);

        allUnits.forEach((unit) => {
          const button = document.createElement('button');
          button.classList.add('btn', 'btn-outline-primary', 'btn-sm');
          button.textContent = unit.name;
          button.addEventListener('click', () => handleUnitButtonClick(unit));
          buttonGroup.appendChild(button);
        });

        unitButtonsContainer.appendChild(buttonGroup);
      }
    
      calendar.createEvents(calendarEvents);
    
      const updateDateRange = () => {
        document.getElementById('dateRange').textContent = `${calendar
          .getDateRangeStart()
          .toDate()
          .toDateString()}-${calendar.getDateRangeEnd().toDate().toDateString()}`;
      };
    
      updateDateRange();

      document.getElementById('viewWeekBtn').addEventListener('click', () => {calendar.changeView('week');updateDateRange();});
      document.getElementById('viewMonthBtn').addEventListener('click', () => {calendar.changeView('month');updateDateRange();});
      document.getElementById('nextBtn').addEventListener('click', () => {calendar.next();updateDateRange();});
      document.getElementById('prevBtn').addEventListener('click', () => {calendar.prev();updateDateRange();});
      document.getElementById('todayBtn').addEventListener('click', () => {calendar.today();updateDateRange();});
      
    }
    createCalendar(Calendar)
  }
  }
);