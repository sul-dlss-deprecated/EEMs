
$(document).ready(function() {
	
  var content_file_id;
  var timeoutId = 0;
	
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

});


