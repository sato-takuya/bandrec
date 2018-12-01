  $(function () {
    $('input:radio[name="user_type"]').change(function () {
      $var = $("input[name='user_type']:checked").val()
      if ($var == 1) {
        $(".show-add").show();
        $(".show-band").hide();
      } else if ($var == 2){
        $(".show-band").show();
        $(".show-add").hide();
      };
    });
  });
