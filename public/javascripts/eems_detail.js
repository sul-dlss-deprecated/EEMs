var token = window._token;
var pid = window._pid;
var listLanguages = "Arabic Chinese English French German Hebrew Italian Japanese Korean Russian Spanish Other".split(" ");
var data = "FUND1 FUND2 FUND3".split(" ");
var defaultValues = {
  "title" : "Click to add title", 
  "creatorName" : "Click to add creator name", 
  "note" : "Click to add citations, comments, copyright notes, etc.",
  "payment_fund" : "(Fund name)",
  "linkUrl" : "Click to add link"
};
var dateFormatMask = "yyyy-mm-dd'T'HH:MM:sso";

$(document).ready(function() {
	
  $('#eem_payment_fund').autocomplete(data);

  $.each(['creatorName', 'note'], function(index, name) {
	  if ($('#text_' + name).html() == '') {
	    $('#text_' + name).html("<span class='text_placeholder'>" + defaultValues[name] + "</span>");
	  }
  });

  $('#eem_payment_fund').focus(function() {
    if ($('#eem_payment_fund').val() == defaultValues.payment_fund) {
		  $('#eem_payment_fund').val('');
    }
  });
	
	toggleSendToTechServices();

  $('#btn_detail_file_upload').click(function() {
	  $(this).attr('disabled', 'disabled');
	  $('#detail_file_upload_loader').show();	
	  $('#detail_file_upload').submit();
  });

  $('#content_upload').change(function() {
	  if ($('#content_upload').val() != '') {
		  $('#btn_detail_file_upload').removeAttr('disabled');
	  } else {
		  $('#btn_detail_file_upload').attr('disabled', 'disabled');
	  } 
  });

  // send to tech services
  $('#send_to_tech_services_ok').click(function() {
	  $('#send_to_tech_services_ok').attr('disabled', 'disabled');
    sendToTechServices();
  });

  // Title - inline edit
  $('#text_title').click(function() { 
		editTextOnClick('title');
  });

  $('#input_title').blur(function() { 	
		editTextOnBlur('title');	
		var pars = {"eem[title]" : $('#input_title').val(), 'authenticity_token': token };		
		eemUpdate(pid, pars);	
		toggleSendToTechServices();
  });

  // Creator Name - inline edit 
  $('#text_creatorName').click(function() { 
		editTextOnClick('creatorName');
  });

  $('#input_creatorName').blur(function() { 	
		editTextOnBlur('creatorName');	
		updateCreator();
  });

  // Direct link to file - inline edit
  $('#btn_linkUrl').click(function() {
    editLinkUrlOnClick();
  });

  $('#text_linkUrl').click(function() {
    editLinkUrlOnClick();
  });

  $('#input_linkUrl').blur(function() {
		var pars = {'authenticity_token': token };		
		
		if ($('#input_linkUrl').attr('value') == '') {
			$('#text_linkUrl').show();
			$('#linkUrl').attr('href', '');
			$('#linkUrl').text('');			
			$('#linkUrl').hide();
		} 
		else {
		  $('#linkUrl').attr('href', unescapeTags($('#input_linkUrl').attr('value')));		
		  $('#linkUrl').text(unescapeTags($('#input_linkUrl').attr('value')));		
		  $('#text_linkUrl').hide();
			$('#btn_linkUrl').show();
			$('#linkUrl').show();	
			pars['part[url]'] = unescapeTags($('#input_linkUrl').attr('value'));
			partUpdate(pid, pars);	
		}
		
		$('#input_linkUrl').hide();
  });

  // Creator Type
  $('#eem_creatorType').change(function() {
		updateCreator();	
  });

  // Note/Comments - inline edit 
  $('#text_note').click(function() { 
    editTextOnClick('note');  
  });

  $('#input_note').blur(function() { 
    editTextOnBlur('note');  

    var noteValue = $('#input_note').attr('value');

		if (noteValue.match(new RegExp(defaultValues['note'], 'i')) != null) {
		  noteValue = '';	
		}	

		var pars = {"eem[note]" : noteValue, 'authenticity_token': token };
		eemUpdate(pid, pars);
  });

  // Language 
  $('#eem_language').change(function() {	
		var pars = {"eem[language]" : $('#eem_language').val(), 'authenticity_token': token };
		eemUpdate(pid, pars);
  });

  // Copyright
  $('#eem_copyrightStatus').change(function() {
		var pars = {};
		pars["eem[copyrightStatus]"] = $('#eem_copyrightStatus').val();
		pars["eem[copyrightStatusDate]"] = dateFormat(dateFormatMask);
		pars["authenticity_token"] = token;
	
		eemUpdate(pid, pars);
		toggleSendToTechServices();		
  });

  // Payment Status
  $('#eem_paymentType').change(function() {	
		var pars = {};
		pars["eem[paymentType]"] = $('#eem_paymentType').val();
		pars["authenticity_token"] = token;
	
		if ($('#eem_paymentType').val() == 'Paid') {
			var value = $('#eem_payment_fund').val();
			
			if (value != defaultValues.payment_fund) {			
			  pars["eem[paymentFund]"] = value;		
		  }
		
	    $('#eem_payment_fund').show();	
		}
		else {
		  pars["eem[paymentFund]"] = '';
      $('#eem_payment_fund').val(defaultValues.payment_fund);		
		  $('#eem_payment_fund').hide();	
		}
	
		eemUpdate(pid, pars);
		toggleSendToTechServices();		
  });

  // Payment fund 
  $('#eem_payment_fund').result(function(event, data, formatted) { 
		var value = !data ? "" : formatted;
		
		if (value != '' && value != defaultValues.payment_fund) {
	    var pars = { "eem[paymentFund]" : value, 'authenticity_token': token };
	    eemUpdate(pid, pars);
    }

		toggleSendToTechServices();
  });

  $('#eem_payment_fund').change(function() { 
		var value = $('#eem_payment_fund').val();
		
		if (value != '' && value != defaultValues.payment_fund) {
	    var pars = { "eem[paymentFund]" : value, 'authenticity_token': token };
	    eemUpdate(pid, pars);
    }

		toggleSendToTechServices();
  });

}); 

function updateCreator() {
	var pars = { 'authenticity_token': token };
	var creatorValue = $('#input_creatorName').attr('value');

	if (creatorValue.match(new RegExp(defaultValues['creatorName'], 'i')) != null) {
	  creatorValue = '';	
	}	

	if ($('#eem_creatorType').val() == 'person') {
	  pars["eem[creatorPerson]"] = creatorValue;
	  pars["eem[creatorOrg]"] = '';	
	} else {
	  pars["eem[creatorOrg]"] = creatorValue;
	  pars["eem[creatorPerson]"] = '';	
	}

	eemUpdate(pid, pars);	
}	

// inline edit functions 
function editTextOnClick(name) {	
	if ($('#text_' + name).html().match(new RegExp(defaultValues[name], 'i')) != null) {
	  $('#text_' + name).html('');	
	} 

	$('#input_' + name).attr('value', escapeTags($('#text_' + name).html()));	
	$('#text_' + name).hide();

	$('#input_' + name).show();
	$('#input_' + name).focus();		
}

function editTextOnBlur(name) {
	if ($('#input_' + name).attr('value') == '') {
	  $('#input_' + name).attr('value', "<span class='text_placeholder'>" + defaultValues[name] + "</span>");	
  	$('#text_' + name).html($('#input_' + name).attr('value'));		
	} 
	else {
	  $('#text_' + name).html(unescapeTags($('#input_' + name).attr('value')));		
	}

	$('#input_' + name).hide();
	$('#text_' + name).show();
}

function editLinkUrlOnClick() {
	if ($('#linkUrl').attr('href').match(new RegExp(defaultValues['linkUrl'], 'i')) != null) {
	  $('#linkUrl').attr('href', '');	
	  $('#linkUrl').text('');		
	} 

	$('#input_linkUrl').attr('value', escapeTags($('#linkUrl').attr('href')));	
	
	$('#linkUrl').hide();
	$('#btn_linkUrl').hide();
	$('#text_linkUrl').hide();
	$('#input_linkUrl').show();
	$('#input_linkUrl').focus();				
}

function updateCopyrightDate(data) {
  var dateValue = data["mm"] + '/' + data["dd"] + '/' + data["yyyy"];
	var pars = { "eem[copyrightDate]" : dateValue, 'authenticity_token': token };
	eemUpdate(pid, pars);
}

function toggleSendToTechServices() {
  if ($('#input_title').val() != '' && $('#input_title').val() != 'Click to add title' && status != 'Submitted' && $('#detail_file_upload').length == 0 && 
      (($('#eem_paymentType').val() == 'Free' && ( $('#eem_copyrightStatus').val() == 'Public access OK' || $('#eem_copyrightStatus').val() == 'Stanford access OK')) ||  
	     ($('#eem_paymentType').val() == 'Paid' && $('#eem_payment_fund').val() != '' && $('#eem_payment_fund').val() != '(Fund name)'))) {
    $('#send_to_tech_services_ok').removeAttr('disabled');
  	$('#text_send_to_acquistions').val('');
    $('#text_send_to_acquistions').removeAttr('disabled');
	}
	else {
  	$('#send_to_tech_services_ok').attr('disabled', true);
  	$('#text_send_to_acquistions').val('This item can\'t be sent to Technical Services until copyright permission is received.');
  	$('#text_send_to_acquistions').attr('disabled', true);
	}	
	
	// no local pdf file exists. hence, #detail_file_upload form element exists 
	if ($('#detail_file_upload').length != 0) {
  	$('#text_send_to_acquistions').val('This item can\'t be sent to Technical Services until a local copy of the file is uploaded.');		
	}
}

function sendToTechServices() {
  var comment = unescapeTags($('#text_send_to_acquistions').val());
  var pars = {};	
  if (pid == undefined) { pid = window._pid; }
  pars['authenticity_token'] = token;

  if (/\S/.test(comment)) { 
		 pars['comment'] = comment;
	}
  
  $.ajax({
	  url: '/eems/' + pid + '/submit_to_tech_services', 
	  type: 'PUT', 
	  data: pars, 
	  success: function(status) {
		  if (status) {
			  window.location.reload();
		  }
	  }, 
	});
}

function deletePermissionFile(eem_pid, file_pid) {
	var uniq_id = file_pid.replace('druid:', '');
	
	$('#delete_' + uniq_id).hide();
	$('#loader_' + uniq_id).show();
	
	$.ajax({
	  url: '/eems/' + eem_pid + '/permission_files/' + file_pid,
	  type: 'DELETE', 
	  success: function(status) {
		  if (status == 'OK') { window.location.reload(); } 
	  }	
	});
}
