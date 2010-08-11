
$(document).ready(function() {	
	acquisitionsActionsBindToggle('send_to_tech_services');	 
	acquisitionsActionsBindToggle('cancel_this_request');
	acquisitionsActionsBindToggle('comment_to_selector');	 
	
	$('#text_comment_to_selector').val('');
	$('#text_cancel_this_request').val('');

	// cancel this request
  $('#cancel_this_request_ok').click(function() {
    cancelThisRequest();
  });
  
	// question/comment to selector
  $('#comment_to_selector_ok').click(function() {
    questionOrCommentToSelector();
  });

  $('#text_comment_to_selector').keyup(function() { 
	  var txt = $('#text_comment_to_selector').val();

	  if (/\S/.test(txt)) {
		  $('#comment_to_selector_ok').removeAttr('disabled');
	  }	else {
		  $('#comment_to_selector_ok').attr('disabled', 'disabled');		
	  }
	});  
});

function acquisitionsActionsBindToggle(name) { 
	if ($('#link_' + name).length > 0) {
		$('#link_' + name).toggle(
			function() {
				$('#formlet_' + name).show();	
				$('#link_' + name).parents('li').removeClass('list_style_show').addClass('list_style_hide');	
			}, 
			function() {
				$('#formlet_' + name).hide();	
				$('#link_' + name).parents('li').removeClass('list_style_hide').addClass('list_style_show');	
			}
		);		
	}
}

function cancelThisRequest() {
  var cancelComment = unescapeTags($('#text_cancel_this_request').val());
  var pid = window._pid;
  var pars = { 'eem[status]': 'Canceled', 'authenticity_token': window._token };

  eemUpdate(pid, pars);

  var pars = { 
	  'entry': 'Request canceled by ' + selectorName, 
	  'comment': cancelComment,
	  'authenticity_token': window._token
	};
	
  addLogEntry(pid, pars, true);	
}

function questionOrCommentToSelector() {
  var questionOrComment = unescapeTags($('#text_comment_to_selector').val());

  if (/\S/.test(questionOrComment)) { 
	  var pars = { 
		  'entry': 'Question/comment by ' + selectorName, 
		  'comment': questionOrComment,
		  'authenticity_token': window._token
		};
		
    addLogEntry(window._pid, pars, true);	
	}
}


