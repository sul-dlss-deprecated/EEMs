$(document).ready(function() {

  var token = window._token;
  var pid = window._pid;
  var listLanguages = "Arabic Chinese English French German Hebrew Italian Japanese Korean Russian Spanish Other".split(" ");
  var data = "ABBA-0987 ABCD-1234 ABCE-3456 ABDA-9876 ABZA-5454 BGEW-3891 HJGW-9821 MKGS-9328 LOAW-2169 WESN-1387 OADF-3955 RWGF-4108".split(" ");
  
  init();

  function init() { 
    $('#payment_fund').autocomplete(data);

    if ($('#eem_copyrightStatus').val() == 'Sent request, assume Ok on') {
      createDatepicker();	
    }

    acquisitionsActionsBindToggle('send_to_acquisitions');	 
    acquisitionsActionsBindToggle('delete_this_selection');
    acquisitionsActionsBindToggle('comment_to_selector');	 
  }

  function createDatepicker() {
	var optsDatepicker = { 
	  formElements: {"copyright_date":"m-sl-d-sl-Y"},
	  callbackFunctions: {"dateset": [updateCopyrightDate]}
	};	
			
	datePickerController.createDatePicker(optsDatepicker); 			
  }

  $('#edit_sourceUrl').click(function() { 
    editLink('sourceUrl')
  });

  $('#text_creatorName').click(function() { 
	editTextOnClick('creatorName');
  });

  $('#input_creatorName').blur(function() { 	
	editTextOnBlur('creatorName');	
	updateCreator();
  });

  $('#eem_creatorType').change(function() {
	updateCreator();	
  });

  function updateCreator() {
	var pars = {};

	if ($('#eem_creatorType').val() == 'person') {
	  pars["eem[creatorPerson]"] = $('#input_creatorName').attr('value');
	  pars["eem[creatorOrg]"] = '';	
	} else {
	  pars["eem[creatorOrg]"] = $('#input_creatorName').attr('value');
	  pars["eem[creatorPerson]"] = '';	
	}

	eemUpdate(pars);	
  }

  $('#text_note').click(function() { 
    editTextOnClick('note');  
  });

  $('#input_note').blur(function() { 
    editTextOnBlur('note');  

	var pars = {"eem[note]" : $('#input_note').attr('value')};
	eemUpdate(pars);
  });

  function editTextOnClick(name) {
	$('#input_' + name).attr('value', $('#text_' + name).html());	
	$('#text_' + name).hide();

	$('#input_' + name).show();
	$('#input_' + name).focus();		
  }

  function editTextOnBlur(name) {
	$('#text_' + name).html($('#input_' + name).attr('value'));
	$('#input_' + name).hide();
	$('#text_' + name).show();
  }

  function editLink(name) {	
    if ($('#edit_' + name).text() == 'edit') { 	
	  var url = $('#link_' + name).attr('href');
	
	  if (name == 'selectorSunetid') {
		url = url.replace('mailto:', '');
	  }
		
	  $('#input_' + name).attr('value', url);

	  $('#link_' + name).hide();
	  $('#input_' + name).show();
	  $('#edit_' + name).html('save');
	  $('#edit_' + name).removeClass('link_edit_icon').addClass('link_save_icon');
    }
    else {
	  var url = $('#input_' + name).attr('value');
	
	  $('#link_' + name).html(url); 		
	  $('#link_' + name).attr('href', url); 
	
	  if (name == 'selectorSunetid') {
	    $('#link_' + name).attr('href', 'mailto:' + url);   	
	  }

	  $('#input_' + name).hide();	
	  $('#link_' + name).show();
	  $('#edit_' + name).html('edit');
	  $('#edit_' + name).removeClass('link_save_icon').addClass('link_edit_icon');
	
	  var pars = {};
	  var key = "eem[" + name + "]";
	  pars[key] = $('#input_' + name).attr('value');
	  eemUpdate(pars);
	
    }
  }

  $('#eem_language').change(function() {	
	var pars = {"eem[language]" : $('#eem_language').val()};
	eemUpdate(pars);
  });

  $('#eem_copyrightStatus').change(function() {
	var pars = {};
	pars["eem[copyrightStatus]"] = $('#eem_copyrightStatus').val();
	
	if ($('#eem_copyrightStatus').val() == 'Sent request, assume Ok on') {
	  createDatepicker();	
	  $('#copyright_date').show();	
	}
	else {
	  $('#copyright_date').attr('value', '');	
	  $('#copyright_date').hide();	
	  datePickerController.destroyDatePicker("copyright_date");		
	  pars["eem[copyrightDate]"] = '';	
	}
	
	eemUpdate(pars);
  });

  function updateCopyrightDate(data) {
    var dateValue = data["mm"] + '/' + data["dd"] + '/' + data["yyyy"];
  	var pars = {"eem[copyrightDate]" : dateValue};
	eemUpdate(pars);
  }

  $('#eem_paymentStatus').change(function() {	
	var pars = {};
	pars["eem[paymentStatus]"] = $('#eem_paymentStatus').val();
	
	if ($('#eem_paymentStatus').val() == 'Paid') {
	  pars["eem[paymentFund]"] = $('#paymentFund').val();
      $('#payment_fund').show();	
	}
	else {
	  pars["eem[paymentFund]"] = '';
	  $('#payment_fund').hide();	
	}
	
	eemUpdate(pars);
  });

  $('#payment_fund').result(function(event, data, formatted) { 
	var value = !data ? "" : formatted;
    var pars = {"eem[paymentFund]" : value};
    eemUpdate(pars);
  });

  $('#eem_notify').change(function() {
    var pars = {};

    if ($('#eem_notify:checked').is(':checked')) {
	  pars["eem[notify]"] = 'true';
	  $('#input_selectorSunetid').show();
	  $('#edit_selectorSunetid').show();
    }
    else {	 
	  pars["eem[notify]"] = '';
	  $('#input_selectorSunetid').attr('value', '')	
	  $('#link_selectorSunetid').attr('href', '#')	
	  $('#link_selectorSunetid').html('')		
	  $('#edit_selectorSunetid').html('save');
	  $('#edit_selectorSunetid').hide();
	  $('#input_selectorSunetid').hide();
    }	    
    
    eemUpdate(pars);
  });


  $('#edit_selectorSunetid').click(function() { 
    editLink('selectorSunetid')
  });

  function eemUpdate(pars) {
    pars['authenticity_token'] = token;
    pars['pid'] = pid;

    $.ajax({
	  url: '/eems/' + pid + '.json', 
	  type: 'PUT', 
	  data: pars, 
	  success: function(eem) {
	  }, 
	});
	
	return false;	
  }

  function acquisitionsActionsBindToggle(name) { 
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

}); 
