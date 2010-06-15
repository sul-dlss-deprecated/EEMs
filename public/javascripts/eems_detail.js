$(document).ready(function() {

  var token = window._token;
  var pid = window._pid;
  var listLanguages = "Arabic Chinese English French German Hebrew Italian Japanese Korean Russian Spanish Other".split(" ");
  var data = "ABBASI ABBOTT ABERCROMB ABRAHAMSW ACKERMANR AFRICA AFRICADOC AHNE ANTHRO AREASTREF ARONSONB ARSGIFT ARTARCH ASHENR ASUL ASULMEM ASULRES AVERYC BACKERM BACONR BAILEYT BALDRIDGE BALLARDE BANDETH BARCHASS BARKSDALE BARNESJ BARONJ BELLD BENDERA BENDERRM BENNETT BERNSTEIN BIOLOGY BIOLOGY2 BOOKEXCH BOYLESE BRANGIFT BRASCHF BREERC BRICKERF BROOKSC BRUSHIST BRUSHISTI BRUSLIT BRUSLITI BURDJ BURNELLG BURROWSD CAFAROC CAGLEA CAMPBELLR CANFIELDD CARNOCHAN CELEBFUND CHAMBERLA CHEM CHEMGIFT CHICANO CHINAHV CHINART CHINEXCHG CHJPDOC CHUCKF CLASS1965 CLASS1970 CLASSICS CLEBSCH CLEBSCHW CLEMENTM COCHRANS COFFINJ COHNA COMM COMPRACEC CONNOLLYG COTRELLE CRAIGW CRARYG CROWL CULTSTUD CUSICKJ DATAFILE DATAFILE2 DAVESD DAVISJ DENNINGR DIGICORP DINSMOREM DIROFF DOBBSMELT DONNELLD DUPSOLD DUTTONR EALJAPAN EALMOORE EARTHSCI EARTHSCIM EASTASIA EASTASTVI EBOOKS ECON EDGRENR EDUC EEURDOC EGGERE ELIOTM ENG ENGGIFT ENVIROPOP ESBENSHAD FALCONERF FEHRENBAC FELTONC FEMINIST FIELD FILMPERF FITGERWIL FITZHUGHW FLAHERTYM FORDJ FORDOC FORLANGI FOXS FRANKENST FRANKLHUM FRIENDE FRITDOC FRYBERGER GALLAGHER GALTCOBL GAYLES GEBALLET GENACQ GENGIFT GENREF GENSER GERMANIC GIFTSPPRO GOLDMANR GOLDSTEIN GOODANB GORDONA GOVINFOI GREENC GREENW GROMMONA GUNSTM GWAUDOC HADERLIEE HAEFNERJ HAMMONDA HANNA HANNAP HARRASSOW HARRISJ HARRISL HAUGH HAWES HAYFER HEARST HENMULLER HERRICK HERTLEINL HERTLEINM HESS HILLMAN HIRSCHMAN HISTSCI HMSHO HOBSON HOPKINS HORTON HOWELL1 HOWELL2 HUMINST HUMREF HVACQ INFOACC INFOACCDS INSTSOFTW INTLDOC JACKMANC JACKMAND JACOBSONM JAGELS JAPANHV JAY JEWELFUND JEWISH JOHNSONJ JOHNSONW JONESR JONESW JORDAN KARLE KATSEV KATZEVA KATZEVS KAY KAYSTEEVE KEMBLE KENNEDY KIBLER KIM KIMBALL KITTLE KLEINH KLEINM KLINEROET KNAPPI KNAPPJ KOOPERMAN KOREAN KORFDNGR KUMM KUMMA KUMMFF KUMMFG KUMMH KUMMM KUMMS KWOKB KWOKL LANEWEST LANZ LATAM LATAMIDOC LEITER LEWIS LINDER LINGUIST LIS LITFRANKL LITTAUER LITTPOET LMBSP LOWENTHAL LYMAN LYMANAWAR LYNCH MAHARAM MARKUS MARTINEAU MASON MATHCOMP MCCAMENT MCCULLOUG MCDOWELL MEDIAACQ MEDIAINST MEDIARES MEDIEVAL MEMFUND MEYERBORE MEYERRES MEYERRES2 MGATES MIDEAST MILNE MIRRIELEE MIZOTA MONOORD MORGAN MORRISON MOSER MOULTON MUFFLEY MULLERMCC MUNGER MUNRO MUSIC MUSICARS MUSICSCO MUSICSOU MYERS NIELSEN NISHINO NOFUND NUGGETS OBERLIN OFFEN PAGE PAYNEB PAYNER PECK PERFARTS PERRETTE PERRY PETERSONG PHILBRICK PHILOSOPH PHYSGIFT PHYSICS POLISCI PORTWOOD POYET PRICE PROTHRO PSYCH QUILLEN RASMUSSEN REHNBORGC REHNBORGJ REINERT RELIGION RESEVAL RESMAT RESMATBK RESMATCEN RESMATEND RESMATNEY RESMATOPP RITTER RIXON ROBUSTELL ROMANCE ROSE ROSENBAUM ROSENBERG ROSENBLAT ROSS RUEEUR SAMSON SASIA SASIABUDD SCHIRESON SCITECHI SEASIAPAC SHAFTEL SHARP SHARPS SHAVER SHELDON SHOUP SIEVERS SILIGENE SIMPSON SKINNER SMALL SMORTCHEV SNEDDEN SOARES SOC SOCSCII SOCSCIREF SOWERS SPAPOR SPEC SPECGIFT STAFFREF STANDISH STARLING STATEDOC STEEL STEINBERG STEINMETZ STEVENS STRUBLE SUNDERMEY TANENBAUM TANNERMEM TANNERREL TARBELL TAXACCREV THOMASC THOMASR THOMPSONP THOMPSONW THORPE TIERNAN UARCH UARCHGIFT UKCANDOC ULIBRES USDOC VANWYCK VICKERS1 VICKERS2 VONSCHLE WALLER WARREN WATT WEBB WEBSTER WEISS WEURSOC WEYBURN WHITEHEAD WICKERSHA WIEL WIGGINS WILSON WOOD WOODBURN WOODYATT WREDENB WYATT YOUNGH YOUNGHMAP ZALK ZENOFF".split(" ");  
  var defaultValues = {
	"title" : "Click to add title", 
    "creatorName" : "Click to add creator name", 
    "note" : "Click to add citations, comments, etc."
  };

  init();

  function init() { 
    $('#payment_fund').autocomplete(data);

    acquisitionsActionsBindToggle('send_to_tech_services');	 
    acquisitionsActionsBindToggle('delete_this_selection');
    acquisitionsActionsBindToggle('comment_to_selector');	 

    $.each(['creatorName', 'note'], function(index, name) {
	  if ($('#text_' + name).html() == '') {
	    $('#text_' + name).html("<span class='text_placeholder'>" + defaultValues[name] + "</span>");
	  }
    });
  }

  // Title - inline edit
  $('#text_title').click(function() { 
	editTextOnClick('title');
  });

  $('#input_title').blur(function() { 	
	editTextOnBlur('title');	
	var pars = {"eem[title]" : $('#input_title').val()};
	eemUpdate(pars);	
  });

  // Creator Name - inline edit 
  $('#text_creatorName').click(function() { 
	editTextOnClick('creatorName');
  });

  $('#input_creatorName').blur(function() { 	
	editTextOnBlur('creatorName');	
	updateCreator();
  });

  // Creator Type
  $('#eem_creatorType').change(function() {
	updateCreator();	
  });

  function updateCreator() {
	var pars = {};
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

	eemUpdate(pars);	
  }

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

	var pars = {"eem[note]" : noteValue};
	eemUpdate(pars);
  });

  
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

  function editLink(name) {	
    if ($('#edit_' + name).text() == 'edit') { 	
	  var url = $('#link_' + name).attr('href');
	
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

  // Language 
  $('#eem_language').change(function() {	
	var pars = {"eem[language]" : $('#eem_language').val()};
	eemUpdate(pars);
  });

  // Copyright
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

  // Payment Status
  $('#eem_paymentType').change(function() {	
	var pars = {};
	pars["eem[paymentType]"] = $('#eem_paymentType').val();
	
	if ($('#eem_paymentType').val() == 'Paid') {
	  pars["eem[paymentFund]"] = $('#paymentFund').val();
      $('#payment_fund').show();	
	}
	else {
	  pars["eem[paymentFund]"] = '';
	  $('#payment_fund').hide();	
	}
	
	eemUpdate(pars);
  });

  // Payment fund 
  $('#payment_fund').result(function(event, data, formatted) { 
	var value = !data ? "" : formatted;
    var pars = {"eem[paymentFund]" : value};
    eemUpdate(pars);
  });

  // Ajax updater
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

  // Toggle function for 'actions' boxes
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

  function unescapeTags(value) {
    value = value.replace(/>/gi, "&gt;");
    value = value.replace(/</gi, "&lt;");
    return value;
  }

  function escapeTags(value) {
    value = value.replace(/&gt;/gi, ">");
    value = value.replace(/&lt;/gi, "<");
    return value;
  }

}); 
