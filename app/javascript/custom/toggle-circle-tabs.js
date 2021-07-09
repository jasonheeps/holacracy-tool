const activeTabClass = 'active-tab';
const visibleSectionClass = 'visible';
const invisibleSectionClass = 'invisible';

const toggleCircleTabs = () => {
  const tabs = document.querySelectorAll('.tab');
  if (tabs) {
    tabs.forEach(tab => {
      tab.addEventListener('click', (event) => {
        // prevent the page from reload
        event.preventDefault();

        // select the tabs
        const tabActiveBefore = document.querySelector(`.${activeTabClass}`);
        const tabActiveNow = event.target;

        // do nothing if the active tab is clicked
        if (tabActiveNow === tabActiveBefore) {
          return;
        }

        // transfer active class from one tab to another
        tabActiveBefore.classList.remove(activeTabClass);
        tabActiveNow.classList.add(activeTabClass);

        // read the data-set id from both the old and new active tab
        const idBefore = tabActiveBefore.dataset.id
        const idNow = tabActiveNow.dataset.id

        // select both sections accordingly (by their id)
        const sectionActiveBefore = document.getElementById(idBefore);
        const sectionActiveNow = document.getElementById(idNow);

        // toggle their visibility class
        toggleVisibility(sectionActiveBefore);
        toggleVisibility(sectionActiveNow);
      });
    });
  }
};

const toggleVisibility = (domElement) => {
  // only do this if the domElement exists
  if (domElement) {
    domElement.classList.toggle(invisibleSectionClass);
  }
};

export { toggleCircleTabs };

