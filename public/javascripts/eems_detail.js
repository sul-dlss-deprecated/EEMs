$(document).ready(function() {

  var token = window._token;
  var pid = window._pid;
  var listLanguages = "Arabic Chinese English French German Hebrew Italian Japanese Korean Russian Spanish Other".split(" ");
  var data = "ABBASI ABBOTT ABERCROMB ABRAHAMSW ACKERMANR AFRICA AFRICADOC AHNE ANTHRO AREASTREF ARONSONB ARSGIFT ARTARCH ASHENR ASUL ASULMEM ASULRES AVERYC BACKERM BACONR BAILEYT BALDRIDGE BALLARDE BANDETH BARCHASS BARKSDALE BARNESJ BARONJ BELLD BENDERA BENDERRM BENNETT BERNSTEIN BIOLOGY BIOLOGY2 BOOKEXCH BOYLESE BRANGIFT BRASCHF BREERC BRICKERF BROOKSC BRUSHIST BRUSHISTI BRUSLIT BRUSLITI BURDJ BURNELLG BURROWSD CAFAROC CAGLEA CAMPBELLR CANFIELDD CARNOCHAN CELEBFUND CHAMBERLA CHEM CHEMGIFT CHICANO CHINAHV CHINART CHINEXCHG CHJPDOC CHUCKF CLASS1965 CLASS1970 CLASSICS CLEBSCH CLEBSCHW CLEMENTM COCHRANS COFFINJ COHNA COMM COMPRACEC CONNOLLYG COTRELLE CRAIGW CRARYG CROWL CULTSTUD CUSICKJ DATAFILE DATAFILE2 DAVESD DAVISJ DENNINGR DIGICORP DINSMOREM DIROFF DOBBSMELT DONNELLD DUPSOLD DUTTONR EALJAPAN EALMOORE EARTHSCI EARTHSCIM EASTASIA EASTASTVI EBOOKS ECON EDGRENR EDUC EEURDOC EGGERE ELIOTM ENG ENGGIFT ENVIROPOP ESBENSHAD FALCONERF FEHRENBAC FELTONC FEMINIST FIELD FILMPERF FITGERWIL FITZHUGHW FLAHERTYM FORDJ FORDOC FORLANGI FOXS FRANKENST FRANKLHUM FRIENDE FRITDOC FRYBERGER GALLAGHER GALTCOBL GAYLES GEBALLET GENACQ GENGIFT GENREF GENSER GERMANIC GIFTSPPRO GOLDMANR GOLDSTEIN GOODANB GORDONA GOVINFOI GREENC GREENW GROMMONA GUNSTM GWAUDOC HADERLIEE HAEFNERJ HAMMONDA HANNA HANNAP HARRASSOW HARRISJ HARRISL HAUGH HAWES HAYFER HEARST HENMULLER HERRICK HERTLEINL HERTLEINM HESS HILLMAN HIRSCHMAN HISTSCI HMSHO HOBSON HOPKINS HORTON HOWELL1 HOWELL2 HUMINST HUMREF HVACQ INFOACC INFOACCDS INSTSOFTW INTLDOC JACKMANC JACKMAND JACOBSONM JAGELS JAPANHV JAY JEWELFUND JEWISH JOHNSONJ JOHNSONW JONESR JONESW JORDAN KARLE KATSEV KATZEVA KATZEVS KAY KAYSTEEVE KEMBLE KENNEDY KIBLER KIM KIMBALL KITTLE KLEINH KLEINM KLINEROET KNAPPI KNAPPJ KOOPERMAN KOREAN KORFDNGR KUMM KUMMA KUMMFF KUMMFG KUMMH KUMMM KUMMS KWOKB KWOKL LANEWEST LANZ LATAM LATAMIDOC LEITER LEWIS LINDER LINGUIST LIS LITFRANKL LITTAUER LITTPOET LMBSP LOWENTHAL LYMAN LYMANAWAR LYNCH MAHARAM MARKUS MARTINEAU MASON MATHCOMP MCCAMENT MCCULLOUG MCDOWELL MEDIAACQ MEDIAINST MEDIARES MEDIEVAL MEMFUND MEYERBORE MEYERRES MEYERRES2 MGATES MIDEAST MILNE MIRRIELEE MIZOTA MONOORD MORGAN MORRISON MOSER MOULTON MUFFLEY MULLERMCC MUNGER MUNRO MUSIC MUSICARS MUSICSCO MUSICSOU MYERS NIELSEN NISHINO NOFUND NUGGETS OBERLIN OFFEN PAGE PAYNEB PAYNER PECK PERFARTS PERRETTE PERRY PETERSONG PHILBRICK PHILOSOPH PHYSGIFT PHYSICS POLISCI PORTWOOD POYET PRICE PROTHRO PSYCH QUILLEN RASMUSSEN REHNBORGC REHNBORGJ REINERT RELIGION RESEVAL RESMAT RESMATBK RESMATCEN RESMATEND RESMATNEY RESMATOPP RITTER RIXON ROBUSTELL ROMANCE ROSE ROSENBAUM ROSENBERG ROSENBLAT ROSS RUEEUR SAMSON SASIA SASIABUDD SCHIRESON SCITECHI SEASIAPAC SHAFTEL SHARP SHARPS SHAVER SHELDON SHOUP SIEVERS SILIGENE SIMPSON SKINNER SMALL SMORTCHEV SNEDDEN SOARES SOC SOCSCII SOCSCIREF SOWERS SPAPOR SPEC SPECGIFT STAFFREF STANDISH STARLING STATEDOC STEEL STEINBERG STEINMETZ STEVENS STRUBLE SUNDERMEY TANENBAUM TANNERMEM TANNERREL TARBELL TAXACCREV THOMASC THOMASR THOMPSONP THOMPSONW THORPE TIERNAN UARCH UARCHGIFT UKCANDOC ULIBRES USDOC VANWYCK VICKERS1 VICKERS2 VONSCHLE WALLER WARREN WATT WEBB WEBSTER WEISS WEURSOC WEYBURN WHITEHEAD WICKERSHA WIEL WIGGINS WILSON WOOD WOODBURN WOODYATT WREDENB WYATT YOUNGH YOUNGHMAP ZALK ZENOFF".split(" ");
  
  init();

  function init() { 
    $('#payment_fund').autocomplete(data);

    acquisitionsActionsBindToggle('send_to_acquisitions');	 
    acquisitionsActionsBindToggle('delete_this_selection');
    acquisitionsActionsBindToggle('comment_to_selector');	 
  }

  $('#text_title').click(function() { 
	editTextOnClick('title');
  });

  $('#input_title').blur(function() { 	
	editTextOnBlur('title');	
	var pars = {"eem[title]" : $('#input_title').val()};
	eemUpdate(pars);	
  });

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
	
	  if (name == 'notify') {
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
	
	  if (name == 'notify') {
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

  $('#noop').change(function() {
    var pars = {};

    if ($('#noop:checked').is(':checked')) {
	  pars["eem[notify]"] = $('#input_notify').attr('value');
	  if ($('#input_notify').attr('value') == '') { 
		$('#input_notify').show();	  	  
	    $('#edit_notify').html('save');
        $('#edit_notify').show();
	  }
    }
    else {	 
	  pars["eem[notify]"] = '';
	  $('#input_notify').attr('value', '')	
	  $('#link_notify').attr('href', '#')	
	  $('#link_notify').html('')		
	  $('#edit_notify').html('save');
	  $('#edit_notify').hide();
	  $('#input_notify').hide();
    }	    
    
    eemUpdate(pars);
  });


  $('#edit_notify').click(function() { 
    editLink('notify');
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
