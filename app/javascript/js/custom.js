// Js for add member modal

$(document).ready(function() {
  // Function to filter checkboxes based on search input
  function filterCheckboxes(searchTerm) {
    $('.user-checkbox').each(function() {
      var username = $(this).find('label').text();
      if (username.toLowerCase().includes(searchTerm.toLowerCase())) {
        $(this).show();
      } else {
        $(this).hide();
      }
    });
  }

  // Triggered on search input change
  $('.searchMembers').on('keyup', function() {
    var searchTerm = $(this).val();
    filterCheckboxes(searchTerm);
  });

  $(document).on('change', 'input[name="selected_user[]"]', function() {
    var selectedValues = [];
    $('.user-checkbox input[name="selected_user[]"]:checked').each(function() {
      selectedValues.push($(this).val());
    });
    $('.selectedMembers').val(selectedValues.join(', '));
  });

  // Function to reset form fields when close button is clicked
  $('.closeModal').on('click', function() {
      $('.userForm').trigger('reset');
  });
});