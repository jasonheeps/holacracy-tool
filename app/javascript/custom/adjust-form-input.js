const newRoleForm = document.querySelector('#new_role');

const adjustRoleFormInput = () => {
  if (!newRoleForm) { return; }

  const restrictingRoleTypes = ['cl'];
  const roleTypeInput = document.querySelector('#role_role_type');
  const secondaryCircleInput = document.querySelector('#role_secondary_circle_id');
  const titleInput = document.querySelector('#role_title');
  const acronymInput = document.querySelector('#role_acronym');
  
  roleTypeInput.addEventListener('input', (event) => {
    if (restrictingRoleTypes.includes(roleTypeInput.value)) {
      secondaryCircleInput.disabled = false;
      titleInput.disabled = true;
      acronymInput.disabled = true;
      titleInput.value = 'Bitte Sekundärkreis auswählen';
    } else {
      secondaryCircleInput.value = null;
      secondaryCircleInput.disabled = true;     
      titleInput.disabled = false;
      acronymInput.disabled = false;
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

