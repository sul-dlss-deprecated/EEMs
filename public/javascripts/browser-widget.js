$(document).ready(function() {

  var content_file_id;
  var timeoutId = 0;
  var data = "ABBASI ABBOTT ABERCROMB ABRAHAMSW ACKERMANR AFRICA AFRICADOC AHNE ANTHRO AREASTREF ARONSONB ARSGIFT ARTARCH ASHENR ASUL ASULMEM ASULRES AVERYC BACKERM BACONR BAILEYT BALDRIDGE BALLARDE BANDETH BARCHASS BARKSDALE BARNESJ BARONJ BELLD BENDERA BENDERRM BENNETT BERNSTEIN BIOLOGY BIOLOGY2 BOOKEXCH BOYLESE BRANGIFT BRASCHF BREERC BRICKERF BROOKSC BRUSHIST BRUSHISTI BRUSLIT BRUSLITI BURDJ BURNELLG BURROWSD CAFAROC CAGLEA CAMPBELLR CANFIELDD CARNOCHAN CELEBFUND CHAMBERLA CHEM CHEMGIFT CHICANO CHINAHV CHINART CHINEXCHG CHJPDOC CHUCKF CLASS1965 CLASS1970 CLASSICS CLEBSCH CLEBSCHW CLEMENTM COCHRANS COFFINJ COHNA COMM COMPRACEC CONNOLLYG COTRELLE CRAIGW CRARYG CROWL CULTSTUD CUSICKJ DATAFILE DATAFILE2 DAVESD DAVISJ DENNINGR DIGICORP DINSMOREM DIROFF DOBBSMELT DONNELLD DUPSOLD DUTTONR EALJAPAN EALMOORE EARTHSCI EARTHSCIM EASTASIA EASTASTVI EBOOKS ECON EDGRENR EDUC EEURDOC EGGERE ELIOTM ENG ENGGIFT ENVIROPOP ESBENSHAD FALCONERF FEHRENBAC FELTONC FEMINIST FIELD FILMPERF FITGERWIL FITZHUGHW FLAHERTYM FORDJ FORDOC FORLANGI FOXS FRANKENST FRANKLHUM FRIENDE FRITDOC FRYBERGER GALLAGHER GALTCOBL GAYLES GEBALLET GENACQ GENGIFT GENREF GENSER GERMANIC GIFTSPPRO GOLDMANR GOLDSTEIN GOODANB GORDONA GOVINFOI GREENC GREENW GROMMONA GUNSTM GWAUDOC HADERLIEE HAEFNERJ HAMMONDA HANNA HANNAP HARRASSOW HARRISJ HARRISL HAUGH HAWES HAYFER HEARST HENMULLER HERRICK HERTLEINL HERTLEINM HESS HILLMAN HIRSCHMAN HISTSCI HMSHO HOBSON HOPKINS HORTON HOWELL1 HOWELL2 HUMINST HUMREF HVACQ INFOACC INFOACCDS INSTSOFTW INTLDOC JACKMANC JACKMAND JACOBSONM JAGELS JAPANHV JAY JEWELFUND JEWISH JOHNSONJ JOHNSONW JONESR JONESW JORDAN KARLE KATSEV KATZEVA KATZEVS KAY KAYSTEEVE KEMBLE KENNEDY KIBLER KIM KIMBALL KITTLE KLEINH KLEINM KLINEROET KNAPPI KNAPPJ KOOPERMAN KOREAN KORFDNGR KUMM KUMMA KUMMFF KUMMFG KUMMH KUMMM KUMMS KWOKB KWOKL LANEWEST LANZ LATAM LATAMIDOC LEITER LEWIS LINDER LINGUIST LIS LITFRANKL LITTAUER LITTPOET LMBSP LOWENTHAL LYMAN LYMANAWAR LYNCH MAHARAM MARKUS MARTINEAU MASON MATHCOMP MCCAMENT MCCULLOUG MCDOWELL MEDIAACQ MEDIAINST MEDIARES MEDIEVAL MEMFUND MEYERBORE MEYERRES MEYERRES2 MGATES MIDEAST MILNE MIRRIELEE MIZOTA MONOORD MORGAN MORRISON MOSER MOULTON MUFFLEY MULLERMCC MUNGER MUNRO MUSIC MUSICARS MUSICSCO MUSICSOU MYERS NIELSEN NISHINO NOFUND NUGGETS OBERLIN OFFEN PAGE PAYNEB PAYNER PECK PERFARTS PERRETTE PERRY PETERSONG PHILBRICK PHILOSOPH PHYSGIFT PHYSICS POLISCI PORTWOOD POYET PRICE PROTHRO PSYCH QUILLEN RASMUSSEN REHNBORGC REHNBORGJ REINERT RELIGION RESEVAL RESMAT RESMATBK RESMATCEN RESMATEND RESMATNEY RESMATOPP RITTER RIXON ROBUSTELL ROMANCE ROSE ROSENBAUM ROSENBERG ROSENBLAT ROSS RUEEUR SAMSON SASIA SASIABUDD SCHIRESON SCITECHI SEASIAPAC SHAFTEL SHARP SHARPS SHAVER SHELDON SHOUP SIEVERS SILIGENE SIMPSON SKINNER SMALL SMORTCHEV SNEDDEN SOARES SOC SOCSCII SOCSCIREF SOWERS SPAPOR SPEC SPECGIFT STAFFREF STANDISH STARLING STATEDOC STEEL STEINBERG STEINMETZ STEVENS STRUBLE SUNDERMEY TANENBAUM TANNERMEM TANNERREL TARBELL TAXACCREV THOMASC THOMASR THOMPSONP THOMPSONW THORPE TIERNAN UARCH UARCHGIFT UKCANDOC ULIBRES USDOC VANWYCK VICKERS1 VICKERS2 VONSCHLE WALLER WARREN WATT WEBB WEBSTER WEISS WEURSOC WEYBURN WHITEHEAD WICKERSHA WIEL WIGGINS WILSON WOOD WOODBURN WOODYATT WREDENB WYATT YOUNGH YOUNGHMAP ZALK ZENOFF".split(" ");
  var defaultValues = {
    note: "(Citation, comments, etc.)",
    payment_fund: "(Fund name)"
  };

  $('#eem_payment_fund').autocomplete(data);
		
  function submitEEM(status) {	
    $('#eems-new-form-widget').hide();

    if ($('#eem_note').val() == defaultValues.note) {
	  $('#eem_note').val('');
    }

    if ($('#eem_payment_fund').val() == defaultValues.payment_fund) {
	  $('#eem_payment_fund').val('');
    }

    $.ajax({
	  url: '/eems', 
	  type: 'POST', 
	  datatype: 'json', 
	  data: $('#eems-new-form-widget').serialize() + '&' + status, 
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
  }

  function update() {
	$.getJSON('/content_files/' + content_file_id, function(data){
	  
	  $('#progress_bar').css({'width' : parseInt(data.percent_done)*3 + 'px', 'height' : '10px' });
	
	  if (data.percent_done != '') { 
	    $('#percent_done').html(data.percent_done + ' %');
      }
      else {
	    $('#percent_done').html(data.percent_done + '0 %');	 
      }

      if (parseInt(data.percent_done) == 100) {
	    $('#upload-progress-text').hide();
	    $('#upload-complete-text').show();
	    $('#eems-links').show();
	    clearTimeout(timeoutId);
	    return;
      }	  
	});
	
	timeoutId = setTimeout(update, 500);
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
    submitEEM("eem[status]=Created");
  });

  $('#send_to_tech_services').click(function() {
    submitEEM("eem[status]=Request submitted");
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
    if ($('#eem_title').val() != '' && 
         (($('#eem_copyrightStatus').val() == 'Public access OK' && $('#eem_paymentType').val() == 'Paid') || 
	      ($('#eem_copyrightStatus').val() == 'Stanford access OK' && $('#eem_paymentType').val() == 'Paid') || 
	      ($('#eem_copyrightStatus').val() == 'Requires request' && $('#eem_paymentType').val() == 'Paid')) ) {
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


