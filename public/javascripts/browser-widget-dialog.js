var EEMsWidget = { 
  
  showPopOver : function(baseUrl){    
    var popup_width = 480;
    var popup_height = 520;
                  
    if (document.getElementById('eems_popup') != null) {
      document.getElementById('eems_popup').style.display='inline';
      return;
    }

    var popup = document.createElement('div');
    var popup_style = 'overflow: auto; top: 10px; position: fixed; text-align: left; ' + 
      'font: normal normal normal 9px/1.5 Tahoma,Arial; z-index: 100000';
    popup.id = 'eems_popup';
    popup.setAttribute('style', popup_style);
    popup.style.left = (document.body.clientWidth - popup_width - 10) + 'px';
    popup.style.width = popup_width + 'px';
    popup.style.height = popup_height + 'px';
    popup.onmousedown = function() { popup.style.cursor = '-moz-grabbing'; }
    popup.onmouseup = function() { popup.style.cursor = ''; }
     
    var popup_container = document.createElement('div');
    var popup_container_style = 'position: absolute; top: 0; left: 0; ' + 	
      'overflow: auto; background-color: #660000; opacity: 0.6; filter: alpha(opacity=60); ' + 
      '-moz-border-radius: 10px; -webkit-border-radius: 10px';
    popup_container.setAttribute('style', popup_container_style);
    popup_container.style.width = popup_width + 'px';
    popup_container.style.height = popup_height + 'px';
 
    var popup_content = document.createElement('div');
    var popup_content_style = 'top: 10px; left: 10px; clear: both; position: absolute; ' +
      'border: 1px solid #666; -moz-border-radius: 5px; -webkit-border-radius: 5px; background-color: #f6f2f6;';
    popup_content.id = 'popup_content';
    popup_content.setAttribute('style', popup_content_style);    
    popup_content.style.width = (popup_width - 22) + 'px';
    popup_content.style.height = (popup_height - 22) + 'px';
    popup_content.style.backgroundColor = '#fff';
    
    var close_link = document.createElement('a');
    var close_link_style = 'color: #770000; font-weight: bold; position: absolute; ' +
      'right: 15px; top: 6px; padding: 4px; text-decoration: none; border-width: 0;';    
    close_link.setAttribute('style', close_link_style);
    close_link.setAttribute('href', '#');
    close_link.setAttribute('onclick', "javascript:(function(){elemWidget=document.getElementById('eems_popup');elemWidget.parentNode.removeChild(elemWidget);}())");
    
    close_link.innerHTML = 'x';
    popup_content.appendChild(close_link);
    
    var popup_title = document.createElement('div');
    var popup_title_style = 'font-weight: bold; padding: 8px 4px; color: #770000; border-bottom: 1px solid #777; margin: 5px;'
    popup_title.setAttribute('style', popup_title_style);
    
    var popup_title_text = document.createTextNode('EEMs Selection Widget');
    popup_title.appendChild(popup_title_text);    

    var iframeForm = document.createElement('iframe');
    iframeForm.style.width = 460 + 'px';
    iframeForm.style.height = 460 + 'px';
    iframeForm.style.marginLeft = '5px';
    iframeForm.style.borderWidth = 0;
    iframeForm.id = 'iframeForm';
    iframeForm.name = 'iframeForm';
    iframeForm.src = baseUrl + '/eems/new?referrer=' + parent.location.href;

    popup_content.appendChild(popup_title);
    popup_content.appendChild(iframeForm);
    
    popup.appendChild(popup_container);
    popup.appendChild(popup_content);
    
    document.getElementsByTagName('body')[0].appendChild(popup);
    
    this.setupWidgetDragging();
  },
 
  setupWidgetDragging : function() {
    var attrs = {
      isDragged : false,
      left : 0,
      top : 0, 
      drag : { left: 0, top : 0 },    
      start : { left: 0, top : 0 }    
    };       
    
    var elemPopup = document.getElementById('eems_popup');
         
    var startWidgetMove = function(event) {
      if (!event) event = window.event; // required for IE
  
      attrs.drag.left = event.clientX;
      attrs.drag.top  = event.clientY;
      attrs.start.left = parseFloat(elemPopup.style.left.replace(/px/, ''));
      attrs.start.top  = parseFloat(elemPopup.style.top.replace(/px/, ''));
      attrs.isDragged  = true;      
    };
  
    var processWidgetMove = function(event) {      
      if (!event) event = window.event; // required for IE
      
      if (attrs.isDragged) {
        attrs.left = attrs.start.left + (event.clientX - attrs.drag.left);      
        attrs.top = attrs.start.top + (event.clientY - attrs.drag.top);
        
        elemPopup.style.cursor = '-moz-grabbing';
        elemPopup.style.left = attrs.left + 'px';
        elemPopup.style.top = attrs.top + 'px';
      }
    };
    
    var stopWidgetMove = function(event) {
      attrs.isDragged = false;      
      elemPopup.style.cursor = '';
    };
  
    elemPopup.onmousedown = startWidgetMove; 
    elemPopup.onmousemove = processWidgetMove; 
    elemPopup.onmouseup = stopWidgetMove;
    elemPopup.onmouseleave = stopWidgetMove;
    elemPopup.onmouseout = stopWidgetMove;
    elemPopup.ondragstart = function() { return false; } // for IE  
  }
}
