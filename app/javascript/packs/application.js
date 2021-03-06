// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("chartkick/chart.js")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { toggleCircleTabs } from '../custom/toggle-circle-tabs';
import { positionOrgChart } from '../custom/position-org-chart';
import { showHideRoles } from '../custom/show-hide-roles';
import { resetSearch } from '../custom/reset-search';
import { colorOrgChart } from '../custom/color-org-chart';
import { sizeOrgChart } from '../custom/size-org-chart';
import { highlightNavbarTabs } from '../custom/highlight-navbar-tabs';
import { adjustRoleFormInput } from '../custom/adjust-form-input';
import { togglePassword } from '../custom/toggle-password';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  toggleCircleTabs();
  sizeOrgChart();
  positionOrgChart();
  colorOrgChart();
  showHideRoles();
  resetSearch();
  highlightNavbarTabs();
  adjustRoleFormInput();
  togglePassword();
});
