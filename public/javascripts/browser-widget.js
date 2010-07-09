$(document).ready(function() {

  var content_file_id;
  var timeoutId = 0;
  var data = "ABBASI ABBOTT ABERCROMB ABRAHAMSW ACKERMANR AFRICA AFRICADOC AHNE ANTHRO AREASTREF ARONSONB ARSGIFT ARTARCH ASHENR ASUL ASULMEM ASULRES AVERYC BACKERM BACONR BAILEYT BALDRIDGE BALLARDE BANDETH BARCHASS BARKSDALE BARNESJ BARONJ BELLD BENDERA BENDERRM BENNETT BERNSTEIN BIOLOGY BIOLOGY2 BOOKEXCH BOYLESE BRANGIFT BRASCHF BREERC BRICKERF BROOKSC BRUSHIST BRUSHISTI BRUSLIT BRUSLITI BURDJ BURNELLG BURROWSD CAFAROC CAGLEA CAMPBELLR CANFIELDD CARNOCHAN CELEBFUND CHAMBERLA CHEM CHEMGIFT CHICANO CHINAHV CHINART CHINEXCHG CHJPDOC CHUCKF CLASS1965 CLASS1970 CLASSICS CLEBSCH CLEBSCHW CLEMENTM COCHRANS COFFINJ COHNA COMM COMPRACEC CONNOLLYG COTRELLE CRAIGW CRARYG CROWL CULTSTUD CUSICKJ DATAFILE DATAFILE2 DAVESD DAVISJ DENNINGR DIGICORP DINSMOREM DIROFF DOBBSMELT DONNELLD DUPSOLD DUTTONR EALJAPAN EALMOORE EARTHSCI EARTHSCIM EASTASIA EASTASTVI EBOOKS ECON EDGRENR EDUC EEURDOC EGGERE ELIOTM ENG ENGGIFT ENVIROPOP ESBENSHAD FALCONERF FEHRENBAC FELTONC FEMINIST FIELD FILMPERF FITGERWIL FITZHUGHW FLAHERTYM FORDJ FORDOC FORLANGI FOXS FRANKENST FRANKLHUM FRIENDE FRITDOC FRYBERGER GALLAGHER GALTCOBL GAYLES GEBALLET GENACQ GENGIFT GENREF GENSER GERMANIC GIFTSPPRO GOLDMANR GOLDSTEIN GOODANB GORDONA GOVINFOI GREENC GREENW GROMMONA GUNSTM GWAUDOC HADERLIEE HAEFNERJ HAMMONDA HANNA HANNAP HARRASSOW HARRISJ HARRISL HAUGH HAWES HAYFER HEARST HENMULLER HERRICK HERTLEINL HERTLEINM HESS HILLMAN HIRSCHMAN HISTSCI HMSHO HOBSON HOPKINS HORTON HOWELL1 HOWELL2 HUMINST HUMREF HVACQ INFOACC INFOACCDS INSTSOFTW INTLDOC JACKMANC JACKMAND JACOBSONM JAGELS JAPANHV JAY JEWELFUND JEWISH JOHNSONJ JOHNSONW JONESR JONESW JORDAN KARLE KATSEV KATZEVA KATZEVS KAY KAYSTEEVE KEMBLE KENNEDY KIBLER KIM KIMBALL KITTLE KLEINH KLEINM KLINEROET KNAPPI KNAPPJ KOOPERMAN KOREAN KORFDNGR KUMM KUMMA KUMMFF KUMMFG KUMMH KUMMM KUMMS KWOKB KWOKL LANEWEST LANZ LATAM LATAMIDOC LEITER LEWIS LINDER LINGUIST LIS LITFRANKL LITTAUER LITTPOET LMBSP LOWENTHAL LYMAN LYMANAWAR LYNCH MAHARAM MARKUS MARTINEAU MASON MATHCOMP MCCAMENT MCCULLOUG MCDOWELL MEDIAACQ MEDIAINST MEDIARES MEDIEVAL MEMFUND MEYERBORE MEYERRES MEYERRES2 MGATES MIDEAST MILNE MIRRIELEE MIZOTA MONOORD MORGAN MORRISON MOSER MOULTON MUFFLEY MULLERMCC MUNGER MUNRO MUSIC MUSICARS MUSICSCO MUSICSOU MYERS NIELSEN NISHINO NOFUND NUGGETS OBERLIN OFFEN PAGE PAYNEB PAYNER PECK PERFARTS PERRETTE PERRY PETERSONG PHILBRICK PHILOSOPH PHYSGIFT PHYSICS POLISCI PORTWOOD POYET PRICE PROTHRO PSYCH QUILLEN RASMUSSEN REHNBORGC REHNBORGJ REINERT RELIGION RESEVAL RESMAT RESMATBK RESMATCEN RESMATEND RESMATNEY RESMATOPP RITTER RIXON ROBUSTELL ROMANCE ROSE ROSENBAUM ROSENBERG ROSENBLAT ROSS RUEEUR SAMSON SASIA SASIABUDD SCHIRESON SCITECHI SEASIAPAC SHAFTEL SHARP SHARPS SHAVER SHELDON SHOUP SIEVERS SILIGENE SIMPSON SKINNER SMALL SMORTCHEV SNEDDEN SOARES SOC SOCSCII SOCSCIREF SOWERS SPAPOR SPEC SPECGIFT STAFFREF STANDISH STARLING STATEDOC STEEL STEINBERG STEINMETZ STEVENS STRUBLE SUNDERMEY TANENBAUM TANNERMEM TANNERREL TARBELL TAXACCREV THOMASC THOMASR THOMPSONP THOMPSONW THORPE TIERNAN UARCH UARCHGIFT UKCANDOC ULIBRES USDOC VANWYCK VICKERS1 VICKERS2 VONSCHLE WALLER WARREN WATT WEBB WEBSTER WEISS WEURSOC WEYBURN WHITEHEAD WICKERSHA WIEL WIGGINS WILSON WOOD WOODBURN WOODYATT WREDENB WYATT YOUNGH YOUNGHMAP ZALK ZENOFF".split(" ");
  var defaultValues = {
    note: "(Citation, comments, etc.)",
    payment_fund: "(Fund name)"
  };
  var dateFormatMask = "yyyy-mm-dd'T'HH:MM:sso";

  $('#eem_payment_fund').autocomplete(data);

  $('#eem_payment_fund').change(function() { 
    toggleSendToTechServices();
  });
		
  function submitEEM(pars, logMsg) { 
    pars = pars + '&eem[statusDatetime]=' + dateFormat(dateFormatMask);
    $('#eems-new-form-widget').fadeOut('slow');
    $('#eems-loader').show();

    if ($('#eem_note').val() == defaultValues.note) { $('#eem_note').val(''); }
    if ($('#eem_payment_fund').val() == defaultValues.payment_fund) { $('#eem_payment_fund').val(''); }

    var eem_data = $('#eems-new-form-widget').serialize() + '&' + pars;

    if ($('#contentUrl').val() == '') {
	    createEEM_WithoutPDF(eem_data, logMsg);
    } else {
	    createEEM_WithPDF(eem_data, logMsg);
		}

		return false;
  }

  function createEEM_WithPDF(eem_data, logMsg) {
	  $.ajax({
		  url: '/eems', 
		  type: 'POST', 
		  datatype: 'json', 
		  timeout: 10000, 
		  data: eem_data, 
		  success: function(eem) {			
		    $('#eems-loader').hide();
				$('#eems-upload-progress').show();	    				
				if (eem != null) {
				  $('#details-link').attr('href', '/view/' + eem.eem_pid);	
		      content_file_id = eem.content_file_id;		
		      addLogEntry(logMsg, eem.eem_pid);					  
			    update();
			    var selectorName = $('#eem_selectorName').val();
			    addLogEntry("PDF uploaded by " + selectorName, eem.eem_pid);					  
				} else {
				  showPDFErrorMsg(); 	
				}					
		  }, 
		  error: function() { showEEMsErrorMsg(); },  			
		});  
  }

  function createEEM_WithoutPDF(eem_data, logMsg) {
    $.ajax({
		  url: '/eems/no_pdf', 
		  type: 'POST', 
		  datatype: 'json', 
		  timeout: 10000, 
		  data: eem_data, 
		  success: function(eem) {			
				if (eem != null) {
				  $('#details-link').attr('href', '/view/' + eem.eem_pid);	
		      addLogEntry(logMsg, eem.eem_pid);		
			    $('#eems-loader').hide();	
			    $('#eems-success').show();			
			    $('#eems-links').show();							  
				} else {
				  showPDFErrorMsg(); 	
				}
		  },
			error: function() { showEEMsErrorMsg(); },  			
		});	
  }

  function showEEMsErrorMsg() {
    $('#eems-loader').hide();					  
    $('#eems-upload-progress').hide();
    $('#eems-error').html("<span class=\"errorMsg\">Error creating EEM.</span>").show();							  						
  }

  function showPDFErrorMsg() {
    $('#eems-loader').hide();				
    $('#eems-upload-progress').hide();
    $('#eems-error').html("<span class=\"errorMsg\">Error uploading PDF.</span>").show();							  						
  }

  function update() {
	  $.getJSON('/content_files/' + content_file_id, function(data) {
	  
		  if (data == null || (data != null && data.attempts == 'failed')) {
			  showPDFErrorMsg(); 
			  return;
		  }  
	
		  var percent = parseInt(data.percent_done);
	   
		  if (!isNaN(percent)) {
			  $('#percent_done').html(percent + ' %');
			  $('#progress_bar').css({'width' : (percent*3) + 'px', 'height' : '10px' });

			  if (percent == 100) {
			    $('#upload-progress-text').hide();
			    $('#upload-complete-text').show();
			    $('#eems-links').show();
			    clearTimeout(timeoutId);
			    return;			
				}
      }		  
		});
	
		timeoutId = setTimeout(update, 500);
  }

  function addLogEntry(logMsg, pid) {
	  var pars = {'entry': logMsg, 'authenticity_token': window._token};
	
    $.ajax({
		  url: '/eems/' + pid + '/log', 
		  type: 'POST', 
		  datatype: 'json', 
		  data: pars, 
		  success: function() {}, 
		});	  
  }

  $('#eem_paymentType').change(function() {	
		if ($('#eem_paymentType').val() == 'Paid') {
		  $('#eem_payment_fund').show();	
		}
		else {
		  $('#eem_payment_fund').hide();	
		}
	
		toggleSendToTechServices();
  });

  $('#eem_note').focus(function() {
    if ($('#eem_note').val() == defaultValues.note) {
		  $('#eem_note').val('');
    }
  });

  $('#eem_payment_fund').focus(function() {
    if ($('#eem_payment_fund').val() == defaultValues.payment_fund) {
		  $('#eem_payment_fund').val('');
    }
  });

  $('#eem_title').change(function() {
    toggleSaveToDashboard();
    toggleSendToTechServices();
  });

  $('#contentUrl').hover(function() {
    toggleSaveToDashboard();
    toggleSendToTechServices();
  });

  $('#contentUrl').change(function() {
    toggleSaveToDashboard();
    toggleSendToTechServices();
  });

  $('#eem_copyrightStatus').change(function() {
    toggleSendToTechServices();
  });

  $('#save_to_dashboard').click(function() {
	  var selectorName = $('#eem_selectorName').val();
    var logMsg = 'Request created by ' + selectorName;
    var pars = 'eem[status]=Created'; 
    submitEEM(pars, logMsg);
  });

  $('#send_to_tech_services').click(function() {
	  var selectorName = $('#eem_selectorName').val();
    var logMsg = 'Request submitted by ' + selectorName;
    var pars = 'eem[status]=Submitted&eem[requestDatetime]=' + dateFormat(dateFormatMask);
    submitEEM(pars, logMsg);
  });

  function toggleSaveToDashboard() {
    if ($('#eem_title').val() != '' && $('#contentUrl').val() != '' ) {
		  $('#save_to_dashboard').attr("disabled", false);
    }	
    else {
		  $('#save_to_dashboard').attr("disabled", true);
    }
  }

  function toggleSendToTechServices() {
	    if ($('#eem_title').val() != '' && ($('#eem_paymentType').val() == 'Free' && ($('#eem_copyrightStatus').val() == 'Public access OK' || $('#eem_copyrightStatus').val() == 'Stanford access OK')) || 
	        ($('#eem_paymentType').val() == 'Paid' && $('#eem_payment_fund').val() != defaultValues.payment_fund)) {
		    $('#send_to_tech_services').attr("disabled", false);
		}
		else {
	  	$('#send_to_tech_services').attr("disabled", true);
		}	
  }

  function unescapeTags(value) {
    value = value.replace(/>/gi, "&gt;");
    value = value.replace(/</gi, "&lt;");
    return value;
  }

});


