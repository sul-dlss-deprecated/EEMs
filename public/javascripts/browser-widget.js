$(document).ready(function() {

  var content_file_id;
  var timeoutId = 0;
  var data = "ABBA-0987 ABCD-1234 ABCE-3456 ABDA-9876 ABZA-5454 BGEW-3891 HJGW-9821 MKGS-9328 LOAW-2169 WESN-1387 OADF-3955 RWGF-4108".split(" ");
  $('#eems_payment_fund').autocomplete(data);
		
  $('#eems-new-form-widget').submit(function() {
    $('#eems-new-form-widget').hide();

    $.ajax({
	  url: '/eems', 
	  type: 'POST', 
	  datatype: 'json', 
	  data: $('#eems-new-form-widget').serialize(), 
	  success: function(eem) {
		$('#eems-upload-progress').show();	    
		if (eem != null) {
		  $('#details-link').attr('href', '/eems/' + eem.eem_pid);	
	      content_file_id = eem.content_file_id;		
		  update();
		}
	  }, 
	});

	return false;
  });

  function update() {
	$.getJSON('/content_files/' + content_file_id, function(data){
	  
	  $('#progress_bar').css({'width' : parseInt(data.percent_done)*2 + 'px', 'height' : '10px' });
	
	  if (data.percent_done != '') { 
	    $('#percent_done').html(data.percent_done + ' %');
      }
      else {
	    $('#percent_done').html(data.percent_done + '0 %');	 
      }

      if (parseInt(data.percent_done) == 100) {
	    $('#upload-progress-text').hide();
	    $('#upload-complete-text').show();
	    $('#eems-details-link').show();
	    clearTimeout(timeoutId);
	    return;
      }	  
	});
	
	timeoutId = setTimeout(update, 500);
  }

  $('#eem_copyrightStatus').change(function() {
	if ($('#eem_copyrightStatus').val() == 'Sent request, assume Ok on') {
	  var optsDatepicker = { formElements:{"eems_copyright_date":"d-sl-m-sl-Y"} };			
	  datePickerController.createDatePicker(optsDatepicker); 		
	  $('#eems_copyright_date').show();	
	}
	else {
	  $('#eems_copyright_date').hide();	
	  datePickerController.destroyDatePicker("eems-copyright-date");		
	}
  });

  $('#eem_paymentStatus').change(function() {	
	if ($('#eem_paymentStatus').val() == 'Paid') {
	  $('#eems_payment_fund').show();	
	}
	else {
	  $('#eems_payment_fund').hide();	
	}
  });

  $('#eem_notify').change(function() {
    if ($('#eem_notify:checked').val() == 'true') {
	  $('#eem_selectorSunetid').show();
    }
    else {	 
	  $('#eem_selectorSunetid').hide();
    }	    
  })

});


