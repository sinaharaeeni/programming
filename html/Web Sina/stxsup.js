function salavat(msg_before,msg_after) {
alert(msg_before);
	var req = ajax_init(false);
	if( ! req ) { return; }
	req.onreadystatechange	= function() {
		if( req.readyState != 4  ) { return; }
		var txt	= $.trim(req.responseText);
		var salarr=txt.split(":");
		
		if( salarr[0] != "OK" ) { return; }
		slim_msgbox(msg_after);
		txt1	= salarr[2];
		txt2	= salarr[1];
		$("#mysal_num").html(txt1);
		$("#allsal_num").html(txt2);
	}
	req.open("POST", siteurl+"ajax/salavat/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("type=ajax");
	$("#mysal_num").html('<img src="'+siteurl+'themes/'+theme+'/imgs/fbloader.gif">');
	$("#allsal_num").html('<img src="'+siteurl+'themes/'+theme+'/imgs/fbloader.gif">');
}

function more_comment(postid){
	var req = ajax_init(false);
	var s = $("#more_comment_content_"+postid).html();
	var pg = $("#comment_page_"+postid).attr("coid");
	if ( pg == 0 ) return;
	$("#comment_page_"+postid).attr("coid",0);
	if( ! req ) { return; }
		req.onreadystatechange	= function() {
			if( req.readyState != 4  ) { return; }
			var txt	= $.trim(req.responseText);
			if( txt.substr(0,3) != "OK:" ) { return; }
			txt	= $.trim(txt.substr(3));
			if( txt.substr(0,1) == "0" ) { 
				$("#comment_page_"+postid).slideUp("slow");
				txt	= $.trim(txt.substr(2));
			} else {
				txt = txt.split("!page!");
				$("#comment_page_"+postid).attr("coid",txt[0]);
				txt	= txt[1];
			}
			$("#more_comment_content_"+postid).html(txt+s);
		}
	req.open("POST", siteurl+"ajax/load-more/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("tp=8&id="+encodeURIComponent(postid)+"&coid="+pg);
	$("#more_comment_content_"+postid).html('<center><img src="'+siteurl+'themes/'+theme+'/imgs/ajax-loader.gif"></center>'+s);
}
function fixed_post(postid,type,msg_after) {
		 var req = ajax_init(false);
			if( ! req ) { return; }
						req.onreadystatechange	= function() {
						if( req.readyState != 4  ) {return; }
							if( req.responseText != "OK" ) { return; }
							if(msg_after) {
								slim_msgbox(msg_after);
							}
			posts_synchronize();
						}
						req.open("POST", siteurl+"ajax/fixedpost/r:"+Math.round(Math.random()*1000), true);
						req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
						req.send("type="+type+"&postid="+encodeURIComponent(postid));
}
function unfixed_post(postid,type,msg_after) {
						var req = ajax_init(false);
						if( ! req ) { return; }
						req.onreadystatechange	= function() {
							if( req.readyState != 4  ) {return; }
							if( req.responseText != "OK" ) { return; }
							if(msg_after) {
								slim_msgbox(msg_after);
							}
			posts_synchronize();
						}
						req.open("POST", siteurl+"ajax/unfixedpost/r:"+Math.round(Math.random()*1000), true);
						req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
						req.send("type="+type+"&postid="+encodeURIComponent(postid));
}

function mood(){
					var my_mood =document.getElementById("moods").value;
	var req = ajax_init(false);
	if( ! req ) { return; }
		req.onreadystatechange	= function() {
			if( req.readyState != 4  ) { return; }
			var txt	= $.trim(req.responseText);
			$("mood_submit").html(txt);
		}
	req.open("POST", siteurl+"ajax/mood/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("mood="+my_mood);					 
	$("mood_submit").html('<img src="'+siteurl+'themes/'+theme+'/imgs/fbcloader.gif">');
}


function topic(msg_after){
	var my_topic =document.getElementById("topics").value;
	var req = ajax_init(false);
	if( ! req ) { return; }
		req.onreadystatechange	= function() {
			if( req.readyState != 4  ) { return; }
			if(msg_after) {
				slim_msgbox(msg_after);
			}
			var txt	= $.trim(req.responseText);
			$("topic_submit").html(txt);
		}
	req.open("POST", siteurl+"ajax/topic/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("topic="+my_topic);					 
	$("topic_submit").html('<img src="'+siteurl+'themes/'+theme+'/imgs/fbcloader.gif">');
}

function load_smile(postid){
	var req = ajax_init(false);
 	if( ! req ) { return; }
		req.onreadystatechange	= function() {
			if( req.readyState != 4  ) { return; }
			var txt	= $.trim(req.responseText);
			$("#shrtrnx-container").html(txt);
			$("#ajax_smileys_loading").hide();
		}
	req.open("POST", siteurl+"ajax_smily/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("pg="+encodeURIComponent(postid));
	$("#ajax_smileys_loading").show();
}
$(document).ready(function(){$('img#shrtrnx-smiley').click(function(){if($('#shrtrnx-smiley-container').css('display')=="block"){$('#shrtrnx-container').hide('fast',function(){$('#load_smiley').slideUp('fast');$('#shrtrnx-smiley-container').slideUp('fast');});}else{ajax_smileys(1);$('#shrtrnx-smiley-container').slideDown('slow',function(){$('#load_smiley').slideDown('fast');$('#shrtrnx-container').show('fast');$('#ajax_smileys_loading').fadeOut();});}});$('img.shrtrnx-smiley-img').mouseover(function(){$(this).css('backgroundColor','#cccccc');});$('img.shrtrnx-smiley-img').mouseout(function(){$(this).css('backgroundColor','');});$('img.shrtrnx-smiley-img').click(function(){insertText("message",$(this).attr("alt"),"post_form");});});function ajax_smileys(page){$('#ajax_smileys_loading').fadeIn();$.post(siteurl+'ajax/smily/','page='+encodeURIComponent(page),function(data){$('#shrtrnx-container').html(data).hide(0).fadeIn('slow');$('#ajax_smileys_loading').fadeOut();$('a#submit').css({'background-color':'#6e97ac'});$('a[rel*=spage'+page+']').css({'background-color':'#52819a'});});};function ajax_smileys_comment(cm_id,page){$('#ajax_csmileys_loading_'+cm_id).fadeIn();$.post(siteurl+'ajax/csmily/','page='+encodeURIComponent(page)+'&cm_id='+encodeURIComponent(cm_id),function(data){$('#shrtrnx-container_cm_'+cm_id).html(data).hide(0).fadeIn('slow');$('#ajax_csmileys_loading_'+cm_id).fadeOut('slow');$('a#submit').css({'background-color':'#6e97ac'});$('a[rel*=cspage'+page+']').css({'background-color':'#52819a'});});};function smileys_comment(cm_id,page){if($('#box_postcomments_'+cm_id+'_textarea').css('display')=="block"){$('#box_postcomments_'+cm_id+'_textarea').slideUp('fast');}else{$('.cm_smileys').slideUp('fast');$('#ajax_csmileys_loading_'+cm_id).fadeIn();$('#box_postcomments_'+cm_id+'_textarea').slideDown('slow');ajax_smileys_comment(cm_id,1);}}
function insertatcm(myField,myValues){var startPos=myField.selectionStart;var endPos=myField.selectionEnd;myField.value=myField.value.substring(0,startPos)+myValues+myField.value.substring(endPos,myField.value.length);}
$(document).ready(function(){$('img#shrtrnx-smiley-img').mouseover(function(){$(this).css('backgroundColor','#cccccc');});$('img#shrtrnx-smiley-img').mouseout(function(){$(this).css('backgroundColor','');});$('img#shrtrnx-smiley-img').click(function(){insertatcm(document.getElementById('postcomments_'+$(this).attr("class")+'_textarea'),$(this).attr("alt"));});});function add_code_in_comment(textarea,myField,type){var select_cm_message=(textarea.value).substring(textarea.selectionStart,textarea.selectionEnd);if(select_cm_message){if(type=="bold"){var bolding="[M]";var bolding2="[/M]";}else{var bolding="";var bolding2="";}
var outiner=bolding+select_cm_message+bolding2;if(myField.selectionStart==0||myField.selectionStart=='0'){var startPos=myField.selectionStart;var endPos=myField.selectionEnd;myField.value=myField.value.substring(0,startPos)+outiner+myField.value.substring(endPos,myField.value.length);}else{var startPos=myField.selectionStart;var endPos=myField.selectionEnd;myField.value=myField.value.substring(0,startPos)+outiner+myField.value.substring(endPos,myField.value.length);}}
return false;}

function disable_comment(postid,type,msg_after)
{
	var req = ajax_init(false);
	if( ! req ) { return; }
	req.onreadystatechange	= function() {
		if( req.readyState != 4  ) { return; }
		if( req.responseText != "OK" ) { return; }
			if(msg_after) {
	slim_msgbox(msg_after);
	}
	if( d.getElementById("viewpost") ) {
		viewpost_synchronize();
		} else {
		posts_synchronize_single(postid);
		}
	}
	req.open("POST", siteurl+"ajax/discomment/r:"+Math.round(Math.random()*1000), true);
	req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	req.send("postid="+encodeURIComponent(postid)+"&type="+encodeURIComponent(type));
}

var scrolltotop={
	//startline: Integer. Number of pixels from top of doc scrollbar is scrolled before showing control
	//scrollto: Keyword (Integer, or "Scroll_to_Element_ID"). How far to scroll document up when control is clicked on (0=top).
	setting: {startline:100, scrollto: 0, scrollduration:1000, fadeduration:[500, 100]},
	controlHTML: abzar, //HTML for control, which is auto wrapped in DIV w/ ID="topcontrol"
	controlattrs: {offsetx:5, offsety:5}, //offset of control relative to right/ bottom of window corner
	anchorkeyword: '#top', //Enter href value of HTML anchors on the page that should also act as "Scroll Up" links

	state: {isvisible:false, shouldvisible:false},

	scrollup:function(){
		if (!this.cssfixedsupport) //if control is positioned using JavaScript
			this.$control.css({opacity:0}) //hide control immediately after clicking it
		var dest=isNaN(this.setting.scrollto)? this.setting.scrollto : parseInt(this.setting.scrollto)
		if (typeof dest=="string" && jQuery('#'+dest).length==1) //check element set by string exists
			dest=jQuery('#'+dest).offset().top
		else
			dest=0
		this.$body.animate({scrollTop: dest}, this.setting.scrollduration);
	},

	keepfixed:function(){
		var $window=jQuery(window)
		var controlx=$window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx
		var controly=$window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety
		this.$control.css({left:controlx+'px', top:controly+'px'})
	},

	togglecontrol:function(){
		var scrolltop=jQuery(window).scrollTop()
		if (!this.cssfixedsupport)
			this.keepfixed()
		this.state.shouldvisible=(scrolltop>=this.setting.startline)? true : false
		if (this.state.shouldvisible && !this.state.isvisible){
			this.$control.stop().animate({opacity:1}, this.setting.fadeduration[0])
			this.state.isvisible=true
		}
		else if (this.state.shouldvisible==false && this.state.isvisible){
			this.$control.stop().animate({opacity:0}, this.setting.fadeduration[1])
			this.state.isvisible=false
		}
	},
	
	init:function(){
		jQuery(document).ready(function($){
			var mainobj=scrolltotop
			var iebrws=document.all
			mainobj.cssfixedsupport=!iebrws || iebrws && document.compatMode=="CSS1Compat" && window.XMLHttpRequest //not IE or IE7+ browsers in standards mode
			mainobj.$body=(window.opera)? (document.compatMode=="CSS1Compat"? $('html') : $('body')) : $('html,body')
			mainobj.$control=$('<div id="topcontrol">'+mainobj.controlHTML+'</div>')
				.css({position:mainobj.cssfixedsupport? 'fixed' : 'absolute', bottom:mainobj.controlattrs.offsety, right:mainobj.controlattrs.offsetx, opacity:0, cursor:'pointer'})
				.attr({title:'Scroll Back to Top'})
				.click(function(){mainobj.scrollup(); return false})
				.appendTo('body')
			if (document.all && !window.XMLHttpRequest && mainobj.$control.text()!='') //loose check for IE6 and below, plus whether control contains any text
				mainobj.$control.css({width:mainobj.$control.width()}) //IE6- seems to require an explicit width on a DIV containing text
			mainobj.togglecontrol()
			$('a[href="' + mainobj.anchorkeyword +'"]').click(function(){
				mainobj.scrollup()
				return false
			})
			$(window).bind('scroll resize', function(e){
				mainobj.togglecontrol()
			})
		})
	}
}

scrolltotop.init()
