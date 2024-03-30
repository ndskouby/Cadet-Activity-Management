// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

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

document.addEventListener('DOMContentLoaded', async () => {
  const Calendar = await waitForTuiCalendar();

  function createCalendar(Calendar){
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
      // useFormPopup: true,
      useDetailPopup: true,
      gridSelection: false,
    });

    const trainingActivities = window.trainingActivities || [];

    const allUnits = trainingActivities.reduce((acc, activity) => {
      const userUnit = activity.user?.unit;
      if (userUnit) {
        acc.push(userUnit);
        acc.push(...userUnit.children); // Add children recursively
      }
      return acc;
    }, []);

    const calendarEvents = trainingActivities.map(activity => {
      const startDate = new Date(activity.date);
      const endDate = new Date(activity.date); // Assuming events are not all-day
      // Set backgroundColor based on training activity status
      let backgroundColor;
      switch (activity.status) {
        case 'approved':
          backgroundColor = '#28a745'; // Green for approved
          break;
        case 'cancelled':
          backgroundColor = '#dc3545'; // Red for cancelled
          break;
        case 'pending_minor_unit_approval':
        case 'pending_major_unit_approval':
        case 'pending_commandant_approval':
          backgroundColor = '#ffc107'; // Yellow for pending approval
          break;
        case 'revision_required_by_submitter':
        case 'revision_required_by_minor_unit':
        case 'revision_required_by_major_unit':
          backgroundColor = '#e08e0b'; // Orange for revision required
          break;
        default:
          backgroundColor = '#ccc'; // Default color for other statuses
      }
    
      return {
        id: activity.id,
        calendarId: 'cal1',
        title: activity.name,
        start: startDate.toISOString(),
        end: endDate.toISOString(),
        location: activity.location,
        body: 'Status:' + activity.status,
        attendees: [activity.user?.unit],
        isReadOnly: true,
        isAllDay: false,
        backgroundColor, // Set backgroundColor based on status
      };
    });

    let filteredEvents = calendarEvents;
    // Unit selection buttons and filtering logic
    const unitButtonsContainer = document.getElementById('unitButtonsContainer'); // Assuming an existing container element
    allUnits.forEach(unit => {
      unitButtonsContainer.textContent = 'Unit Filters:';
      const button = document.createElement('button');
      button.textContent = unit.name;
      button.addEventListener('click', () => {
        filteredEvents = trainingActivities.map(activity => ({
          // ... rest of event object creation logic
        })).filter(event => {
          const activity = trainingActivities.find(a => a.id === event.id);
          if (activity) {
            const userUnit = activity.user?.unit;
            return userUnit && (userUnit.id === unit.id || unit.children.some(child => child.id === userUnit.id));
          }
          return false;
        });
        calendar.clear(); // Clear existing events
        calendar.createEvents(filteredEvents); // Create events based on filtered data
      });
      unitButtonsContainer.appendChild(button);
    });

    calendar.createEvents(calendarEvents);
    document.getElementById('viewWeekBtn').addEventListener('click', () => {calendar.changeView('week');updateDateRange();});
    document.getElementById('viewMonthBtn').addEventListener('click', () => {calendar.changeView('month');updateDateRange();});
    document.getElementById('nextBtn').addEventListener('click', () => {calendar.next();updateDateRange();});
    document.getElementById('prevBtn').addEventListener('click', () => {calendar.prev();updateDateRange();});
    document.getElementById('todayBtn').addEventListener('click', () => {calendar.today();updateDateRange();});
    function updateDateRange() {
      document.getElementById('dateRange').textContent = calendar.getDateRangeStart().toDate().toDateString()+ '-' +calendar.getDateRangeEnd().toDate().toDateString();
    }
    
    updateDateRange()
    // getViewName()
  }

  createCalendar(Calendar)
  
  }
);