$(document).ready(function() {
	acquisitionsActionsBindToggle('send_to_tech_services');	 
	acquisitionsActionsBindToggle('delete_this_selection');
	acquisitionsActionsBindToggle('comment_to_selector');	 
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

