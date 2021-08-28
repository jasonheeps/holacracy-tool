const adjustRoleFormInput = () => {
const newRoleForm = document.querySelector('#new_role');
if (!newRoleForm) { return; }

  const restrictingRoleTypes = ['cl'];
  const roleTypeInput = document.querySelector('#role_role_type');
  const secondaryCircleInput = document.querySelector('#role_secondary_circle_id');
  const titleInput = document.querySelector('#role_title');
  const acronymInput = document.querySelector('#role_acronym');
  
  roleTypeInput.addEventListener('input', (event) => {
    if (restrictingRoleTypes.includes(roleTypeInput.value)) {
      secondaryCircleInput.readOnly = false;
      titleInput.readOnly = true;
//      acronymInput.readOnly = true;
      titleInput.value = 'Bitte Sekundärkreis auswählen';
    } else {
      secondaryCircleInput.value = null;
      secondaryCircleInput.readOnly = true;     
      titleInput.readOnly = false;
//      acronymInput.readOnly = false;
      titleInput.value = '';
    }
  });

  secondaryCircleInput.addEventListener('input', (event) => {
    if (restrictingRoleTypes.includes(roleTypeInput.value)) {
      const roleType = roleTypeInput.options[roleTypeInput.selectedIndex].text;
      const secondaryCircle = secondaryCircleInput.options[secondaryCircleInput.selectedIndex].text;
      titleInput.value = `${roleType} ${secondaryCircle}`;
      // TODO: insert matching role acronym like 'CL KMS' (how to access db from here?)
    }
  });
};

export { adjustRoleFormInput };

