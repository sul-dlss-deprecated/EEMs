function addLogEntry(pid, pars, reload) {
	if (pid == undefined) { pid = window._pid; }

  $.ajax({
	  url: '/eems/' + pid + '/log', 
	  type: 'POST', 
	  datatype: 'json', 
	  data: pars, 
	  success: function() { 
		  if (reload) {
	      window.location.reload();
      }
	  }, 
	});	  	
}

function unescapeTags(value) {
  value = value.replace(/>/gi, "&gt;");
  value = value.replace(/</gi, "&lt;");
  return value;
}

function escapeTags(value) {
  value = value.replace(/&gt;/gi, ">");
  value = value.replace(/&lt;/gi, "<");
  value = value.replace(/<br\/?>/gi, "\r");
  return value;
}

// Ajax updater
function eemUpdate(pid, pars) {
	if (pid == undefined) { pid = window._pid; }
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