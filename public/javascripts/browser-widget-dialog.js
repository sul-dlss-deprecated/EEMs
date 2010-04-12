var EEMsWidget = {

  popupWidth : function() {
    return 470;
  },

  popupHeight : function() {
    return 500;
  },  
  
  showPopOver : function(){        
    if (document.getElementById('popup') != null) {
      document.getElementById('popup').style.display='inline';
      return;
    }

    var popup = document.createElement('div');
    popup.id = 'popup';
    
    popup.style.width = this.popupWidth() + 'px';
    popup.style.height = this.popupHeight() + 'px';
    popup.style.borderColor = '#999999';
    popup.style.backgroundColor = '#770000';
    popup.style.position = 'absolute';
    popup.style.top = 10 + 'px';
    popup.style.right = 10 + 'px';
    popup.style.padding = 10 + 'px';
    popup.style.fontFamily = 'Tahoma';
    popup.style.fontSize = 9 + 'px';
    popup.style.borderTop = '2px solid #440000';
    popup.style.borderRight = '2px solid #440000';
    popup.style.borderBottom = '2px solid #440000';
    popup.style.borderLeft = '2px solid #440000';
    popup.style.zIndex = 100000;
    popup.style.textAlign = 'left';

    var popup_content = document.createElement('div');
    popup_content.id = 'popup_content';
    popup_content.style.zIndex = 100;
    
    popup_content.style.width = (this.popupWidth() - 10) + 'px';
    popup_content.style.height = (this.popupHeight() - 10) + 'px';
    popup_content.style.backgroundColor = '#f6f2e6';
    popup_content.style.padding = 5 + 'px';

    var closeLink = document.createElement('a');    
    closeLink.style.color = '#770000';    
    closeLink.style.fontWeight = 'bold';
    closeLink.style.position = 'absolute';
    closeLink.style.right = 20 + 'px';
    closeLink.style.top = 12 + 'px';
    closeLink.style.padding = 4 + 'px';    
    closeLink.style.textDecoration = 'none';
    closeLink.setAttribute('href', '#');
    closeLink.setAttribute('onclick', "javascript:document.getElementById('popup').style.display='none';");
    //closeLink.setAttribute('onclick', "javascript:document.removeChild(document.getElementById('popup'));");
    
    closeLink.innerHTML = 'x';
    popup_content.appendChild(closeLink);
    
    var divPopupTitle = document.createElement('div');
    divPopupTitle.style.fontWeight = 'bold';
    divPopupTitle.style.padding = 4 + 'px';
    divPopupTitle.style.borderBottom = '1px solid #aaaaaa';
    
    var popupTitle = document.createTextNode('EEMs Selection Widget');
    divPopupTitle.appendChild(popupTitle);    

    var iframeForm = document.createElement('iframe');
    iframeForm.style.width = 460 + 'px';
    iframeForm.style.height = 460 + 'px';
    iframeForm.style.marginLeft = 5 + 'px';
    iframeForm.style.borderWidth = 0;
    iframeForm.id = 'iframeForm';
    iframeForm.name = 'iframeForm';
    //iframeForm.src = 'http://www.stanford.edu/~jchris/EEMs/content_iframe.html';
    iframeForm.src = 'http://localhost:3000/eems/new';
    //iframeForm.src = 'http://webmail.stanford.edu/';

    popup_content.appendChild(divPopupTitle);
    popup_content.appendChild(iframeForm);
    
    popup.appendChild(popup_content);
    
    document.getElementsByTagName('body')[0].appendChild(popup);
    //alert(parent.location.href);

    this.updateIframe();
  },

  updateIframe: function() {
    //alert(window.frames['iframeForm'].contentWindow.document.forms.length);
    //if (window.frames['iframeForm'].document != null) {
      //alert(window.frames['iframeForm'].document.form_widget.elements['sourceUrl'].value);
      //= document.location.href;
    //}
    //for (i = 0; i < window.frames['iframeForm'].document.forms.length; i++) {
      //alert(i);
    //}
  }
}